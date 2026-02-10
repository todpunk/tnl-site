#!/usr/bin/env bash
set -euo pipefail

echo "================================================"
echo "TNL Site Build and Deploy"
echo "================================================"

# Change to repo root
cd "${REACTORCIDE_REPOROOT:-/job/src}"

# Get version from VERSION.txt
VERSION="$(cat content/extra_files/VERSION.txt)"
echo "Building version: ${VERSION}"

# ================================================
# Build Docker Image
# ================================================
echo ""
echo "================================================"
echo "Building Docker Image"
echo "================================================"

# Install buildctl if not present
if ! command -v buildctl &> /dev/null; then
    echo "Installing buildkit..."
    BUILDKIT_VERSION=0.17.3
    wget -q "https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz" -O /tmp/buildkit.tar.gz
    tar -xzf /tmp/buildkit.tar.gz -C /usr/local
    export PATH="/usr/local/bin:$PATH"
fi

# Setup registry auth for internal registry (HTTP)
export HOME="${HOME:-/root}"
mkdir -p "$HOME/.docker"

# For internal registry (insecure HTTP)
INTERNAL_IMAGE="${REGISTRY_INTERNAL}/${REGISTRY_INTERNAL_PATH}"

# Create auth config
# Note: Internal registry may not require auth, but we set it up if credentials are provided
if [[ -n "${REGISTRY_USER:-}" ]] && [[ -n "${REGISTRY_PASSWORD:-}" ]]; then
    AUTH=$(printf "%s:%s" "$REGISTRY_USER" "$REGISTRY_PASSWORD" | base64 -w 0)
    cat > "$HOME/.docker/config.json" <<EOF
{
  "auths": {
    "${REGISTRY_INTERNAL}": {"auth": "${AUTH}"},
    "${REGISTRY_EXTERNAL}": {"auth": "${AUTH}"}
  }
}
EOF
    echo "Registry authentication configured"
fi

# Build and push image
echo "Building image: ${INTERNAL_IMAGE}:${VERSION}"

# Start buildkitd if needed
if ! pgrep -x "buildkitd" > /dev/null; then
    buildkitd --addr unix:///run/buildkit/buildkitd.sock &
    sleep 2
fi

# Build with buildctl
buildctl build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name="${INTERNAL_IMAGE}:${VERSION}",push=true,registry.insecure=true

# Also tag as latest
buildctl build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name="${INTERNAL_IMAGE}:latest",push=true,registry.insecure=true

echo "Image pushed successfully"

# ================================================
# Deploy to Kubernetes
# ================================================
echo ""
echo "================================================"
echo "Deploying to Kubernetes"
echo "================================================"

# Setup kubeconfig
mkdir -p ~/.kube
echo "${KUBECONFIG_CONTENT}" > ~/.kube/config
chmod 600 ~/.kube/config

# Add Helm repo
helm repo add catalyst-helm https://raw.githubusercontent.com/catalystcommunity/charts/main
helm repo update

# Create namespace if it doesn't exist
kubectl create namespace "${K8S_NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

# Create/update registry pull secret
# Using internal registry for pull since job runs in same cluster
kubectl create secret docker-registry regcred \
    --namespace "${K8S_NAMESPACE}" \
    --save-config \
    --dry-run=client \
    --docker-server="${REGISTRY_INTERNAL}" \
    --docker-username="${REGISTRY_USER:-}" \
    --docker-password="${REGISTRY_PASSWORD:-}" \
    -o yaml | kubectl apply -f -

# Deploy with Helm
echo "Deploying with Helm..."
helm upgrade \
    --install \
    --create-namespace \
    --namespace "${K8S_NAMESPACE}" \
    "${HELM_RELEASE}" \
    "${HELM_CHART}" \
    --version "${HELM_CHART_VERSION}" \
    --set image.repository="${INTERNAL_IMAGE}" \
    --set image.tag="${VERSION}" \
    --set imagePullSecrets[0].name=regcred \
    -f values.yaml

echo ""
echo "================================================"
echo "Deployment complete!"
echo "Version: ${VERSION}"
echo "================================================"
