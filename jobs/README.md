# Reactorcide CI/CD Jobs

This directory contains the reactorcide job definitions for building and deploying the TNL site.

## Architecture

```
GitHub PR Merge
    ↓
Reactorcide Webhook (reactorcide.internal-service.com)
    ↓
version-bump job
    ↓ (triggers on success)
build-and-deploy job
    ↓
Kubernetes (k8s.internal-service.com)
```

## Jobs

### version-bump.yaml

Handles semantic versioning when a PR is merged to main:
- Runs `semver-tags` to determine if there are releasable changes
- Updates `content/extra_files/VERSION.txt`
- Commits and pushes the version bump
- Triggers the `build-and-deploy` job

### build-and-deploy.yaml

Builds the Docker image and deploys to Kubernetes:
- Builds Docker image using buildkit
- Pushes to internal registry at `10.16.0.1:5000/private/todpunk/tnl-site`
- Deploys to Kubernetes using Helm

## Required Secrets

Set these in reactorcide before running jobs:

```bash
# Registry credentials
reactorcide secrets set tnl-site/registry password "your-registry-password"

# Kubernetes config
reactorcide secrets set tnl-site/k8s kubeconfig "$(cat ~/.kube/config)"

# GitHub token (for version commits)
reactorcide secrets set tnl-site/github token "ghp_your_token_here"
```

## Required Environment Variables

Set these in your reactorcide environment or overlay:

```bash
export REGISTRY_USER="your-registry-username"
```

## Registry Configuration

- **Internal Registry**: `http://10.16.0.1:5000` (HTTP, insecure)
- **Image Path**: `private/todpunk/tnl-site`
- **External Registry**: `containers.catalystsquad.com` (HTTPS)

The job pushes to the internal registry, which is accessible from within the Kubernetes cluster.

## Manual Job Execution

To run a job manually:

```bash
# Run version bump
reactorcide run-local ./jobs/version-bump.yaml

# Run build and deploy directly (uses current VERSION.txt)
reactorcide run-local ./jobs/build-and-deploy.yaml
```

## Webhook Setup (TODO)

To trigger jobs automatically on PR merge:

1. Create a GitHub App or configure a webhook
2. Point it to: `https://reactorcide.internal-service.com/api/v1/webhooks/github`
3. Subscribe to `pull_request` events (type: closed, branch: main)

See reactorcide documentation for webhook configuration details.
