#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v protoc >/dev/null 2>&1; then
  echo "proto-check: SKIP (protoc not installed)"
  echo "Install protoc to enable full protobuf validation."
  exit 0
fi

protoc --proto_path=proto --descriptor_set_out=/tmp/usage-asi.pb proto/usage/v1/asi.proto
rm -f /tmp/usage-asi.pb
echo "proto-check: PASS"
