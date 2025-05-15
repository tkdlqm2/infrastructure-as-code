# 5. Backend Deployment 배포
kubectl apply -f 15-order-deployment.yaml
kubectl apply -f 16-payment-deployment.yaml

# 6. Backend Service 배포
kubectl apply -f 17-order-service.yaml
kubectl apply -f 18-payment-service.yaml
kubectl apply -f 19-database-services.yaml
kubectl apply -f 20-kafka-service.yaml

# 7. Frontend Deployment 배포
kubectl apply -f 21-frontend-deployment.yaml
kubectl apply -f 22-frontend-service.yaml

# 수평 확장 설정 배포
kubectl apply -f 23-order-hpa.yaml
kubectl apply -f 24-payment-hpa.yaml
kubectl apply -f 25-frontend-hpa.yaml

# 또는 모든 파일을 한번에 적용
kubectl apply -f .
