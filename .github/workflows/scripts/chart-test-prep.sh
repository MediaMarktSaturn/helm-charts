#!/bin/bash
set -euo pipefail

# install flux crds
mkdir -p .tmp
curl -s https://raw.githubusercontent.com/fluxcd/flux2/main/manifests/crds/kustomization.yaml -o .tmp/kustomization.yaml
kubectl create -k .tmp

# install istio crds
kubectl create -f https://raw.githubusercontent.com/istio/istio/1.22.0/manifests/charts/base/crds/crd-all.gen.yaml

# install linkerd crds via its cli
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh
curl --proto '=https' --tlsv1.2 -sSfL https://linkerd.github.io/linkerd-smi/install | sh
export PATH=$PATH:$HOME/.linkerd2/bin/
linkerd install --crds | kubectl apply -f -

# GKE backendconfig crd
kubectl create -f .github/workflows/scripts/chart-test-prep/backendconfigs.cloud.google.com.yaml

# install prometheus operator crds
kubectl create \
  -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-alertmanagerconfigs.yaml \
  -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-alertmanagers.yaml \
  -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-podmonitors.yaml \
  -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-probes.yaml \
  -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheuses.yaml \
  -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusrules.yaml \
  -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml \
  -f https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/kube-prometheus-stack/charts/crds/crds/crd-thanosrulers.yaml

# install canary CRD
kubectl create -f https://raw.githubusercontent.com/fluxcd/flagger/main/artifacts/flagger/crd.yaml

# apply chart preconditions
kubectl apply -f .github/workflows/scripts/chart-test-prep/preconditions.yaml

# install gateway crd
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
