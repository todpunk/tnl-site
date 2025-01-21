#!/usr/bin/env bash

echo "I am in CI in the innner root job script"

mkdir -p .kube
touch .kube/config
echo "${CI_KUBECONFIG}" > .kube/config

helm repo add catalyst-helm https://raw.githubusercontent.com/catalystcommunity/charts/main
helm repo update

VERSION="$(cat ${REACTORCIDE_REPOROOT}/content/extra_files/VERSION.txt)"

kubectl create namespace tnl-site --dry-run=client -o yaml | kubectl apply -f -
# This will not work if the secret already exists, so apply it generated from the dry-run
#kubectl create secret --namespace tnl-site docker-registry regcred --docker-server=containerregistry.catalystsquad.com --docker-username="${CONTAINERS_AUTH_USER}" --docker-password="${CONTAINERS_AUTH_PW}"
kubectl create secret docker-registry regcred \
--namespace tnl-site \
--save-config \
--dry-run=client \
--docker-server=containerregistry.catalystsquad.com \
--docker-username="${CONTAINERS_AUTH_USER}" \
--docker-password="${CONTAINERS_AUTH_PW}" \
-o yaml | \
kubectl apply -f -

# Now Helm Chart
helm upgrade \
  --install \
  --create-namespace \
  --namespace tnl-site \
  tnl-site \
  --set image.tag=${VERSION} \
  --set imagePullSecrets[0].name=regcred \
  -f ${REACTORCIDE_REPOROOT}/values.yaml catalyst-helm/pysocha-site \
  --version 1.0.2
