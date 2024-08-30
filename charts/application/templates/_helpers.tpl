{{/*
    Name of the config map used as the containers environment
*/}}
{{- define "configmap" -}}
{{- printf "%s-env" .Release.Name -}}
{{- end -}}

{{/*
    Name of the secret to carry encrypted configuration
*/}}
{{- define "secret" -}}
{{- printf "%s-env" .Release.Name -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "commonLabels" -}}
helm.sh/chart: {{ printf "%s-%s" .Release.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
helm.sh/release: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- range $k, $v := .Values.labels }}
{{ $k }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "labels" -}}
{{ include "commonLabels" . }}
{{ include "selectorLabels" . }}
{{- end -}}

{{/*
ServiceAccount name
*/}}
{{- define "serviceAccountName" -}}
{{- if .Values.serviceAccount.existingServiceAccountName -}}
{{- .Values.serviceAccount.existingServiceAccountName | quote -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}
