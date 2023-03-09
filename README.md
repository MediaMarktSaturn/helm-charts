# Helm-Charts

This repository contains Helm charts bundled and used by the MediaMarktSaturn Technology team.

## Usage

With helm cli:

`helm repo add mediamarktsaturn https://helm-charts.mmst.eu`

With FluxCD:

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: HelmRepository
metadata:
  name: mediamarktsaturn
spec:
  interval: 120m
  url: https://helm-charts.mmst.eu
```

## Charts

### [Dependency-Track](charts/dependency-track)

The [OWASP Dependency-Track](https://owasp.org/www-project-dependency-track/) project with separate deployments for API-server and frontend.
