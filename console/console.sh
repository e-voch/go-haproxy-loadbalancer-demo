#!/bin/sh
set -eu

HAPROXY_URL="http://haproxy:8404/stats;csv"
HAPROXY_AUTH="admin:admin"
INTERVAL="${INTERVAL:-5}"

while true; do
  echo "=== Service Registry ($(date -u +'%Y-%m-%dT%H:%M:%SZ')) ==="
  curl -s -u "$HAPROXY_AUTH" "$HAPROXY_URL" \
    | cut -d',' -f1,2,18,19 \
    | column -s',' -t
  echo
  sleep "$INTERVAL"
done
