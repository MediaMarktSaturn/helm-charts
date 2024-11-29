![MediaMarktSaturng Logo](assets/mms.png)

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

### [dependency-track](https://github.com/MediaMarktSaturn/helm-charts/tree/main/charts/dependency-track)

The [OWASP Dependency-Track](https://owasp.org/www-project-dependency-track/) project with separate deployments for API-server and frontend.

### [pod-cleanup](https://github.com/MediaMarktSaturn/helm-charts/tree/main/charts/pod-cleanup)

A CronJob that deletes terminated/failed pods from a Kubernetes cluster.

Useful when e.g. provisioning Google Kubernetes Engine clusters with preemptible nodes. The preemption leads to pods being shut down during node recreation, however the pods are still kept and displayed when listing them.

### [http-metronome](https://github.com/MediaMarktSaturn/helm-charts/tree/main/charts/http-metronome)

Creates CronJobs for periodic triggering of cluster-internal http endpoints using GET.

Can be used in an Istio meshed environment, see its [values](https://github.com/MediaMarktSaturn/helm-charts/tree/main/charts/http-metronome/values.yaml) for details.

### [application](https://github.com/MediaMarktSaturn/helm-charts/tree/main/charts/application)

A generic chart, that creates a deployment with lots of valuable companions for configuration, service meshes or automated canary deployments.
We're using this for lots of our business applications.

Please have a look on the [values](https://github.com/MediaMarktSaturn/helm-charts/tree/main/charts/application/values.yaml) for all its features.

## Contributing

Contributions of any kind are welcome and very much appreciated!

### Update Charts

When updating a chart, please make sure to also increase its version in the `Chart.yaml`, according to the [semantic versioning](https://semver.org).

If applicable, please also add or extend current test cases in [chart-tests](./chart-tests/).

### Create Pull Request

Please check the current [opened pull requests](https://github.com/MediaMarktSaturn/helm-charts/pulls?q=is%3Apr+is%3Aopen+) for duplicates before opening a new one.

Pull request's title should include a scope (usually the chart's name),
for example: [`[Application] Set status.podIP as APPLICATION_POD_IP env`](https://github.com/MediaMarktSaturn/helm-charts/pull/159)).

Or use the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) with the scope,
for example [`chore(action): bump kind_version from 0.24.0 to 0.25.0`](https://github.com/MediaMarktSaturn/helm-charts/pull/162).

---

_This repository is published under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)_

**_get to know us 👉 [https://mms.tech](https://mms.tech) 👈_**
