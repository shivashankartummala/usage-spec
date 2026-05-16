# Kubernetes Runtime Architecture (Myelin-AX)

## Pod Topology

```text
+--------------------------------------------------------------+
| AgentSession Pod                                              |
|                                                              |
|  +------------------+   localhost gRPC   +----------------+  |
|  | agent-brain      |-------------------->| myelin-proxy   |  |
|  | (untrusted)      |                     | (governance)   |  |
|  +------------------+                     +----------------+  |
|                                                  |            |
+--------------------------------------------------|------------+
                                                   |
                                                   | spawn isolated task
                                                   v
                                           +--------------------+
                                           | myelin-sandbox     |
                                           | RuntimeClass       |
                                           | (gVisor/Firecracker)|
                                           +--------------------+
```

## Control Plane
- `SovereignAgent` CRD: immutable policy and identity blueprint.
- `AgentSession` CRD: runtime process instance and state.
- Operator reconciliation enforces state machine and budget bounds.
- Mutating admission injects `myelin-proxy` and hardening defaults.

## Network Posture
- `agent-brain` MUST NOT have direct egress to external APIs.
- External I/O is forced through `myelin-proxy` policy chokepoint.

## Identity
- Workload identity SHOULD use SPIFFE/SPIRE compatible SVID issuance.
