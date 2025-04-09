#!/bin/bash
set -euo pipefail

echo "[INFO] install flux crds"
mkdir -p .tmp
curl -s https://raw.githubusercontent.com/fluxcd/flux2/main/manifests/crds/kustomization.yaml -o .tmp/kustomization.yaml
kubectl create -k .tmp

echo "[INFO] install istio crds"
kubectl create -f https://raw.githubusercontent.com/istio/istio/1.22.0/manifests/charts/base/crds/crd-all.gen.yaml

echo "[INFO] install linkerd crds via its cli"
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh
curl --proto '=https' --tlsv1.2 -sSfL https://linkerd.github.io/linkerd-smi/install | sh
export PATH=$PATH:$HOME/.linkerd2/bin/

echo "::debug::install linkerd crds via its cli"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml
linkerd install --crds | kubectl apply -f -

echo "[INFO] GKE backendconfig crd"
kubectl create -f .github/workflows/scripts/chart-test-prep/backendconfigs.cloud.google.com.yaml

echo "[INFO] install prometheus operator crds"
kubectl create \
  -f "$PROMETHEUS_CRDS_URL/crd-alertmanagerconfigs.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-alertmanagers.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-podmonitors.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-probes.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-prometheuses.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-prometheusrules.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-servicemonitors.yaml" \
  -f "$PROMETHEUS_CRDS_URL/crd-thanosrulers.yaml"

echo "[INFO] install canary CRD"
kubectl create -f https://raw.githubusercontent.com/fluxcd/flagger/main/artifacts/flagger/crd.yaml

echo "[INFO] apply chart preconditions"
kubectl apply -f .github/workflows/scripts/chart-test-prep/preconditions.yaml

echo "[INFO] install gateway crd"
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
