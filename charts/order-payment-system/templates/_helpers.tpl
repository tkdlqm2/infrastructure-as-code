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