#!/usr/bin/env python3
"""Update the TNL site version after a pull request merges."""
import json
import os
import subprocess
import sys
from pathlib import Path


def run_command(cmd: list[str], check: bool = True, capture: bool = True) -> subprocess.CompletedProcess:
    """Run a shell command and return the result."""
    print(f"Running: {' '.join(cmd)}")
    return subprocess.run(
        cmd,
        check=check,
        capture_output=capture,
        text=True
    )


def setup_git():
    """Configure git for commits."""
    git_user = os.environ.get("GIT_USER_NAME", "Tod Hansmann (automation)")
    git_email = os.environ.get("GIT_USER_EMAIL", "githubpub@todandlorna.com")

    run_command(["git", "config", "--global", "user.name", git_user])
    run_command(["git", "config", "--global", "user.email", git_email])

    # Set up authentication when a token is available.
    github_token = os.environ.get("GITHUB_TOKEN")
    if github_token:
        askpass = Path("/tmp/tnl-site-git-askpass.sh")
        askpass.write_text(
            "#!/usr/bin/env sh\n"
            "case \"$1\" in\n"
            "  *Username*) printf '%s\\n' 'x-access-token' ;;\n"
            "  *) printf '%s\\n' \"$GITHUB_TOKEN\" ;;\n"
            "esac\n"
        )
        askpass.chmod(0o700)
        os.environ["GIT_ASKPASS"] = str(askpass)
        os.environ["GIT_TERMINAL_PROMPT"] = "0"
        run_command([
            "git", "remote", "set-url", "origin",
            "https://github.com/todpunk/tnl-site.git",
        ])

    # Unshallow clone and fetch tags (runner uses shallow clone by default)
    run_command(["git", "fetch", "--unshallow"], check=False)
    run_command(["git", "fetch", "--tags"])

    # Runner checks out by SHA (detached HEAD) — switch to main so we can push
    run_command(["git", "checkout", "main"])


def download_semver_tags():
    """Download the semver-tags tool."""
    if Path("./semver-tags").exists():
        print("semver-tags already exists")
        return

    print("Downloading semver-tags...")
    archive = "/tmp/semver-tags.tar.gz"
    run_command([
        "curl", "-fsSL",
        "https://github.com/catalystsquad/semver-tags/releases/download/v0.3.5/semver-tags.tar.gz",
        "-o", archive,
    ], capture=False)
    run_command(["tar", "-xzf", archive], capture=False)


def run_semver_tags() -> tuple[bool, str]:
    """
    Run semver-tags and parse the results.
    Returns: (has_new_release, new_version)
    """
    result = run_command(["./semver-tags", "run", "--output_json"])
    output = result.stdout.strip()

    # Find the JSON object in output (skip any log lines)
    data = {}
    for line in reversed(output.splitlines()):
        line = line.strip()
        if line.startswith("{"):
            data = json.loads(line)
            break

    if data.get("New_release_published") != "true":
        return False, ""

    new_tag = data.get("New_release_git_tag", "")
    new_version = new_tag.lstrip("v")
    return True, new_version


def update_version_file(new_version: str):
    """Update VERSION.txt with the new version."""
    version_file = Path("content/extra_files/VERSION.txt")
    print(f"Updating {version_file} to {new_version}")
    version_file.write_text(f"{new_version}\n")


def commit_and_push(new_version: str):
    """Commit and push the version change."""
    run_command(["git", "add", "content/extra_files/VERSION.txt"])
    run_command([
        "git", "commit", "-m",
        f"ci: adding version v{new_version} to content/extra_files/VERSION.txt"
    ])
    run_command(["git", "push"])


def main() -> int:
    print("=" * 60)
    print("TNL Site PR Merge Workflow")
    print("=" * 60)

    # Change to repo root
    repo_root = os.environ.get("REACTORCIDE_REPOROOT", "/job/src")
    os.chdir(repo_root)
    print(f"Working directory: {os.getcwd()}")

    # Setup
    setup_git()
    download_semver_tags()

    # Check for new release
    print("\nChecking for releasable changes...")
    has_release, new_version = run_semver_tags()

    if not has_release:
        print("No new version to publish")
        return 0

    print(f"\nNew version: {new_version}")

    # Update version file
    update_version_file(new_version)

    # Commit and push
    commit_and_push(new_version)

    print("\n" + "=" * 60)
    print(f"Version bump complete: {new_version}")
    print("=" * 60)

    return 0


if __name__ == "__main__":
    sys.exit(main())
