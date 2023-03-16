{{/*
Expand the name of the chart.
*/}}
{{- define "nginx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nginx.fullname" -}}
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
{{- define "nginx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nginx.labels" -}}
helm.sh/chart: {{ include "nginx.chart" . }}
{{ include "nginx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nginx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nginx.serviceAccountName" -}}
{{- $serviceAccountName := ( printf "%s-sa" (include "nginx.fullname" .)  ) }}
{{- if .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name | default $serviceAccountName }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cluster role to use
*/}}
{{- define "nginx.clusterRole" -}}
{{- $clusterRole := ( printf "%s-cr" (include "nginx.fullname" .)  ) }}
{{- if .Values.rbac.create }}
{{- .Values.rbac.clusterRoleName | default $clusterRole }}
{{- else }}
{{- .Values.rbac.clusterRoleNameRef }}
{{- end }}
{{- end }}

{{/*
Create the name of the cluster role binding to use
*/}}
{{- define "nginx.clusterRoleBinding" -}}
{{- if .Values.rbac.create }}
{{- printf "%s-crb" (include "nginx.fullname" .) }}
{{- else }}
{{- .Values.rbac.clusterRoleNameRef | join "-crb" }}
{{- end }}
{{- end }}

{{/*
Create the name of the network policy
*/}}
{{- define "nginx.networkPolicy" -}}
{{- if .Values.networkPolicy.create }}
{{- printf "deny-access-to-%s" (include "nginx.fullname" .) }}
{{- end }}
{{- end }}
