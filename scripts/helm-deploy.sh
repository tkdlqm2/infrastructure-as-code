#!/bin/bash
# scripts/helm-deploy.sh

set -e

# 환경 설정 (기본값: dev)
ENV=${1:-dev}
echo "Deploying to environment: $ENV"

# Helm 저장소 추가
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# 의존성 업데이트
echo "Updating Helm dependencies..."
rm -f ./charts/order-payment-system/Chart.lock
helm dependency update ./charts/order-payment-system

# Helm 차트 배포
echo "Deploying Order-Payment System with Helm..."
RELEASE_NAME="order-payment-${ENV}"

# 이미 설치되어 있는지 확인
if helm ls -n default | grep -q $RELEASE_NAME; then
  echo "Upgrading existing release: $RELEASE_NAME"
  helm upgrade $RELEASE_NAME ./charts/order-payment-system \
    -f ./charts/order-payment-system/values.yaml \
    -f ./charts/order-payment-system/values-${ENV}.yaml \
    --set global.environment=$ENV \
    --set global.timestamp=$(date +%s) \
    --timeout 10m
else
  echo "Installing new release: $RELEASE_NAME"
  helm install $RELEASE_NAME ./charts/order-payment-system \
    -f ./charts/order-payment-system/values.yaml \
    -f ./charts/order-payment-system/values-${ENV}.yaml \
    --set global.environment=$ENV \
    --set global.timestamp=$(date +%s) \
    --timeout 10m
fi

# 배포 상태 확인
echo "Checking deployment status..."
kubectl get pods -n frontend
kubectl get pods -n order-service
kubectl get pods -n payment-service
kubectl get pods -n database
kubectl get pods -n message-queue

echo "Deployment completed successfully!"