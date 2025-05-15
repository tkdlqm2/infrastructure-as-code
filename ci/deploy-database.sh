#!/bin/bash
# ci/deploy-database.sh

set -e

# 공통 PostgreSQL 설정 파일
POSTGRES_COMMON_VALUES="database/postgres-values.yaml"

# 환경 설정 (기본값: dev)
ENV=${1:-dev}

# Order DB 배포
echo "Deploying Order Database..."
if [ -f "$POSTGRES_COMMON_VALUES" ]; then
  # 공통 설정 파일이 있는 경우, 함께 적용
  helm upgrade --install order-db bitnami/postgresql \
    -f "$POSTGRES_COMMON_VALUES" \
    -f "database/order-db/order-db-values-${ENV}.yaml" \
    --namespace database
else
  # 공통 설정 파일이 없는 경우
  helm upgrade --install order-db bitnami/postgresql \
    -f "database/order-db/order-db-values-${ENV}.yaml" \
    --namespace database
fi

# Payment DB 배포
echo "Deploying Payment Database..."
if [ -f "$POSTGRES_COMMON_VALUES" ]; then
  # 공통 설정 파일이 있는 경우, 함께 적용
  helm upgrade --install payment-db bitnami/postgresql \
    -f "$POSTGRES_COMMON_VALUES" \
    -f "database/payment-db/payment-db-values-${ENV}.yaml" \
    --namespace database
else
  # 공통 설정 파일이 없는 경우
  helm upgrade --install payment-db bitnami/postgresql \
    -f "database/payment-db/payment-db-values-${ENV}.yaml" \
    --namespace database
fi

echo "Database deployment completed successfully."