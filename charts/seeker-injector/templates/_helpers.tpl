{{/*
Sets the default labels
*/}}
{{- define "common.labels" -}}
helm.io/chart: {{ .Chart.Name | quote }}
helm.io/heritage: {{ .Release.Service | quote }}
helm.io/release: {{ .Release.Name | quote }}
{{- if .Values.labels -}}
{{ .Values.labels | toYaml }}
{{- end -}}
{{- end -}}

{{/*
Sets default annotations
*/}}
{{- define "common.annotations" -}}
seeker.injector/webhook: {{ .Values.webhook.name }}
{{- if .Values.annotations -}}
{{ .Values.annotations | toYaml }}
{{- end -}}
{{- end -}}

{{/*
Generate the image name
*/}}
{{- define "deployment.image" -}}
{{- $repo := .Values.image.repo -}}
{{- $imagetag := .Values.image.tag -}}
{{- printf "%s:%s" $repo $imagetag -}}
{{- end -}}

{{/*
Generate the sidecar image
*/}}
{{- define "sidecar.image" -}}
{{- $repo := .Values.sidecar.repo -}}
{{- $imagetag := .Values.sidecar.tag -}}
{{- printf "%s:%s" $repo $imagetag -}}
{{- end -}}