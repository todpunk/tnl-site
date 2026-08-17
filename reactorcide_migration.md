# Reactorcide configuration

This repository uses native Reactorcide workflows. Reactorcide finds the
workflow files in `.reactorcide/workflows/`. It does not need a lifecycle
plugin.

## Workflow IDs

The workflows have these stable security IDs:

- `tnl-site-pr-checks`
- `tnl-site-release`
- `tnl-site-version-deploy`

Do not change an ID only to change a display name. A secret grant or a trusted
CI policy can use the ID.

## Event flow

The pull request workflow tests the container build. It runs for
`pull_request_opened` and `pull_request_updated` on `main`.

The release workflow updates the version after `pull_request_merged` on
`main`. The merge job pushes the new `VERSION.txt` value. This push starts the
version deploy workflow. The deploy workflow only matches a `push` to `main`
that changes `content/extra_files/VERSION.txt`.

The deploy starts from the pushed commit. Therefore, it reads the new version
from that commit. Do not make it a child of the merge job. A child job would
use the source reference from the merge event.

## Runner image

Each job uses this public image:

```text
containers.catalystsquad.com/public/reactorcide/runnerbase:latest
```

Set the project evaluator to the same image before you merge a workflow
change. Then read the project configuration and confirm the value.

## Secrets

The repository keeps only secret references in its job files. The GitHub token
belongs to the `pr-merge-workflow` node. The registry and Kubernetes secrets
belong to the `build-and-deploy` node.

Use a narrow secret grant for each node. Limit the grant by project, event,
execution profile, and CI origin when these limits apply.

## Validation

Run each important event with `reactorcide run-local`. Use `--dry-run` for the
merge and deploy workflows. This option prevents a version push and a live
deployment. Use `--changed-file content/extra_files/VERSION.txt` for the push
event so that Reactorcide tests the path rule.
