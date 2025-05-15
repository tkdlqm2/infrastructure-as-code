#!/bin/bash
# delete-namespaces.sh

# 삭제할 네임스페이스 목록
NAMESPACES="frontend order-service payment-service database message-queue monitoring"

# 각 네임스페이스 삭제
for NS in $NAMESPACES; do
  echo "Deleting namespace: $NS"
  kubectl delete namespace $NS --timeout=60s
done

# 완료 확인
echo "Checking remaining namespaces..."
kubectl get namespaces
