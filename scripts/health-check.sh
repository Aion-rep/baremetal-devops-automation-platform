#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="devops-automation"
APP="devops-demo-app"

echo "=== Deployment ==="
kubectl -n "$NAMESPACE" get deployment "$APP"

echo
echo "=== Pods ==="
kubectl -n "$NAMESPACE" get pods \
  -l app="$APP" -o wide

echo
echo "=== Service ==="
kubectl -n "$NAMESPACE" get service "$APP"

echo
echo "=== Endpoints ==="
kubectl -n "$NAMESPACE" get endpointslice \
  -l kubernetes.io/service-name="$APP"

echo
echo "=== Rollout Status ==="
kubectl -n "$NAMESPACE" rollout status \
  deployment/"$APP" \
  --timeout=30s
