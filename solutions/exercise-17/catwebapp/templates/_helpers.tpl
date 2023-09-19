
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "catwebapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "catwebapp.labels" -}}
app: cat-webapp
env: {{ .Values.environmentLabel }}
helm.sh/chart: {{ include "catwebapp.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

