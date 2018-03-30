{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app: {{ template "fullname" . }}
{{- end -}}

{{- define "labels.prometheus" -}}
release: {{ .Release.Name }}
app: {{ template "fullname" . }}
component: core
{{- end -}}

{{- define "labels.nodeExporter" -}}
release: {{ .Release.Name }}
app: {{ template "fullname" . }}
component: node-exporter
{{- end -}}

{{- define "labels.blackboxExporter" -}}
release: {{ .Release.Name }}
app: {{ template "fullname" . }}
component: blackbox-exporter
{{- end -}}

{{- define "labels.kubeStateMetrics" -}}
release: {{ .Release.Name }}
app: {{ template "fullname" . }}
component: kube-state-metrics
{{- end -}}

{{- define "labels.alertmanager" -}}
release: {{ .Release.Name }}
app: {{ template "fullname" . }}
component: alertmanager
{{- end -}}
