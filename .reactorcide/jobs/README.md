# Reactorcide workflows

Reactorcide reads the native workflow files in `.reactorcide/workflows/`.
Each workflow uses the job files in this directory.

## Workflows

- `pr.yaml` runs `build-test` when a pull request opens or changes.
- `release.yaml` runs `pr-merge-workflow` when a pull request merges.
- `version-push.yaml` runs `build-and-deploy` when `VERSION.txt` changes on
  `main`.

The merge job updates `VERSION.txt` and pushes the change. The push event then
starts the deploy workflow. This event boundary makes the deploy job use the
new commit.

## Secret references

The jobs use these secret references:

- `${secret:tnl-site/github:token}`
- `${secret:tnl-site/registry:user}`
- `${secret:tnl-site/registry:password}`
- `${secret:tnl-site/k8s:kubeconfig}`

Grant each secret to the exact workflow node name that uses it. Use
`pr-merge-workflow` for the GitHub token. Use `build-and-deploy` for the
registry and Kubernetes secrets.

## Local validation

Use the public evaluator image. Dry-run mode validates the workflow without a
push or a deployment.

```bash
reactorcide run-local \
  --dry-run \
  --event pull_request_opened \
  --eval-image containers.catalystsquad.com/public/reactorcide/runnerbase:latest \
  .reactorcide/workflows/pr.yaml

reactorcide run-local \
  --dry-run \
  --event pull_request_updated \
  --eval-image containers.catalystsquad.com/public/reactorcide/runnerbase:latest \
  .reactorcide/workflows/pr.yaml

reactorcide run-local \
  --dry-run \
  --event pull_request_merged \
  --eval-image containers.catalystsquad.com/public/reactorcide/runnerbase:latest \
  .reactorcide/workflows/release.yaml

reactorcide run-local \
  --dry-run \
  --event push \
  --changed-file content/extra_files/VERSION.txt \
  --eval-image containers.catalystsquad.com/public/reactorcide/runnerbase:latest \
  .reactorcide/workflows/version-push.yaml
```
