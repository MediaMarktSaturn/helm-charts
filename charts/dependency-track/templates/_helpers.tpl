{{/*
  Common labels
*/}}
{{- define "commonLabels" -}}
helm.sh/chart: {{ printf "%s-%s" .Release.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
helm.sh/release: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: dependency-track
{{- range $k, $v := .Values.labels }}
{{ $k }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{/*
  API server name
*/}}
{{- define "apiserverName" -}}
{{ .Release.Name }}-api
{{- end -}}

{{/*
  Frontend name
*/}}
{{- define "frontendName" -}}
{{ .Release.Name }}-ui
{{- end -}}

{{/*
  API server labels
*/}}
{{- define "apiserverSelectorLabels" -}}
app.kubernetes.io/instance: {{ include "apiserverName" . }}
app.kubernetes.io/component: apiserver
{{- end -}}

{{/*
  API Server selector labels
*/}}
{{- define "apiserverLabels" -}}
{{ include "commonLabels" . }}
{{ include "apiserverSelectorLabels" . }}
{{- end -}}

{{/*
  Frontend labels
*/}}
{{- define "frontendSelectorLabels" -}}
app.kubernetes.io/instance: {{ include "frontendName" . }}
app.kubernetes.io/component: frontend
{{- end -}}

{{/*
  Frontend selector labels
*/}}
{{- define "frontendLabels" -}}
{{ include "commonLabels" . }}
{{ include "frontendSelectorLabels" . }}
{{- end -}}

{{/*
  Customized grafana dashboard, originated from https://docs.dependencytrack.org/files/grafana-dashboard.json
*/}}
{{- define "grafanaDashboardJson" -}}
    {{ $.Files.Get "static/grafana-dashboard.json"
      | replace "${DS_PROMETHEUS}" .Values.apiserver.metrics.grafana.datasourceUid
      | replace "instance=\\\"$instance\\\"" (printf "namespace=\\\"%s\\\", service=\\\"%s\\\"" .Release.Namespace (include "apiserverName" .))
      | replace "\"editable\": true," "\"editable\": false,"
     }}
{{- end -}}
