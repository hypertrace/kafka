{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka.fullname" -}}
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
{{- define "kafka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "kafka.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "kafka.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- /*
kafka.labels.standard prints the standard kafka Helm labels.
The standard labels are frequently used in metadata.
*/ -}}
{{- define "kafka.labels.standard" -}}
app: {{ template "kafka.name" . }}
chart: {{ template "kafka.chart" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}

{{- /*
Form the kafka headless service name
*/ -}}
{{- define "kafka.headless.service" -}}
{{- if .Values.headlessServiceName -}}
{{- .Values.headlessServiceName }}
{{- else -}}
{{- printf "%s-broker" (include "kafka.fullname" .) | trunc 63 }}
{{- end -}}
{{- end -}}

{{- /*
Form the zookeeper URL. If zookeeper chart is installed in same namespace, use k8s service discovery,
else use user-provided URL
*/ -}}
{{- define "kafka.zookeeper.connect" -}}
{{- if .Values.config.zookeeperConnectOverride -}}
{{- .Values.config.zookeeperConnectOverride }}
{{- else -}}
{{- printf "zookeeper.%s.svc.cluster.local:2181" .Release.Namespace }}
{{- end -}}
{{- end -}}

{{- define "kafkaservice.image" -}}
  {{- if and .Values.image.tagOverride  -}}
    {{- printf "%s:%s" .Values.image.repository .Values.image.tagOverride }}
  {{- else -}}
    {{- printf "%s:%s" .Values.image.repository .Chart.Version }}
  {{- end -}}
{{- end -}}