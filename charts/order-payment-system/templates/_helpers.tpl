{{/* 기본 레이블 정의 */}}
{{- define "order-payment-system.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/* 네임스페이스 선택자 정의 */}}
{{- define "order-payment-system.namespace-selector" -}}
kubernetes.io/metadata.name: {{ . }}
{{- end -}}

{{/* 전체 도메인 이름 생성 */}}
{{- define "order-payment-system.domain" -}}
{{- .Values.global.domain -}}
{{- end -}}


{{/*
Get the namespace for a specific service
*/}}
{{- define "order-payment-system.serviceNamespace" -}}
{{- if .namespaceOverride -}}
{{- .namespaceOverride -}}
{{- else -}}
{{- .Values.global.namespace | default .Release.Namespace -}}
{{- end -}}
{{- end -}}


{{/*
기존 비밀번호 유지 또는 새로 생성
*/}}
{{- define "order-payment-system.getExistingSecret" -}}
{{- $secret := lookup "v1" "Secret" .namespace .name -}}
{{- if $secret -}}
  {{- $secret.data | toYaml -}}
{{- else -}}
  {{- dict | toYaml -}}
{{- end -}}
{{- end -}}