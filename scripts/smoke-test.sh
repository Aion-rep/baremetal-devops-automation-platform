#!/usr/bin/env bash

set -euo pipefail

NAMESPACE="devops-automation"
SERVICE="devops-demo-app"
LOCAL_PORT="${LOCAL_PORT:-18081}"

cleanup() {
    if [[ -n "${PF_PID:-}" ]]; then
        kill "$PF_PID" 2>/dev/null || true
    fi
}

trap cleanup EXIT

echo "Starting temporary port-forward..."

kubectl -n "$NAMESPACE" port-forward \
  service/"$SERVICE" \
  "${LOCAL_PORT}:80" \
  >/tmp/devops-smoke-portforward.log 2>&1 &

PF_PID=$!

sleep 2

echo "Testing /health..."

RESPONSE=$(curl --fail --silent --show-error \
  "http://127.0.0.1:${LOCAL_PORT}/health")

echo "Response: $RESPONSE"

echo "$RESPONSE" | grep -q '"status":"healthy"'

echo "Smoke test passed."
