# 1. 네임스페이스 생성
kubectl apply -f 1-namespaces.yaml

# 2. ConfigMap 생성
kubectl apply -f 2-frontend-configmap.yaml
kubectl apply -f 3-order-configmap.yaml
kubectl apply -f 4-payment-configmap.yaml
kubectl apply -f 5-kafka-configmap.yaml

# 3. Secret 생성
kubectl apply -f 6-order-secrets.yaml
kubectl apply -f 7-payment-secrets.yaml
kubectl apply -f 8-db-secrets.yaml

# 4. PersistentVolume 및 PersistentVolumeClaim 생성
kubectl apply -f 9-database-pv.yaml
kubectl apply -f 10-database-pvc.yaml
kubectl apply -f 11-kafka-pvc.yaml

# 5. StatefulSet 생성
kubectl apply -f 12-order-db-statefulset.yaml
kubectl apply -f 13-payment-db-statefulset.yaml
kubectl apply -f 14-kafka-statefulset.yaml

# 또는 모든 파일을 한번에 적용
kubectl apply -f .
