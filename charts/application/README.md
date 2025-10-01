# application

![Version: 1.34.0](https://img.shields.io/badge/Version-1.34.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Generic application chart with common requirements of a typical workload.

**Homepage:** <https://github.com/MediaMarktSaturn/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| MediaMarktSaturn |  | <https://github.com/MediaMarktSaturn> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| statefulSet.enabled | bool | `false` |  |
| statefulSet.podManagementPolicy | string | `"OrderedReady"` |  |
| cronJob.enabled | bool | `false` |  |
| cronJob.schedule | string | `""` |  |
| cronJob.successfulJobsHistoryLimit | int | `3` |  |
| cronJob.failedJobsHistoryLimit | int | `1` |  |
| cronJob.concurrencyPolicy | string | `"Forbid"` |  |
| cronJob.activeDeadlineSeconds | int | `60` |  |
| cronJob.ttlSecondsAfterFinished | int | `86400` |  |
| cronJob.startingDeadlineSeconds | int | `200` |  |
| podRestartPolicy | string | `nil` |  |
| container.port | int | `8080` |  |
| container.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| container.annotations."cluster-autoscaler.kubernetes.io/safe-to-evict" | string | `"true"` |  |
| container.command | list | `[]` |  |
| container.args | list | `[]` |  |
| autoscaling.minReplicaCount | int | `1` |  |
| autoscaling.maxReplicaCount | int | `1` |  |
| autoscaling.averageUtilization.cpu | int | `80` |  |
| startupProbe.enabled | bool | `false` |  |
| startupProbe.path | string | `"/.well-known/live"` |  |
| startupProbe.cmd | list | `[]` |  |
| startupProbe.initialDelaySeconds | int | `10` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.failureThreshold | int | `3` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.path | string | `"/.well-known/live"` |  |
| livenessProbe.cmd | list | `[]` |  |
| livenessProbe.initialDelaySeconds | int | `10` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.path | string | `"/.well-known/ready"` |  |
| readinessProbe.cmd | list | `[]` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| image.repository | string | `"quay.io/heubeck/examiner"` |  |
| image.tag | string | `"1.14.4"` |  |
| image.digest | string | `nil` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tagSemverRange | string | `nil` |  |
| image.tagNumerical | string | `nil` |  |
| image.tagAlphabetical | string | `nil` |  |
| image.tagFilterPattern | string | `nil` |  |
| image.tagFilterExtract | string | `nil` |  |
| image.tagUpdateInterval | string | `"10m0s"` |  |
| image.repositorySecret | string | `"oci-registry-service"` |  |
| image.repositoryProvider | string | `"generic"` |  |
| image.imageAutomationNamespace | string | `nil` |  |
| image.pullSecrets | list | `[]` |  |
| service.enabled | bool | `true` |  |
| service.port | int | `80` |  |
| service.timeout | string | `"120s"` |  |
| service.annotations | object | `{}` |  |
| service.backendConfig.enabled | bool | `false` |  |
| service.backendConfig.securityPolicyName | string | `nil` |  |
| service.clusterIP | string | `nil` |  |
| nodeSelector | object | `{}` |  |
| labels | object | `{}` |  |
| resources | object | `{}` |  |
| lifecycle.postStart | object | `{}` |  |
| lifecycle.preStop | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| configuration | object | `{}` |  |
| disruptionBudget.minAvailable | string | `nil` |  |
| disruptionBudget.maxUnavailable | string | `"50%"` |  |
| secretVolumes | list | `[]` |  |
| configVolumes | list | `[]` |  |
| secretEnvFrom | list | `[]` |  |
| configEnvFrom | list | `[]` |  |
| encryptedSecret.data | object | `{}` |  |
| encryptedSecret.stringData | object | `{}` |  |
| encryptedSecret.mountPath | string | `nil` |  |
| serviceAccount.existingServiceAccountName | string | `nil` |  |
| serviceAccount.workloadIdentityServiceAccount | string | `nil` |  |
| serviceAccount.secretName | string | `nil` |  |
| serviceAccount.mountPath | string | `"/config/service-account"` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.rbac | list | `[]` |  |
| istio.enabled | bool | `false` |  |
| istio.tlsMode | string | `"ISTIO_MUTUAL"` |  |
| istio.ingress.enabled | bool | `true` |  |
| istio.ingress.gateway | string | `"public-gateway"` |  |
| istio.ingress.host | string | `"*"` |  |
| istio.ingress.uriPrefix | string | `"/"` |  |
| istio.ingress.uriRewrite | string | `"/"` |  |
| linkerd.enabled | bool | `false` |  |
| linkerd.proxyConfig."config.linkerd.io/proxy-log-level" | string | `"error"` |  |
| linkerd.proxyConfig."config.linkerd.io/proxy-cpu-request" | string | `"0.2"` |  |
| linkerd.proxyConfig."config.linkerd.io/proxy-memory-request" | string | `"128Mi"` |  |
| gatewayApi.enabled | bool | `false` |  |
| gatewayApi.host | string | `nil` |  |
| gatewayApi.pathPrefix | string | `nil` |  |
| gatewayApi.pathPrefixRewrite | string | `"/"` |  |
| gatewayApi.gatewayRef.name | string | `nil` |  |
| gatewayApi.gatewayRef.namespace | string | `nil` |  |
| gatewayApi.gatewayRef.sectionName | string | `nil` |  |
| monitoring.serviceMonitor | bool | `false` |  |
| monitoring.podMonitor | bool | `false` |  |
| monitoring.namespace | string | `"monitoring"` |  |
| monitoring.metricsPath | string | `"/metrics"` |  |
| monitoring.metricsPortName | string | `"http"` |  |
| monitoring.scrapeInterval | string | `"30s"` |  |
| monitoring.scrapeTimeout | string | `"10s"` |  |
| monitoring.followRedirects | bool | `true` |  |
| canary.enabled | bool | `false` |  |
| canary.analysis.skip | bool | `false` |  |
| canary.analysis.interval | string | `"60s"` |  |
| canary.analysis.threshold | int | `10` |  |
| canary.analysis.maxWeight | int | `50` |  |
| canary.analysis.stepWeight | int | `5` |  |
| canary.analysis.stepWeightPromotion | int | `10` |  |
| canary.analysis.metrics | list | `[]` |  |
| canary.analysis.webhooks | list | `[]` |  |
| canary.analysis.alerts | list | `[]` |  |
| canary.progressDeadlineSeconds | int | `600` |  |
| prepJob.enabled | bool | `false` |  |
| prepJob.sidecarInjection | bool | `false` |  |
| prepJob.backoffLimit | int | `30` |  |
| prepJob.activeDeadlineSeconds | int | `1800` |  |
| prepJob.restartPolicy | string | `"Never"` |  |
| prepJob.image | string | `"busybox:stable"` |  |
| prepJob.command | list | `[]` |  |
| prepJob.configuration | object | `{}` |  |
| prepJob.serviceAccountName | string | `nil` |  |
| prepJob.resources | object | `{}` |  |
| networkPolicy.ingress[0] | object | `{}` |  |
| networkPolicy.egress[0] | object | `{}` |  |
| volumeMounts | list | `[]` |  |
| additionalPorts | list | `[]` |  |
| hostAliases | object | `{}` |  |
| sidecars | list | `[]` |  |
| sidecarDefaults.image.pullPolicy | string | `"IfNotPresent"` |  |
| sidecarDefaults.resources.requests.cpu | string | `"100m"` |  |
| sidecarDefaults.resources.requests.memory | string | `"100Mi"` |  |
| sidecarDefaults.resources.limits.cpu | string | `"500m"` |  |
| sidecarDefaults.resources.limits.memory | string | `"500Mi"` |  |
| sidecarDefaults.securityContext.runAsNonRoot | bool | `true` |  |
| sidecarDefaults.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| initContainers | list | `[]` |  |
| initDefaults.image.pullPolicy | string | `"IfNotPresent"` |  |
| initDefaults.resources.requests.cpu | string | `"100m"` |  |
| initDefaults.resources.requests.memory | string | `"100Mi"` |  |
| initDefaults.resources.limits.cpu | string | `"500m"` |  |
| initDefaults.resources.limits.memory | string | `"100Mi"` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
