#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

required_files=(
  "README.md"
  "proto/usage/v1/asi.proto"
  "schemas/agent_manifest.schema.json"
  "spec/usage-core.md"
  "spec/rfc-001-lifecycle.md"
  "spec/security-model.md"
  "spec/threat-model.md"
  "spec/memory-model.md"
  "spec/scheduling-model.md"
  "spec/governance-model.md"
  "spec/coordination-model.md"
  "spec/compliance-suite.md"
  "spec/otel-semconv-proposal.md"
  "spec/cncf-positioning.md"
  "spec/standardization-roadmap.md"
  "crds/sovereignagent.example.yaml"
  "crds/agentsession.example.yaml"
  "compliance-tests/asi-compliance-tests.md"
)

for f in "${required_files[@]}"; do
  [[ -f "$f" ]] || { echo "Missing required file: $f"; exit 1; }
done

# Verify README links point to existing local files.
while IFS= read -r link; do
  path="${link#*(}"
  path="${path%)*}"
  [[ -z "$path" ]] && continue
  [[ "$path" =~ ^https?:// ]] && continue
  [[ -f "$path" ]] || { echo "Broken README link: $path"; exit 1; }
done < <(rg -o "\[[^\]]+\]\([^)]+\)" README.md)

echo "lint: PASS"
