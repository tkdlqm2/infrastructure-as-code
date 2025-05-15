#!/bin/bash
# scripts/helm-deploy.sh

set -e

# 환경 설정 (기본값: dev)
ENV=${1:-dev}
echo "Deploying to environment: $ENV"

# Helm 저장소 추가
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# 1. 의존성 업데이트 (Chart.lock 파일 삭제 후 의존성 업데이트)
echo "Updating Helm dependencies..."
rm -f ./charts/order-payment-system/Chart.lock
helm dependency update ./charts/order-payment-system

# 2. Helm 차트 배포
echo "Deploying Order-Payment System with Helm..."
RELEASE_NAME="order-payment-${ENV}"

# 이미 설치되어 있는지 확인
if helm ls | grep $RELEASE_NAME; then
  echo "Upgrading existing release: $RELEASE_NAME"
  helm upgrade $RELEASE_NAME ./charts/order-payment-system \
    -f ./charts/order-payment-system/values.yaml \
    -f ./charts/order-payment-system/values-${ENV}.yaml \
    --set global.environment=$ENV \
    --set global.timestamp=$(date +%s)
else
  echo "Installing new release: $RELEASE_NAME"
  helm install $RELEASE_NAME ./charts/order-payment-system \
    -f ./charts/order-payment-system/values.yaml \
    -f ./charts/order-payment-system/values-${ENV}.yaml \
    --set global.environment=$ENV \
    --set global.timestamp=$(date +%s)
fi

echo "Deployment completed successfully!"