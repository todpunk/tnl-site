#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pysocha[search-pagefind] @ https://github.com/catalystcommunity/pysocha/archive/fab6f606a5a160964ebe16389637a80de62b4b1d.tar.gz",
# ]
# ///

"""Build and serve the site with the PySocha preview server."""

import argparse
import threading
import time
import traceback
from pathlib import Path

from flask import jsonify
from pysocha import initialize
from pysocha.build import buildSite
from pysocha.preview import makePreviewServer


RELOAD_PATH = "/__tnl_preview_state"
WATCH_DIRECTORIES = ("content", "templates")


class PreviewState:
    """Store the generation number for browser reloads."""

    def __init__(self) -> None:
        self._generation = 0
        self._lock = threading.Lock()

    def generation(self) -> int:
        """Return the current generation number."""
        with self._lock:
            return self._generation

    def advance(self) -> None:
        """Advance the generation number after a successful build."""
        with self._lock:
            self._generation += 1


def port_number(value: str) -> int:
    """Return a valid TCP port number."""
    port = int(value)
    if not 1 <= port <= 65535:
        raise argparse.ArgumentTypeError("port must be between 1 and 65535")
    return port


def arguments() -> argparse.Namespace:
    """Read command-line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default="tnl_config.yaml")
    parser.add_argument("--host", default="0.0.0.0")
    parser.add_argument("--port", type=port_number, default=5080)
    parser.add_argument("--verbose", action="store_true")
    return parser.parse_args()


def load_config(config_path: Path) -> dict:
    """Load the PySocha configuration."""
    with config_path.open(encoding="utf-8") as config_file:
        return initialize(config_file)


def source_signature(root: Path, config_path: Path) -> tuple[tuple[str, int, int], ...]:
    """Return the current state of files that affect the site."""
    paths = [config_path]
    for directory_name in WATCH_DIRECTORIES:
        directory = root / directory_name
        if directory.is_dir():
            paths.extend(path for path in directory.rglob("*") if path.is_file())

    entries = []
    for path in paths:
        try:
            details = path.stat()
        except FileNotFoundError:
            continue
        entries.append((str(path.relative_to(root)), details.st_mtime_ns, details.st_size))
    return tuple(sorted(entries))


def reload_script(generation: int) -> str:
    """Return the browser reload script for one HTML response."""
    return f"""
<script data-tnl-preview-reload>
(() => {{
    const loadedGeneration = {generation};
    window.setInterval(async () => {{
        try {{
            const response = await fetch("{RELOAD_PATH}", {{ cache: "no-store" }});
            const state = await response.json();
            if (state.generation !== loadedGeneration) {{
                window.location.reload();
            }}
        }} catch (_error) {{
            // The preview server can be unavailable during a restart.
        }}
    }}, 1000);
}})();
</script>
"""


def add_reload_support(server, state: PreviewState) -> None:
    """Add preview-only reload endpoints and HTML code."""

    @server.get(RELOAD_PATH)
    def preview_state():
        return jsonify({"generation": state.generation()})

    @server.after_request
    def inject_reload_script(response):
        if response.mimetype != "text/html":
            return response

        response.direct_passthrough = False
        body = response.get_data(as_text=True)
        script = reload_script(state.generation())
        if "</body>" in body:
            body = body.replace("</body>", script + "</body>", 1)
        else:
            body += script
        response.set_data(body)
        return response


def watch_changes(
    root: Path,
    config_path: Path,
    server,
    state: PreviewState,
    verbose: bool,
) -> None:
    """Rebuild the site when a source file changes."""
    observed = source_signature(root, config_path)
    print("Watching content, templates, and site configuration.", flush=True)
    while True:
        time.sleep(0.5)
        current = source_signature(root, config_path)
        if current == observed:
            continue

        while True:
            time.sleep(0.2)
            settled = source_signature(root, config_path)
            if settled == current:
                break
            current = settled

        observed = current
        print("Source change detected. Rebuilding...", flush=True)
        try:
            config = load_config(config_path)
            buildSite(config, verbose=verbose)
            makePreviewServer(
                str(root / config["outputDir"]),
                config["startPage"],
                config["defaultExtension"],
            )
        except Exception:
            print("The preview rebuild failed. The previous site is still available.", flush=True)
            traceback.print_exc()
            continue

        state.advance()
        print("Preview rebuilt. Open browser tabs will reload.", flush=True)


def main() -> None:
    """Build the site and start its preview server."""
    options = arguments()
    root = Path.cwd()
    config_path = (root / options.config).resolve()
    config = load_config(config_path)

    output_dir = root / config["outputDir"]
    server = makePreviewServer(
        str(output_dir),
        config["startPage"],
        config["defaultExtension"],
    )
    server.config["SEND_FILE_MAX_AGE_DEFAULT"] = 5
    buildSite(config, verbose=options.verbose)
    state = PreviewState()
    add_reload_support(server, state)
    watcher = threading.Thread(
        target=watch_changes,
        args=(root, config_path, server, state, options.verbose),
        daemon=True,
        name="tnl-preview-source-watcher",
    )
    watcher.start()
    server.run(host=options.host, port=options.port)


if __name__ == "__main__":
    main()
