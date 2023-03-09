# MediaMarktSaturn Technology - Helm-Charts

This repository contains Helm charts bundled and used by the MediaMarktSaturn Technology team.

## Usage

With helm cli:

`helm repo add mediamarktsaturn https://helm-charts.mms.tech`

With FluxCD:

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: HelmRepository
metadata:
  name: mediamarktsaturn
spec:
  interval: 120m
  url: https://helm-charts.mms.tech
```

## Charts

### [Dependency-Track](https://github.com/MediaMarktSaturn/helm-charts/tree/main/charts/dependency-track)

The [OWASP Dependency-Track](https://owasp.org/www-project-dependency-track/) project with separate deployments for API-server and frontend.

---

_This repository is published under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)_
