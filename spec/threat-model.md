# Threat Model

## Threat Classes
- Prompt injection
- Tool hijacking
- Credential exfiltration
- Lateral movement
- Sandbox escape
- Poisoned retrieval memory
- Recursive execution loops
- Denial-of-wallet
- Covert prompt exfiltration

## STRIDE Mapping (Summary)
- Spoofing: forged session or tool identity
- Tampering: checkpoint/page mutation
- Repudiation: missing immutable audit records
- Information Disclosure: secret leakage via outputs/tools
- Denial of Service: token or tool saturation
- Elevation of Privilege: bypassing tool/policy boundary

## Mitigation Matrix
- Prompt injection -> policy-typed tool arguments + deny-by-default tool scopes
- Tool hijacking -> signed tool registry + strict name/version pinning
- Credential exfiltration -> no static creds in cognition domain, proxy-issued ephemeral credentials
- Lateral movement -> egress-deny network policy and namespace segmentation
- Sandbox escape -> hardened runtimeclass, seccomp, read-only FS
- Denial-of-wallet -> token budgets, recursion limits, per-session circuit breakers
- Recursive loops -> supervision depth limits and mandatory yield checkpoints
