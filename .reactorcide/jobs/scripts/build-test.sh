#!/usr/bin/env bash
set -euo pipefail

echo "================================================"
echo "TNL Site Build Test"
echo "================================================"

# Change to repo root
cd "${REACTORCIDE_REPOROOT:-/job/src}"

# Setup environment
export HOME="${HOME:-/root}"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
export PATH="$LOCAL_BIN:$PATH"

# Install the BuildKit client if it is not present
if ! command -v buildctl &> /dev/null; then
    echo "Installing the BuildKit client..."
    BUILDKIT_VERSION=0.17.3
    curl -fsSL "https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz" -o /tmp/buildkit.tar.gz
    tar -xzf /tmp/buildkit.tar.gz --strip-components=1 -C "$LOCAL_BIN" bin/buildctl
    rm /tmp/buildkit.tar.gz
fi

# Wait for the BuildKit sidecar
echo "Waiting for BuildKit..."
for i in $(seq 1 30); do
    if buildctl debug info >/dev/null 2>&1; then
        echo "BuildKit is ready"
        break
    fi
    if [[ $i -eq 30 ]]; then
        echo "ERROR: BuildKit is not ready after 30 seconds"
        exit 1
    fi
    sleep 1
done

# Build image (just verify it builds)
echo "Building Docker image (test only, no push)..."
IMAGE_TAR="/tmp/tnl-site-test.tar"
buildctl build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output "type=docker,name=tnl-site-test:build,dest=${IMAGE_TAR}"
rm "${IMAGE_TAR}"

echo ""
echo "================================================"
echo "Build test passed!"
echo "================================================"
