#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rg -n "Pending|Active|Thinking|Paused|Terminated" spec/rfc-001-lifecycle.md >/dev/null
rg -n "UsageSpawn|UsageYield|UsageSignal|UsageMemPageOut|UsageCallTool" proto/usage/v1/asi.proto >/dev/null
rg -n "kind:\s*SovereignAgent" crds/sovereignagent.example.yaml >/dev/null
rg -n "kind:\s*AgentSession" crds/agentsession.example.yaml >/dev/null
rg -n "Core Lifecycle|Syscall Behavior|Governance|Isolation|Observability" compliance-tests/asi-compliance-tests.md >/dev/null

echo "conformance-smoke: PASS"
