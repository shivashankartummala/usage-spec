#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

jq empty schemas/agent_manifest.schema.json

python3 - << 'PY'
import json
from pathlib import Path

schema_path = Path("schemas/agent_manifest.schema.json")
examples = [
    Path("examples/agent_manifest_basic.yaml"),
    Path("examples/agent_manifest_advanced.yaml"),
]

schema = json.loads(schema_path.read_text())
required_top = schema.get("required", [])
if "apiVersion" not in required_top or "kind" not in required_top or "spec" not in required_top:
    raise SystemExit("schema-check: FAIL (top-level required keys missing)")

for ex in examples:
    text = ex.read_text()
    for k in ("apiVersion:", "kind:", "spec:"):
        if k not in text:
            raise SystemExit(f"schema-check: FAIL ({ex} missing {k})")

print("schema-check: PASS")
PY
