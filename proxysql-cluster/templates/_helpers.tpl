{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "proxysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "proxysql.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "proxysql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "proxysql.labels" -}}
app.kubernetes.io/name: {{ include "proxysql.name" . }}
helm.sh/chart: {{ include "proxysql.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "proxysql.pwd" -}}
{{- if not .password }}
{{- $_ := set . "password" (randAlphaNum 20)  }}
{{- end -}}
{{ .password }}
{{- end -}}

{{- define "proxysql.cfgmapdump" -}}
{{ range $key, $val := . -}}
{{ $key }}={{ $val }}
{{ end -}}
{{- end -}}

{{- define "proxysql.cfglistdump" -}}
{{- range $idx, $val := . -}}
{
  {{ include "proxysql.cfgmapdump" $val | nindent 2 }}
},
{{ end -}}
{{- end -}}
