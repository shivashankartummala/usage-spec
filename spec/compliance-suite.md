# Conformance and Compliance Suite

## Profiles
- Core Profile: ASI syscall semantics and lifecycle state machine.
- Governance Profile: policy enforcement, redaction, idempotency.
- Isolation Profile: network isolation and sandbox integrity.
- Observability Profile: required events, attributes, and traces.

## Test Categories
- Protocol tests: request/response compatibility and error codes.
- Behavioral tests: legal/illegal state transitions.
- Security tests: deny-path guarantees and boundary bypass attempts.
- Performance tests: control-plane overhead and signal latency.

## Pass Criteria
Implementation is compliant when all mandatory tests pass for declared profile.
