# Reactorcide CI/CD Jobs

This directory contains the reactorcide eval job definitions for building and deploying the TNL site.

## Architecture

```
GitHub Webhook (push / pull_request)
    -> reactorcide.catalystsquad.com/api/v1/webhooks/github
    -> Validates HMAC signature
    -> Creates eval job
         -> Reads .reactorcide/jobs/*.yaml
         -> Matches against event type + branch
         -> Creates child jobs:
              push to main         -> build-and-deploy
              PR merged to main    -> pr-merge-workflow -> version bump + triggers build
```

## Jobs

### build-and-deploy.yaml

Triggers on push to main. Builds the Docker image and deploys to Kubernetes:
- Builds Docker image using buildkit
- Pushes to internal registry at `10.16.0.1:5000/private/todpunk/tnl-site`
- Deploys to Kubernetes using Helm

### pr-merge-workflow.yaml

Triggers on PR merge to main. Handles version bumping and triggers a build:
- Runs `semver-tags` to determine if there are releasable changes
- Updates `content/extra_files/VERSION.txt`
- Commits and pushes the version bump
- The resulting push to main triggers `build-and-deploy`

## Required Secrets

Set these in reactorcide (both CLI and API) before running jobs:

```bash
# Registry credentials
reactorcide secrets set tnl-site/registry password "your-registry-password"

# Kubernetes config
reactorcide secrets set tnl-site/k8s kubeconfig "$(cat ~/.kube/config)"

# GitHub token (for version commits)
reactorcide secrets set tnl-site/github token "ghp_your_token_here"
```

## Registry Configuration

- **Internal Registry**: `http://10.16.0.1:5000` (HTTP, insecure)
- **Image Path**: `private/todpunk/tnl-site`
- **External Registry**: `containers.catalystsquad.com` (HTTPS)

The job pushes to the internal registry, which is accessible from within the Kubernetes cluster.

## Manual Job Execution

To run a job manually:

```bash
# Run build and deploy
reactorcide run-local .reactorcide/jobs/build-and-deploy.yaml

# Run PR merge workflow (version bump)
reactorcide run-local .reactorcide/jobs/pr-merge-workflow.yaml

# Dry run to see what would execute
reactorcide run-local --dry-run .reactorcide/jobs/build-and-deploy.yaml
```
