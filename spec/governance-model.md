# Governance Model

## Pipeline
1. Parse syscall request.
2. Resolve identity and session policy snapshot.
3. Run OPA policy evaluation.
4. Apply redaction/scrubbing transforms.
5. Enforce budget and concurrency guards.
6. Execute or deny.
7. Emit audit and telemetry records.

## Idempotency
- Tool calls SHOULD carry idempotency keys.
- Retries MUST preserve policy context and audit correlation ids.

## Audit
Each decision MUST record:
- session id
- syscall
- policy bundle version
- allow/deny outcome
- rationale code
- latency and resource metrics
