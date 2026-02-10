#!/usr/bin/env python3
"""
PR Merge Workflow for TNL Site

This workflow handles the CI/CD pipeline when a PR is merged to main:
1. Runs semver-tags to determine if there are releasable changes
2. If changes exist, updates VERSION.txt and commits
3. Triggers the build-and-deploy job

Triggered by: GitHub webhook on PR merge to main
"""
import subprocess
import sys
import os
from pathlib import Path

# Reactorcide workflow helpers
try:
    from workflow import trigger_job, flush_triggers, git_info, WorkflowContext
except ImportError:
    # Fallback for local testing
    print("Warning: workflow module not available, running in standalone mode")
    trigger_job = None
    flush_triggers = None


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

    # Setup auth if token provided
    github_token = os.environ.get("GITHUB_TOKEN")
    if github_token:
        run_command([
            "git", "remote", "set-url", "origin",
            f"https://x-access-token:{github_token}@github.com/todpunk/tnl-site.git"
        ])


def download_semver_tags():
    """Download the semver-tags tool."""
    if Path("./semver-tags").exists():
        print("semver-tags already exists")
        return

    print("Downloading semver-tags...")
    run_command([
        "wget", "-q",
        "https://github.com/catalystsquad/semver-tags/releases/download/v0.3.5/semver-tags.tar.gz",
        "-O", "-"
    ], capture=False)
    # Actually do the download properly
    subprocess.run(
        "wget -q https://github.com/catalystsquad/semver-tags/releases/download/v0.3.5/semver-tags.tar.gz -O - | tar -xz",
        shell=True,
        check=True
    )


def run_semver_tags() -> tuple[bool, str]:
    """
    Run semver-tags and parse the results.
    Returns: (has_new_release, new_version)
    """
    result = run_command(["./semver-tags", "run"])
    output = result.stdout

    # Parse YAML output with yq
    published = subprocess.run(
        ["yq", "-P", ".New_release_published"],
        input=output,
        capture_output=True,
        text=True,
        check=True
    ).stdout.strip()

    if published != "true":
        return False, ""

    new_tag = subprocess.run(
        ["yq", "-P", ".New_release_git_tag"],
        input=output,
        capture_output=True,
        text=True,
        check=True
    ).stdout.strip()

    # Remove 'v' prefix if present
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


def trigger_build_deploy(new_version: str):
    """Trigger the build-and-deploy job."""
    if trigger_job is not None:
        trigger_job(
            "build-and-deploy",
            env={"VERSION": new_version},
            depends_on=[],
            condition="all_success"
        )
        flush_triggers()
        print(f"Triggered build-and-deploy job for version {new_version}")
    else:
        # Write trigger file manually
        import json
        trigger_data = {
            "type": "trigger_job",
            "jobs": [{
                "job_name": "build-and-deploy",
                "env": {"VERSION": new_version},
                "source_type": "git",
                "source_url": "https://github.com/todpunk/tnl-site.git",
                "source_ref": "main"
            }]
        }
        trigger_file = Path("/job/triggers.json")
        trigger_file.write_text(json.dumps(trigger_data, indent=2))
        print(f"Wrote trigger file for build-and-deploy job")


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

    # Trigger build and deploy
    trigger_build_deploy(new_version)

    print("\n" + "=" * 60)
    print(f"Version bump complete: {new_version}")
    print("=" * 60)

    return 0


if __name__ == "__main__":
    sys.exit(main())
