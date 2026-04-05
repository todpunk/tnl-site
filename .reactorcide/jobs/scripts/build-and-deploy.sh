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
# Setup tools
# ================================================
export HOME="${HOME:-/root}"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$HOME/.docker" "$LOCAL_BIN"
export PATH="$LOCAL_BIN:$PATH"

# Install docker CLI if not present
if ! command -v docker &> /dev/null; then
    echo "Installing docker CLI..."
    DOCKER_VERSION=27.5.1
    curl -fsSL "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" -o /tmp/docker.tgz
    tar -xzf /tmp/docker.tgz --strip-components=1 -C "$LOCAL_BIN" docker/docker
    rm /tmp/docker.tgz
fi

# Install crane for pushing to insecure registry
if ! command -v crane &> /dev/null; then
    echo "Installing crane..."
    CRANE_VERSION=0.20.3
    curl -fsSL "https://github.com/google/go-containerregistry/releases/download/v${CRANE_VERSION}/go-containerregistry_Linux_x86_64.tar.gz" -o /tmp/crane.tar.gz
    tar -xzf /tmp/crane.tar.gz -C "$LOCAL_BIN" crane
    rm /tmp/crane.tar.gz
fi

# Install helm if not present
if ! command -v helm &> /dev/null; then
    echo "Installing helm..."
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | USE_SUDO=false HELM_INSTALL_DIR="$LOCAL_BIN" bash
fi

# Install kubectl if not present
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
    curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o "$LOCAL_BIN/kubectl"
    chmod +x "$LOCAL_BIN/kubectl"
fi

# ================================================
# Build Docker Image
# ================================================
echo ""
echo "================================================"
echo "Building Docker Image"
echo "================================================"

# For internal registry (insecure HTTP)
INTERNAL_IMAGE="${REGISTRY_INTERNAL}/${REGISTRY_INTERNAL_PATH}"

# Setup registry auth
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

# Wait for Docker daemon (provided by 'docker' capability)
echo "Waiting for Docker daemon..."
for i in $(seq 1 30); do
    if docker info >/dev/null 2>&1; then
        echo "Docker daemon is ready"
        break
    fi
    if [[ $i -eq 30 ]]; then
        echo "ERROR: Docker daemon not ready after 30 seconds"
        exit 1
    fi
    sleep 1
done

# Build image
echo "Building image: ${INTERNAL_IMAGE}:${VERSION}"
docker build -t "${INTERNAL_IMAGE}:${VERSION}" .

# Save and push via crane (supports insecure registries)
IMAGE_TAR="/tmp/image.tar"
docker save "${INTERNAL_IMAGE}:${VERSION}" -o "${IMAGE_TAR}"

echo "Pushing image via crane..."
crane push --insecure "${IMAGE_TAR}" "${INTERNAL_IMAGE}:${VERSION}"
crane push --insecure "${IMAGE_TAR}" "${INTERNAL_IMAGE}:latest"
rm "${IMAGE_TAR}"
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
