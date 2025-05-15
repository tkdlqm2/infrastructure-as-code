#!/bin/bash
# scripts/deploy-all.sh

set -e

# 환경 설정 (기본값: dev)
ENV=${1:-dev}
echo "Deploying to environment: $ENV"

# 1. 네임스페이스 및 기본 구성 생성
echo "Creating namespaces and basic configurations..."
kubectl apply -f kubernetes/namespace/1-namespaces.yaml

# 2. ConfigMap 생성
echo "Creating ConfigMaps..."
kubectl apply -f kubernetes/namespace/2-frontend-configmap.yaml
kubectl apply -f kubernetes/namespace/3-order-configmap.yaml
kubectl apply -f kubernetes/namespace/4-payment-configmap.yaml
kubectl apply -f kubernetes/namespace/5-kafka-configmap.yaml

# 3. Secret 생성
echo "Creating Secrets..."
kubectl apply -f kubernetes/namespace/6-order-secrets.yaml
kubectl apply -f kubernetes/namespace/7-payment-secrets.yaml
kubectl apply -f kubernetes/namespace/8-db-secrets.yaml

# 4. 영구 볼륨 생성
echo "Creating Persistent Volumes..."
kubectl apply -f kubernetes/namespace/9-database-pv.yaml
kubectl apply -f kubernetes/namespace/10-database-pvc.yaml
kubectl apply -f kubernetes/namespace/11-kafka-pvc.yaml

# 5. 데이터베이스 배포
echo "Deploying databases..."
bash ci/deploy-database.sh $ENV

# 6. Kafka 배포
echo "Deploying Kafka..."
bash ci/deploy-kafka.sh $ENV

# 데이터베이스 및 Kafka 준비 확인
echo "Waiting for databases and Kafka to be ready..."
kubectl wait --for=condition=ready pod -l app=order-db -n database --timeout=5m
kubectl wait --for=condition=ready pod -l app=payment-db -n database --timeout=5m
kubectl wait --for=condition=ready pod -l app=kafka -n message-queue --timeout=5m

# 7. 애플리케이션 배포
echo "Deploying applications..."
kubectl apply -f kubernetes/deployment/15-order-deployment.yaml
kubectl apply -f kubernetes/deployment/16-payment-deployment.yaml
kubectl apply -f kubernetes/deployment/17-order-service.yaml
kubectl apply -f kubernetes/deployment/18-payment-service.yaml
kubectl apply -f kubernetes/deployment/19-database-services.yaml
kubectl apply -f kubernetes/deployment/20-kafka-service.yaml
kubectl apply -f kubernetes/deployment/21-frontend-deployment.yaml
kubectl apply -f kubernetes/deployment/22-frontend-service.yaml

# 8. HPA 배포
echo "Deploying Horizontal Pod Autoscalers..."
kubectl apply -f kubernetes/deployment/23-order-hpa.yaml
kubectl apply -f kubernetes/deployment/24-payment-hpa.yaml
kubectl apply -f kubernetes/deployment/25-frontend-hpa.yaml

# 9. 네트워크 설정
echo "Configuring network..."
kubectl apply -f kubernetes/network/26-ingress.yaml
kubectl apply -f kubernetes/network/27-frontend-network-policy.yaml
kubectl apply -f kubernetes/network/28-order-network-policy.yaml
kubectl apply -f kubernetes/network/29-payment-network-policy.yaml
kubectl apply -f kubernetes/network/30-database-network-policy.yaml
kubectl apply -f kubernetes/network/31-kafka-network-policy.yaml

# 10. 모니터링 설정
echo "Setting up monitoring..."
kubectl apply -f kubernetes/monitoring/32-prometheus-configmap.yaml

echo "Deployment completed successfully!"