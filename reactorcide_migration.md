# Reactorcide Migration Plan for tnl-site

Migrating CI/CD from GitHub Actions to Reactorcide eval job system.

## Status Tracking

### Phase 0: Prerequisites
- [x] 0.1 Authenticate `gh` CLI with GITHUB_PAT
- [x] 0.2 Retrieve reactorcide API token from secrets

### Phase 1: Secrets
- [x] 1.1 Generate webhook secret
- [x] 1.2 Store webhook secret in reactorcide secrets
- [x] 1.3 Configure server with `REACTORCIDE_VCS_GITHUB_SECRET` env var
- [x] 1.4 Store GitHub PAT in reactorcide secrets at `tnl-site/github:token`
- [x] 1.5 Copy kubeconfig to `tnl-site/k8s:kubeconfig`
- [x] 1.6 Set registry password at `tnl-site/registry:password`

### Phase 2: Reactorcide Project
- [x] 2.1 Create project via API with all event types enabled

### Phase 3: Code Changes
- [x] 3.1 Create `.reactorcide/jobs/build-and-deploy.yaml` (eval format)
- [x] 3.2 Create `.reactorcide/jobs/pr-merge-workflow.yaml` (eval format)
- [x] 3.3 Delete old-format `jobs/build-and-deploy.yaml`
- [x] 3.4 Delete old-format `jobs/version-bump.yaml`
- [x] 3.5 Delete old-format `jobs/pr-merge-workflow.yaml`
- [x] 3.6 Update `jobs/README.md`
- [ ] 3.7 Git commit and push (user action)

### Phase 4: GitHub Webhook
- [x] 4.1 Register webhook via `gh api`
- [x] 4.2 Verify webhook registration

### Phase 5: Verification
- [ ] 5.1 Check webhook deliveries
- [ ] 5.2 Check reactorcide eval job creation
- [ ] 5.3 End-to-end test (push or PR merge)

---

## Reference Commands

### Phase 0

```bash
# 0.1 Auth gh CLI
echo "$GITHUB_PAT" | gh auth login --with-token

# 0.2 Set up env vars
export REACTORCIDE_SECRETS_PASSWORD="$(cat ~/.reactorcide-pass)"
export REACTORCIDE_BIN=/home/todhansmann/repos/catalystcommunity/reactorcide/coordinator_api/reactorcide
export REACTORCIDE_API_TOKEN=$($REACTORCIDE_BIN secrets get reactorcide/k8s api_token)
```

### Phase 1

```bash
# 1.1 Generate webhook secret
WEBHOOK_SECRET=$(openssl rand -hex 32)

# 1.2 Store in reactorcide
$REACTORCIDE_BIN secrets set tnl-site/webhook github_secret -v "$WEBHOOK_SECRET"

# 1.3 Server-side: add REACTORCIDE_VCS_GITHUB_SECRET to server deployment env

# 1.4 Store GitHub PAT
$REACTORCIDE_BIN secrets set tnl-site/github token -v "$GITHUB_PAT"

# 1.5 Copy kubeconfig
KUBECONFIG_VAL=$($REACTORCIDE_BIN secrets get reactorcide/k8s kubeconfig)
$REACTORCIDE_BIN secrets set tnl-site/k8s kubeconfig -v "$KUBECONFIG_VAL"

# 1.6 Registry password (provide actual value)
$REACTORCIDE_BIN secrets set tnl-site/registry password -v "<registry-password>"
```

### Phase 2

```bash
# 2.1 Create project (all 6 event types)
curl -X POST "https://reactorcide.internal-service.com/api/v1/projects" \
  -H "Authorization: Bearer ${REACTORCIDE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "tnl-site",
    "description": "Tod and Lorna static site (pysocha)",
    "repo_url": "github.com/todpunk/tnl-site",
    "enabled": true,
    "target_branches": ["main"],
    "allowed_event_types": [
      "push",
      "pull_request_opened",
      "pull_request_updated",
      "pull_request_merged",
      "pull_request_closed",
      "tag_created"
    ],
    "default_runner_image": "containers.catalystsquad.com/public/reactorcide/runnerbase:dev",
    "default_timeout_seconds": 1800
  }'
```

### Phase 4

```bash
# 4.1 Register GitHub webhook
gh api repos/todpunk/tnl-site/hooks \
  --method POST \
  -f name=web \
  -f active=true \
  -f 'config[url]=https://reactorcide.internal-service.com/api/v1/webhooks/github' \
  -f 'config[content_type]=application/json' \
  -f "config[secret]=${WEBHOOK_SECRET}" \
  --json 'events=["push","pull_request"]'

# 4.2 Verify
gh api repos/todpunk/tnl-site/hooks --jq '.[].config.url'
```

### Phase 5

```bash
# 5.1 Check deliveries
gh api repos/todpunk/tnl-site/hooks --jq '.[0].id' | \
  xargs -I{} gh api repos/todpunk/tnl-site/hooks/{}/deliveries

# 5.2 Check reactorcide jobs
curl -s "https://reactorcide.internal-service.com/api/v1/jobs?limit=5" \
  -H "Authorization: Bearer ${REACTORCIDE_API_TOKEN}" | jq '.jobs[:3]'
```

---

## Architecture

```
GitHub Webhook (push / pull_request)
  -> reactorcide.internal-service.com/api/v1/webhooks/github
  -> Validates HMAC signature
  -> Looks up project by repo URL
  -> Creates eval job
       -> Worker checks out source
       -> Runs: runnerlib eval
       -> Reads .reactorcide/jobs/*.yaml
       -> Matches against event type + branch + paths
       -> Writes triggers.json with matched jobs
       -> Worker creates child jobs:
            push to main         -> build-and-deploy
            PR merged to main    -> pr-merge-workflow -> triggers build-and-deploy
```

## Dependency Graph

```
Phase 0 (auth)
  |-> Phase 1 (secrets) -> Phase 2 (project)
  |-> Phase 4 (webhook) -- needs webhook secret from Phase 1.1
Phase 3 (code) -- independent, must be pushed before Phase 5
Phase 5 (verify) -- needs all above complete
```
