# ASI Compliance Tests

## Core Lifecycle
- Spawn returns `PENDING`.
- Illegal transitions are rejected.
- Terminated sessions reject further syscalls.

## Syscall Behavior
- `UsageSignal` idempotency by `(session_id, sequence)`.
- `UsageCallTool` deny path includes policy decision metadata.
- `UsageMemPageOut` returns integrity-reference per page.

## Governance
- Capability violation yields `PERMISSION_DENIED`.
- Token exhaustion yields terminal state and `RESOURCE_EXHAUSTED` semantics.

## Isolation
- Attempted direct egress from cognition container fails.
- Dynamic code execution occurs only in sandbox profile.

## Observability
- Required state-transition events emitted.
- Required attributes present on syscall spans.
