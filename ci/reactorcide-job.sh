#!/usr/bin/env bash

echo "I am in CI in the innner root job script"

mkdir -p .kube
touch .kube/config
echo "${CI_KUBECONFIG}" > .kube/config

helm repo add catalyst-helm https://raw.githubusercontent.com/catalystcommunity/charts/main
helm repo update

VERSION="$(cat ${REACTORCIDE_REPOROOT}/content/extra_files/VERSION.txt)"

# Now Helm Chart
helm upgrade \
  --install \
  --create-namespace \
  --namespace tnl-site \
  tnl-site \
  --set image.tag=${VERSION} \
  -f ${REACTORCIDE_REPOROOT}/values.yaml catalyst-helm/pysocha-site \
  --version 1.0.2
