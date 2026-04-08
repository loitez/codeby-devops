{{/*
Chart name
*/}}
{{- define "wordpress-stack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified name
*/}}
{{- define "wordpress-stack.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wordpress-stack.labels" -}}
helm.sh/chart: {{ include "wordpress-stack.chart" . }}
{{ include "wordpress-stack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "wordpress-stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "wordpress-stack.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wordpress-stack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Component Labels */}}
{{- define "wordpress-stack.mysqlLabels" -}}
{{ include "wordpress-stack.selectorLabels" . }}
app.kubernetes.io/component: mysql
{{- end }}

{{- define "wordpress-stack.wordpressLabels" -}}
{{ include "wordpress-stack.selectorLabels" . }}
app.kubernetes.io/component: wordpress
{{- end }}