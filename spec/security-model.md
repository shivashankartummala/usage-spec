# Security Model

## Objectives
- Constrain blast radius of compromised cognition workloads.
- Prevent direct credential and network exfiltration.
- Enforce policy on every side effect.

## Mandatory Controls
- Sidecar governance enforcement out-of-process.
- Least-privilege tool capability allowlists.
- Runtime sandboxing for dynamic code execution.
- Immutable audit trail for syscall decisions.
- Identity-bound quotas and policy snapshots.

## Trust Domains
- Domain A: Untrusted cognition (`agent-brain`).
- Domain B: Trusted governance (`myelin-proxy`).
- Domain C: Isolated executor (`myelin-sandbox`).
- Domain D: Control plane (operator, admission, policy backend).

## Security Invariants
- A cannot directly invoke D or external networks.
- A -> side effects MUST traverse B.
- C instances are ephemeral and non-reusable.
