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