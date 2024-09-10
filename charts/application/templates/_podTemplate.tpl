{{/*
PodTemplate to be used in Deployment or StatefulSet
*/}}
{{- define "podTemplate" -}}
metadata:
  labels:
    {{- include "labels" . | nindent 4 }}
  annotations:
    kubectl.kubernetes.io/default-container: {{ .Release.Name }}
    checksum/config: {{ include (print $.Template.BasePath "/k8s-config-map.yaml") . | sha256sum }}
    {{- if or .Values.encryptedSecret.data .Values.encryptedSecret.stringData }}
    checksum/secret: {{ include (print $.Template.BasePath "/k8s-secret.yaml") . | sha256sum }}
    {{- end }}
    {{- range $k, $v := .Values.container.annotations }}
    {{ $k }}: {{ $v | quote }}
    {{- end }}
    {{- if .Values.linkerd.enabled }}
    linkerd.io/inject: enabled
    {{- range $k, $v := .Values.linkerd.proxyConfig }}
    {{ $k }}: {{ $v | quote }}
    {{- end }}
    {{- end }}
spec:
  serviceAccountName: {{ include "serviceAccountName" . }}
  {{- if .Values.podSecurityContext }}
  securityContext:
    {{- toYaml .Values.podSecurityContext | nindent 4 }}
  {{- end }}
  nodeSelector: {{ if not .Values.serviceAccount.workloadIdentityServiceAccount -}}{{- if not .Values.nodeSelector -}}{}{{- end -}}{{- end }}
    {{- if .Values.serviceAccount.workloadIdentityServiceAccount }}
    iam.gke.io/gke-metadata-server-enabled: "true"
    {{- end }}
    {{- range $k, $v := .Values.nodeSelector }}
    {{ $k }}: {{ $v | quote }}
    {{- end }}
  automountServiceAccountToken: {{ or .Values.serviceAccount.automountServiceAccountToken .Values.istio.enabled .Values.linkerd.enabled (not (empty .Values.serviceAccount.rbac))}} # 'true' if explictly set or required for side-car injection
  {{- if .Values.hostAliases }}
  hostAliases:
  {{- range $ip, $hostList := .Values.hostAliases }}
    - ip: {{ $ip | quote }}
      hostnames:
      {{- if (eq "string" (kindOf $hostList)) }}
        - {{ $hostList | quote}}
      {{- else -}}
      {{- range $host := $hostList }}
        - {{ $host | quote }}
      {{- end }}
      {{- end }}
  {{- end }}
  {{- end }}
  initContainers: {{ if not .Values.initContainers -}}[]{{- end -}}
    {{- range $i := .Values.initContainers }}
    - name: {{ $i.name }}
      {{- if .image.digest }}
      image: "{{ .image.repository }}@{{ .image.digest }}"
      {{- else }}
      image: "{{ .image.repository }}:{{ .image.tag }}"
      {{- end }}
      imagePullPolicy: {{ or $i.image.pullPolicy $.Values.initDefaults.image.pullPolicy }}
      command: {{ if not $i.command }}[]{{ end }}
        {{- range $i.command }}
        - {{ . | quote }}
        {{- end }}
      securityContext:
        {{- if and $i.securityContext $.Values.initDefaults.securityContext }}
        {{- toYaml (mergeOverwrite $.Values.initDefaults.securityContext $i.securityContext) | nindent 8 }}
        {{- else }}
        {{- toYaml (or $i.securityContext $.Values.initDefaults.securityContext) | nindent 8 }}
        {{- end }}
      resources:
        {{- toYaml (or $i.resources $.Values.initDefaults.resources) | nindent 8 }}
      {{- if .env }}
      env:
        {{- range $k, $v := .env }}
        - name: {{ $k }}
          value: {{ $v | quote }}
        {{- end }}
      {{- end }}
      {{- if (or $i.configEnvFrom $i.secretEnvFrom )}}
      envFrom:
        {{- range $c := $i.configEnvFrom }}
        - configMapRef:
            name: {{ $c }}
        {{- end }}
        {{- range $ie := $i.secretEnvFrom }}
        - secretRef:
            name: {{ $ie }}
        {{- end }}
      {{- end }}
      {{ $hasInitVolumeMount := 0 }}
      {{ range $.Values.volumeMounts }}{{ if (has .name $i.volumeMountNames) }}{{ $hasInitVolumeMount = 1 }}{{ end }}{{ end }}
      volumeMounts: {{ if not (or $i.secretVolumes (and $.Values.volumeMounts $hasInitVolumeMount)) -}}[]{{- end -}}
        {{- range $i.secretVolumes }}
        - name: "{{ $i.name }}-{{ .secretName }}"
          mountPath: {{ .mountPath }}
          readOnly: true
        {{- end }}
        {{- range $.Values.volumeMounts }}
        {{- if (has .name $i.volumeMountNames) }}
        - name: {{ .name }}
          mountPath: {{ .mountPath }}
        {{- end }}
        {{- end }}
    {{- end }}
  {{- if .Values.image.pullSecrets }}
  imagePullSecrets:
    {{- range $s := .Values.image.pullSecrets }}
    - name: {{ $s }}
    {{- end }}
  {{- end }}
  containers:
    {{- range $s := .Values.sidecars }}
    - name: {{ $s.name }}
      {{- if .image.digest }}
      image: "{{ .image.repository }}@{{ .image.digest }}"
      {{- else }}
      image: "{{ .image.repository }}:{{ .image.tag }}"
      {{- end }}
      imagePullPolicy: {{ or $s.image.pullPolicy $.Values.sidecarDefaults.image.pullPolicy }}
      args: {{ if not $s.args }}[]{{ end }}
        {{- range $s.args }}
        - {{ . | quote }}
        {{- end }}
      securityContext:
        {{- if and $s.securityContext $.Values.sidecarDefaults.securityContext }}
        {{- toYaml (mergeOverwrite $.Values.sidecarDefaults.securityContext $s.securityContext) | nindent 8 }}
        {{- else }}
        {{- toYaml (or $s.securityContext $.Values.sidecarDefaults.securityContext) | nindent 8 }}
        {{- end }}
      resources:
        {{- toYaml (or $s.resources $.Values.sidecarDefaults.resources) | nindent 8 }}
      {{- if .env }}
      env:
        {{- range $k, $v := .env }}
        - name: {{ $k }}
          value: {{ $v | quote }}
        {{- end }}
      {{- end }}
      {{- if (or $s.configEnvFrom $s.secretEnvFrom )}}
      envFrom:
        {{- range $c := $s.configEnvFrom }}
        - configMapRef:
            name: {{ $c }}
        {{- end }}
        {{- range $se := $s.secretEnvFrom }}
        - secretRef:
            name: {{ $se }}
        {{- end }}
      {{- end }}
      {{ $hasSidecarVolumeMount := 0 }}
      {{ range $.Values.volumeMounts }}{{ if (has .name $s.volumeMountNames) }}{{ $hasSidecarVolumeMount = 1 }}{{ end }}{{ end }}
      volumeMounts: {{ if not (or $s.secretVolumes (and $.Values.volumeMounts $hasSidecarVolumeMount)) -}}[]{{- end -}}
        {{- range $s.secretVolumes }}
        - name: "{{ $s.name }}-{{ .secretName }}"
          mountPath: {{ .mountPath }}
          readOnly: true
        {{- end }}
        {{- range $.Values.volumeMounts }}
        {{- if (has .name $s.volumeMountNames) }}
        - name: {{ .name }}
          mountPath: {{ .mountPath }}
        {{- end }}
        {{- end }}
      {{- if $s.livenessProbe }}
      livenessProbe:
        {{- if $s.livenessProbe.cmd }}
        exec:
          command:
          {{- range $s.livenessProbe.cmd }}
            - {{ . | quote }}
          {{- end }}
        {{ else }}
        httpGet:
          path: {{ $s.livenessProbe.path }}
          port: {{ $s.livenessProbe.port }}
        {{- end }}
        initialDelaySeconds: {{ $.Values.livenessProbe.initialDelaySeconds }}
        periodSeconds: {{ $.Values.livenessProbe.periodSeconds }}
        failureThreshold: {{ $.Values.livenessProbe.failureThreshold }}
        timeoutSeconds: {{ $.Values.livenessProbe.timeoutSeconds }}
      {{- end }}
      {{- if $s.readinessProbe }}
      readinessProbe:
        {{- if $s.readinessProbe.cmd }}
        exec:
          command:
          {{- range $s.readinessProbe.cmd }}
            - {{ . | quote }}
          {{- end }}
        {{ else }}
        httpGet:
          path: {{ $s.readinessProbe.path }}
          port: {{ $s.readinessProbe.port }}
        {{- end }}
        initialDelaySeconds: {{ $.Values.readinessProbe.initialDelaySeconds }}
        periodSeconds: {{ $.Values.readinessProbe.periodSeconds }}
        failureThreshold: {{ $.Values.readinessProbe.failureThreshold }}
        timeoutSeconds: {{ $.Values.readinessProbe.timeoutSeconds }}
      {{- end }}
      {{- if and $s.lifecycle ( or $s.lifecycle.postStart $s.lifecycle.preStop ) }}
      lifecycle:
        {{- if $s.lifecycle.postStart }}
        postStart:
          {{- toYaml ($s.lifecycle.postStart) | nindent 10 }}
        {{- end }}
        {{- if $s.lifecycle.preStop }}
        preStop:
          {{- toYaml ($s.lifecycle.preStop) | nindent 10 }}
        {{- end }}
      {{- end }}
      {{- if $s.ports }}
      ports:
        {{- range $sp := $s.ports }}
        - name: {{ $sp.name }}
          containerPort: {{ $sp.containerPort }}
          protocol: {{ $sp.protocol }}
        {{- end }}
      {{- end }}
    {{- end }}
    - name: {{ .Release.Name }}
      {{- if .Values.container.securityContext }}
      securityContext:
        {{- toYaml .Values.container.securityContext | nindent 8 }}
      {{- end }}
      {{- if .Values.image.digest }}
      image: "{{ .Values.image.repository }}@{{ .Values.image.digest }}"
      {{- else }}
      image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
      {{- end }}
      imagePullPolicy: {{ .Values.image.pullPolicy }}
      args: {{ if not .Values.container.args }}[]{{ end }}
        {{- range .Values.container.args }}
        - {{ . | quote }}
        {{- end }}
      envFrom:
        - configMapRef:
            name: {{ include "configmap" . }}
        {{- range $c := .Values.configEnvFrom }}
        - configMapRef:
            name: {{ $c }}
        {{- end }}
        {{- range $s := .Values.secretEnvFrom }}
        - secretRef:
            name: {{ $s }}
        {{- end }}
        {{- if and (or .Values.encryptedSecret.data .Values.encryptedSecret.stringData) (not .Values.encryptedSecret.mountPath) }}
        - secretRef:
            name: {{ include "secret" . }}
        {{- end }}
      {{- if .Values.serviceAccount.secretName }}
      env:
        - name: "GOOGLE_APPLICATION_CREDENTIALS"
          value: "{{- .Values.serviceAccount.mountPath -}}/key.json"
      {{- end }}
      ports:
        - name: http
          containerPort: {{ .Values.container.port }}
          protocol: TCP
        {{- range $ap := .Values.additionalPorts }}
        - name: {{ $ap.name }}
          containerPort: {{ $ap.containerPort }}
          protocol: {{ $ap.protocol }}
        {{- end }}
      {{- if .Values.livenessProbe.enabled }}
      livenessProbe:
        {{- if .Values.livenessProbe.cmd }}
        exec:
          command:
          {{- range .Values.livenessProbe.cmd }}
            - {{ . | quote }}
          {{- end }}
        {{ else }}
        httpGet:
          path: {{ .Values.livenessProbe.path }}
          port: {{ .Values.container.port }}
        {{- end }}
        initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds }}
        periodSeconds: {{ .Values.livenessProbe.periodSeconds }}
        failureThreshold: {{ .Values.livenessProbe.failureThreshold }}
        timeoutSeconds: {{ .Values.livenessProbe.timeoutSeconds }}
      {{- end }}
      {{- if .Values.readinessProbe.enabled }}
      readinessProbe:
        {{- if .Values.readinessProbe.cmd }}
        exec:
          command:
          {{- range .Values.readinessProbe.cmd }}
            - {{ . | quote }}
          {{- end }}
        {{ else }}
        httpGet:
          path: {{ .Values.readinessProbe.path }}
          port: {{ .Values.container.port }}
        {{- end }}
        initialDelaySeconds: {{ .Values.readinessProbe.initialDelaySeconds }}
        periodSeconds: {{ .Values.readinessProbe.periodSeconds }}
        failureThreshold: {{ .Values.readinessProbe.failureThreshold }}
        timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds }}
      {{- end }}
      resources:
        {{- toYaml .Values.resources | nindent 8 }}
      volumeMounts: {{ if not (or .Values.secretVolumes .Values.configVolumes .Values.serviceAccount.secretName .Values.encryptedSecret.mountPath .Values.volumeMounts) -}}[]{{- end -}}
        {{- range .Values.secretVolumes }}
        - name: {{ .secretName }}
          mountPath: {{ .mountPath }}
          {{- if .defaultMode }}
          defaultMode: {{ .defaultMode }}
          {{- end }}
          readOnly: true
        {{- end }}
        {{- range .Values.configVolumes }}
        - name: {{ .configMapName }}
          mountPath: {{ .mountPath }}
          {{- if .defaultMode }}
          defaultMode: {{ .defaultMode }}
          {{- end }}
          readOnly: true
        {{- end }}
        {{- if .Values.serviceAccount.secretName }}
        - name: service-account
          mountPath: /config/service-account
          readOnly: true
        {{- end }}
        {{- if .Values.encryptedSecret.mountPath }}
        - name: secret-env
          mountPath: {{ .Values.encryptedSecret.mountPath }}
          readOnly: true
        {{- end }}
        {{- range .Values.volumeMounts }}
        - name: {{ .name }}
          mountPath: {{ .mountPath }}
        {{- end }}
      {{- if or .Values.lifecycle.postStart .Values.lifecycle.preStop }}
      lifecycle:
        {{- if .Values.lifecycle.postStart }}
        postStart:
          {{- toYaml (.Values.lifecycle.postStart) | nindent 10 }}
        {{- end }}
        {{- if .Values.lifecycle.preStop }}
        preStop:
          {{- toYaml (.Values.lifecycle.preStop) | nindent 10 }}
        {{- end }}
      {{- end }}
  {{ $hasSidecarVolume := 0 }}
  {{ range .Values.sidecars }}{{ if .secretVolumes }}{{ $hasSidecarVolume = 1 }}{{ end }}{{ end }}
  {{ $hasInitVolume := 0 }}
  {{ range .Values.initContainers }}{{ if .secretVolumes }}{{ $hasInitVolume = 1 }}{{ end }}{{ end }}
  volumes: {{ if not (or .Values.secretVolumes .Values.configVolumes .Values.serviceAccount.secretName .Values.encryptedSecret.mountPath .Values.volumeMounts $hasSidecarVolume $hasInitVolume) -}}[]{{- end -}}
    {{- range .Values.secretVolumes }}
    - name: {{ .secretName }}
      secret:
        secretName: {{ .secretName }}
    {{- end }}
    {{- range .Values.configVolumes }}
    - name: {{ .configMapName }}
      configMap:
        name: {{ .configMapName }}
    {{- end }}
    {{- if .Values.serviceAccount.secretName }}
    - name: service-account
      secret:
        secretName: {{ .Values.serviceAccount.secretName }}
    {{- end }}
    {{- if .Values.encryptedSecret.mountPath }}
    - name: secret-env
      secret:
        secretName: {{ include "secret" . }}
    {{- end }}
    {{- range .Values.volumeMounts }}
    - name: {{ .name }}
      {{- if .pvcName }}
      persistentVolumeClaim:
        claimName: {{ .pvcName }}
      {{- else }}
      emptyDir: {}
      {{- end }}
    {{- end }}
    {{- range $s := .Values.sidecars }}
    {{ if .secretVolumes }}
    {{- range .secretVolumes }}
    - name: "{{ $s.name }}-{{ .secretName }}"
      secret:
        secretName: {{ .secretName }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- range $i := .Values.initContainers }}
    {{ if .secretVolumes }}
    {{- range .secretVolumes }}
    - name: "{{ $i.name }}-{{ .secretName }}"
      secret:
        secretName: {{ .secretName }}
    {{- end }}
    {{- end }}
    {{- end }}
  {{- if .Values.tolerations }}
  tolerations:
    {{- toYaml .Values.tolerations | nindent 4 }}
  {{- end }}
  {{- if .Values.affinity }}
  affinity:
    {{- toYaml .Values.affinity | nindent 4 }}
  {{- end }}
{{- end -}}
