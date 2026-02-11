#!/usr/bin/env bash
set -euo pipefail

echo "================================================"
echo "TNL Site Version Bump"
echo "================================================"

# Change to repo root
cd "${REACTORCIDE_REPOROOT:-/job/src}"

# Configure git
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"

# Setup git auth if token provided
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/todpunk/tnl-site.git"
fi

# Download semver-tags
echo "Downloading semver-tags..."
wget -q https://github.com/catalystsquad/semver-tags/releases/download/v0.3.5/semver-tags.tar.gz -O - | tar -xz

# Run semver-tags
echo "Running semver-tags..."
RESULT=$(./semver-tags run)

# Parse results
PUBLISHED=$(echo "$RESULT" | yq -P ".New_release_published")
NEW_TAG=$(echo "$RESULT" | yq -P ".New_release_git_tag")
LAST_VERSION=$(echo "$RESULT" | yq -P ".Last_release_version")

if [[ "${PUBLISHED}" == "false" ]]; then
    echo "No new version to publish"
    echo "RELEASED_CHANGES=false"
    exit 0
fi

# We have a new version
RELEASED_CHANGES="true"
NEW_VERSION="${NEW_TAG#*v}"

echo "Last Version: ${LAST_VERSION}"
echo "New Tag: ${NEW_TAG}"
echo "New Version: ${NEW_VERSION}"

# Update VERSION.txt
echo "Updating VERSION.txt..."
echo "${NEW_VERSION}" > content/extra_files/VERSION.txt

# Commit and push
git add content/extra_files/VERSION.txt
git commit -m "ci: adding version ${NEW_TAG} to content/extra_files/VERSION.txt"
git push

echo ""
echo "RELEASED_CHANGES=${RELEASED_CHANGES}"
echo "NEW_VERSION=${NEW_VERSION}"

# Write trigger file to start the build-and-deploy job
# This is picked up by reactorcide worker
cat > /job/triggers.json <<EOF
{
  "type": "trigger_job",
  "jobs": [
    {
      "job_name": "build-and-deploy",
      "env": {
        "VERSION": "${NEW_VERSION}"
      },
      "source_type": "git",
      "source_url": "https://github.com/todpunk/tnl-site.git",
      "source_ref": "main"
    }
  ]
}
EOF

echo "Triggered build-and-deploy job for version ${NEW_VERSION}"
