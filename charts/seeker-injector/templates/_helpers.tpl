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
k8s.drfoster.co/webhook: {{ .Values.webhookName }}
{{- end -}}

{{/*
Generate the image name
*/}}
{{- define "deployment.image" -}}
{{- $repo := default "k8s-registry.dr-foster.lan" .Values.image.repo -}}
{{- $imagetag := default "latest" .Values.image.tag -}}
{{- printf "%s:%s" $repo $imagetag -}}
{{- end -}}