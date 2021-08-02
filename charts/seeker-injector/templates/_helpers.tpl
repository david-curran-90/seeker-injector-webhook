{{/*
Sets the default labels
*/}}
{{- define "common.labels" -}}
helm.io/chart: {{ .Chart.Name | quote }}
helm.io/heritage: {{ .Release.Service | quote }}
helm.io/release: {{ .Release.Name | quote }}
k8s.drfoster.co/owner: {{ default "KPE" .Values.labels.owner | quote }}
k8s.drfoster.co/managed-by: "Helm"
{{- end -}}

{{/*
Sets default annotations
*/}}
{{- define "common.annotations" -}}
k8s.drfoster.co/webhook: {{ .Values.webhook.name }}
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
{{- pintf "%s:%s" $repo $imagetag -}}
{{- end -}}