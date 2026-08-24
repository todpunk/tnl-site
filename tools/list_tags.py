#!/usr/bin/env python3
"""List tags from committed blog posts."""

import ast
import subprocess
import sys
from collections import Counter
from pathlib import Path


BLOG_PATH = "content/blog_posts"


def git(root: Path, *arguments: str) -> str:
    """Run Git and return its standard output."""
    result = subprocess.run(
        ["git", "-C", str(root), *arguments],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout


def committed_posts(root: Path) -> list[str]:
    """Return committed Markdown post paths from HEAD."""
    output = git(root, "ls-tree", "-r", "--name-only", "HEAD", "--", BLOG_PATH)
    return [path for path in output.splitlines() if path.endswith(".md")]


def tags_from_post(path: str, text: str) -> list[str]:
    """Read the Tags list from the post front matter."""
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        raise ValueError(f"Committed post has no front matter: {path}")

    for line in lines[1:]:
        if line.strip() == "---":
            break
        key, separator, value = line.partition(":")
        if separator and key.strip().lower() == "tags":
            parsed = ast.literal_eval(value.strip())
            if not isinstance(parsed, (list, tuple)):
                raise ValueError(f"Tags must be a list: {path}")
            if not all(isinstance(tag, str) and tag for tag in parsed):
                raise ValueError(f"Each tag must be a non-empty string: {path}")
            return list(parsed)

    raise ValueError(f"Committed post has no Tags field: {path}")


def main() -> int:
    """Count and print tags from committed posts."""
    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd()
    counts: Counter[str] = Counter()

    try:
        for path in committed_posts(root):
            counts.update(tags_from_post(path, git(root, "show", f"HEAD:{path}")))
    except (subprocess.CalledProcessError, SyntaxError, ValueError) as error:
        print(error, file=sys.stderr)
        return 1

    print(f"{'COUNT':>5}  TAG")
    for tag, count in sorted(counts.items(), key=lambda item: (-item[1], item[0])):
        print(f"{count:>5}  {tag}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
