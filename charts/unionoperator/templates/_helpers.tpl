{{/*
Expand the name of the chart.
*/}}
{{- define "union-operator.name" -}}
{{- default .Chart.Name .Values.union.unionoperator.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "newClusterName" -}}
{{- printf "c%v" (randAlphaNum 16 | nospace) -}}
{{- end -}}

{{- define "union-operator.grpcUrl" -}}
{{- printf "dns:///%s" (.Values.union.cloudUrl | trimPrefix "dns:///" | trimPrefix "http://" | trimPrefix "https://") -}}
{{- end -}}

{{- define "union-operator.cloudHostName" -}}
{{- printf "%s" (.Values.union.cloudUrl | trimPrefix "dns:///" | trimPrefix "http://" | trimPrefix "https://") -}}
{{- end -}}

{{- define "union-operator.bucketRegion" -}}
{{- if eq .Values.union.storage.type "s3" }}
{{- printf "%s" .Values.union.storage.s3.region -}}
{{- else }}
{{- printf "us-east-2" -}}
{{- end }}
{{- end }}

{{- define "union-operator.gcpProjectId" -}}
{{- if eq .Values.union.storage.type "gcs" }}
{{- printf "%s" .Values.union.storage.gcs.projectId -}}
{{- else }}
{{- printf "dummy-gcs-projectId" -}}
{{- end }}
{{- end }}

{{- define "union-operator.org" -}}
{{- (split "." (.Values.union.cloudUrl | trimPrefix "dns:///" | trimPrefix "http://" | trimPrefix "https://"))._0 -}}
{{- end -}}

{{- define "union-operator.bucket" -}}
{{- (split "/" (.Values.union.metadataBucketPrefix | trimPrefix "s3://" | trimPrefix "gs://" | trimPrefix "az://"))._0 -}}
{{- end -}}

{{- define "minio.name" -}}
minio
{{- end -}}

{{- define "minio.selectorLabels" -}}
app.kubernetes.io/name: {{ template "minio.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "minio.labels" -}}
{{ include "minio.selectorLabels" . }}
helm.sh/chart: {{ include "flyte.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "union-operator.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "union-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "union-operator.labels" -}}
helm.sh/chart: {{ include "union-operator.chart" . }}
{{ include "union-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "union-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "union-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "union-operator.serviceAccountName" -}}
{{- if .Values.union.unionoperator.serviceAccount.create }}
{{- default (include "union-operator.fullname" .) .Values.union.unionoperator.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.union.unionoperator.serviceAccount.name }}
{{- end }}
{{- end }}
