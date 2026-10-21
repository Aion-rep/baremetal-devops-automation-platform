#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="devops-automation"
DEPLOYMENT="devops-demo-app"
REVISION="${1:-}"

echo "=== Deployment History ==="
kubectl -n "$NAMESPACE" rollout history \
  deployment/"$DEPLOYMENT"

echo

if [[ -n "$REVISION" ]]; then
    echo "Rolling back $DEPLOYMENT to revision $REVISION..."

    kubectl -n "$NAMESPACE" rollout undo \
      deployment/"$DEPLOYMENT" \
      --to-revision="$REVISION"
else
    echo "Rolling back $DEPLOYMENT to the previous revision..."

    kubectl -n "$NAMESPACE" rollout undo \
      deployment/"$DEPLOYMENT"
fi

echo
echo "Waiting for rollback to complete..."

kubectl -n "$NAMESPACE" rollout status \
  deployment/"$DEPLOYMENT" \
  --timeout=180s

echo
echo "Rollback completed successfully."
