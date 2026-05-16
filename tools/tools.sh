#!/usr/bin/env bash
set -euo pipefail

for t in jq python3 protoc yq ajv; do
  if command -v "$t" >/dev/null 2>&1; then
    echo "FOUND  $t -> $(command -v "$t")"
  else
    echo "MISSING $t"
  fi
done
