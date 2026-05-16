# USAGIX Architecture Documentation

This directory contains architecture documentation, diagrams, and design rationale for the USAGIX specification.

## Reference Documents

### Architectural Diagrams
Available in [../diagrams/](../diagrams/):
- **[protocol-stack.mmd](../diagrams/usage-protocol-stack.mmd)** — USAGIX protocol stack layers (L1-L4)
- **[agent-lifecycle.mmd](../diagrams/usage-lifecycle-state-machine.mmd)** — Agent runtime state machine
- **[tool-execution.mmd](../diagrams/usage-tool-execution-sequence.mmd)** — Tool execution sequence diagram

**Substrate-Specific Diagrams**:
- **[Myelin-AX Pod Topography](https://github.com/shivashankartummala/myelin-ax/blob/main/diagrams/myelin-ax-pod-topography.mmd)** — Kubernetes pod architecture (in myelin-ax repository)

### Detailed Specifications
Core architecture documents available in [../spec/](../spec/) and [../RFC/](../RFC/):
- **[RFC-0001: Core Architecture](../RFC/rfc-0001-usagix-core.md)** — Trust domains, semantic types, formal contracts
- **[RFC-0005: ASI System Calls](../RFC/rfc-0005-asi-system-calls.md)** — gRPC protocol stack design
- **[RFC-0006: Security Model](../RFC/rfc-0006-security-model.md)** — Trust domain architecture and security boundaries
- **[memory-model.md](../spec/memory-model.md)** — Memory virtualization architecture
- **[security-model.md](../spec/security-model.md)** — Security model and threat analysis

## Architecture Overview

USAGIX defines a layered architecture separating concerns across multiple tiers:

```
┌─────────────────────────────────────────────────────────┐
│  Application Layer (Agent Code)                         │
└──────────────────────┬──────────────────────────────────┘
                       │ gRPC (ASI v1)
┌──────────────────────▼──────────────────────────────────┐
│  Cognitive Container (Untrusted Agent Runtime)          │
│  - Language Runtime (Python, JavaScript, etc.)          │
│  - Agent Checkpoint Manager                             │
│  - Memory virtualization client                         │
└──────────────────────┬──────────────────────────────────┘
                       │ gRPC (ASI v1)
                    [Trust Boundary]
                       │ gRPC (ASI v1)
┌──────────────────────▼──────────────────────────────────┐
│  Governance Enforcement Plane (Trusted)                 │
│  - Capability Ledger & Validator                        │
│  - Token Budget Enforcer                                │
│  - Policy Evaluator & Decision Engine                   │
│  - Immutable Audit Logger                               │
│  - Output Scrubber & Secrets Filter                     │
│  - Memory Manager & Checkpoint Store                    │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│  Substrate Layer (Kubernetes, Serverless, WASM, VM)     │
│  - Pod/Function/Process Management                      │
│  - Network/IPC Mediation                                │
│  - Resource Quotas & Isolation                          │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│  Infrastructure (Hardware, OS, Container Runtime)       │
└─────────────────────────────────────────────────────────┘
```

## Core Design Principles

### 1. Trust Domain Separation
- **Untrusted**: Cognitive container (agent runtime)
- **Trusted**: Governance enforcement plane
- **Mediation**: All agent side effects flow through enforcement plane
- **Guarantee**: Agent cannot bypass governance controls

### 2. Capability-Based Access Control
- **Deny-by-default**: Absence of capability = denial
- **Cryptographic tokens**: Capabilities are signed tokens
- **Ledger validation**: All RPC calls validated against capability ledger
- **Immediate revocation**: Capability revocation takes effect immediately

### 3. Memory Virtualization
- **L1 (Hot)**: Current context window (~8K tokens)
- **L2 (Warm)**: Recent history (~128K tokens)
- **L3 (Cold)**: Long-term storage (unbounded)
- **Checkpointing**: Agents periodically save state to persistent storage
- **Portability**: Checkpoints are substrate-agnostic; any compliant substrate can restore

### 4. Governance-First Design
- **Declarative policies**: Define what agents can do via policies
- **Audit trail**: Every decision logged with cryptographic signature
- **Compliance reporting**: Generate audit reports for regulatory compliance
- **Policy versioning**: Policies can be updated; changes are audited

### 5. Substrate Abstraction
- **gRPC interface**: Substrate-independent protocol
- **Modular implementation**: Substrates implement governance plane independently
- **Optimizable**: Substrates can optimize memory/I/O without changing spec
- **Testable**: Conformance test suite validates substrate compliance

## Key Architectural Decisions

### Why Trust Domain Separation?
The key security insight is that untrusted agent code cannot be trusted to respect governance policies if it has direct access to the system. By placing the governance enforcement plane in a trusted domain with exclusive control over:

- Network access (agents cannot reach external services directly)
- File I/O (agents cannot read arbitrary files)
- Tool invocation (agents cannot call tools not approved by governance)
- Memory management (agents cannot expand memory beyond quota)

...we can guarantee that policies are enforced even against a compromised agent.

### Why Capability-Based Access Control?
Capabilities (unforgeable tokens) enable fine-grained, revocable access control without requiring a central policy repository to be consulted on every access. Capabilities can be:

- **Delegated**: Passed to other agents or services
- **Attenuated**: Reduced scope (e.g., "read but not write")
- **Revoked**: Central revocation list checked on every use
- **Signed**: Cryptographically authenticated; substrate cannot forge

### Why Multi-Tier Memory?
Agents process information at different time scales:

- **L1 (immediate)**: Working memory for current task (tokens needed now)
- **L2 (recent)**: Context for recent decisions (last N interactions)
- **L3 (historical)**: Long-term knowledge (facts, learned patterns)

Different tiers have different performance/cost tradeoffs:

- L1 in fast memory (GPU/host memory); expensive but fast
- L2 in persistent storage with caching; moderate cost/speed
- L3 in durable storage; cheap but slower to retrieve

Agents benefit from all three tiers without managing the complexity.

### Why gRPC Over REST?
- **Streaming**: Needed for real-time I/O (stdout, token streaming)
- **Multiplexing**: Efficient for many concurrent requests
- **Strongly typed**: Protocol buffers ensure type safety
- **Language-agnostic**: Works with Python, Go, JavaScript, C++, etc.

## Reference Implementation Mappings

See the [Myelin-AX repository](https://github.com/shivashankartummala/myelin-ax/blob/main/ARCHITECTURE.md) for how abstract USAGIX concepts map to Kubernetes primitives:

- **Cognitive Container** → Kubernetes pod with LLM runtime sidecar
- **Governance Enforcement Plane** → Kubernetes pod with myelin-proxy sidecar
- **Capability Tokens** → Kubernetes ServiceAccount with RBAC rules
- **Immutable Audit Logging** → CloudTrail or GKE audit logs
- **Memory Management** → Kubernetes PVC for persistent checkpoints

---

## For Different Roles

### Substrate Implementers
1. Read this README for high-level overview
2. Review [RFC-0001](../RFC/rfc-0001-usagix-core.md) for core architecture and trust domains
3. Study [RFC-0005](../RFC/rfc-0005-asi-system-calls.md) for ASI gRPC protocol contract details
4. Review [RFC-0006](../RFC/rfc-0006-security-model.md) for security requirements
5. Reference [Myelin-AX](https://github.com/shivashankartummala/myelin-ax) for a complete Kubernetes implementation reference

### Security Engineers
1. Start with [RFC-0006: Security Model](../RFC/rfc-0006-security-model.md) for threat analysis and mitigations
2. Review [../spec/security-model.md](../spec/security-model.md) for detailed security model
3. Check [RFC-0004: Governance Model](../RFC/rfc-0004-governance-model.md) for capability-based access control design
4. See [../SECURITY.md](../SECURITY.md) for additional security requirements

### Architects & Designers
1. Review this README for high-level architecture overview
2. Study the [Architectural Diagrams](#architectural-diagrams) section for visual understanding
3. Deep dive into relevant RFCs based on your focus area
4. Reference [Myelin-AX ARCHITECTURE.md](https://github.com/shivashankartummala/myelin-ax/blob/main/ARCHITECTURE.md) for Kubernetes-specific implementation patterns

---

**Last Updated**: 2025-03-15  
**Maintained By**: USAGIX Specification Stewards
