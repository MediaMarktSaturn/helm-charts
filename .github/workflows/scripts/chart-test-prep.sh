#!/bin/bash
set -euo pipefail

echo "::debug::install flux crds"
mkdir -p .tmp
curl -s https://raw.githubusercontent.com/fluxcd/flux2/main/manifests/crds/kustomization.yaml -o .tmp/kustomization.yaml
kubectl create -k .tmp

echo "::debug::install istio crds"
kubectl create -f https://raw.githubusercontent.com/istio/istio/refs/tags/1.27.1/manifests/charts/base/files/crd-all.gen.yaml

echo "::debug::install linkerd cli"
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install-edge | sh
curl --proto '=https' --tlsv1.2 -sSfL https://linkerd.github.io/linkerd-smi/install | sh
export PATH=$PATH:$HOME/.linkerd2/bin/

echo "::debug::install gateway crd"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.3.0/standard-install.yaml

echo "::debug::install linkerd crds via its cli"
linkerd install --crds | kubectl apply -f -

echo "::debug::GKE backendconfig crd"
kubectl create -f .github/workflows/scripts/chart-test-prep/backendconfigs.cloud.google.com.yaml

echo "::debug::install prometheus operator crds"
PROMETHEUS_CRDS_URL="https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds"
kubectl create \
  -f "$PROMETHEUS_CRDS_URL/crd-alertmanagerconfigs.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-alertmanagers.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-podmonitors.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-probes.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-prometheuses.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-prometheusrules.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-servicemonitors.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-thanosrulers.yaml"

echo "::debug::install canary CRD"
kubectl create -f https://raw.githubusercontent.com/fluxcd/flagger/main/artifacts/flagger/crd.yaml

echo "::debug::apply chart preconditions"
kubectl apply -f .github/workflows/scripts/chart-test-prep/preconditions.yaml

