# ASI System Calls

## 1. UsageSpawn
Creates a process instance under a parent session.
- MUST validate parent ownership and namespace policy.
- MUST bind quota, capability set, and runtime profile.
- Returns session identity and initial state (`PENDING`).

## 2. UsageYield
Voluntary cooperative yield with checkpoint intent.
- Caller MUST be `THINKING`.
- Substrate MUST persist a resumable checkpoint reference.
- Result transitions to `PAUSED` unless denied by policy.

## 3. UsageSignal
Asynchronous signal delivery to session.
- Signals are advisory or terminal depending on signal type.
- Delivery MUST be idempotent by `(session_id, sequence)`.
- Terminal signals MUST transition to `TERMINATED`.

## 4. UsageMemPageOut
Requests context demotion from hot context into lower tiers.
- Caller MUST provide page references and policy labels.
- Substrate MUST return integrity-hashable references.
- Sensitive pages MUST honor encryption and retention policy.

## 5. UsageCallTool
Mediated side-effect syscall.
- Tool name and arguments MUST be policy-evaluated before execution.
- Runtime MUST enforce timeout, idempotency key, and egress constraints.
- Response MUST include execution metadata and policy decision trace id.

## 6. Error Semantics
Common canonical errors:
- `PERMISSION_DENIED`
- `RESOURCE_EXHAUSTED`
- `FAILED_PRECONDITION`
- `DEADLINE_EXCEEDED`
- `ABORTED`
- `UNAVAILABLE`

## 7. Supervision Semantics
`UsageSpawn` forms parent-child ownership. Parent termination policy MAY cascade based on `cascade_mode`.
