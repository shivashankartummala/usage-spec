# USAGE Specification Roadmap

## Vision

USAGE is on a path to become an industry-standard specification for agent governance, analogous to POSIX for operating systems or ONNX for machine learning. This roadmap outlines the evolution of the specification and reference implementations.

## Timeline

### Current: v1.0.0 (Released March 2025)

**Status**: Stable — Candidate for open standard and CNCF Sandbox

**Components**:
- Core architecture and trust domains
- Agent Substrate Interface (ASI) gRPC v1
- Memory virtualization model (L1/L2/L3)
- Governance and policy model
- Security model and threat analysis
- Runtime state machine
- Compliance profiles (HIPAA, PCI-DSS, SOC2, GDPR)

**Achievements**:
- RFC 2119 normative language binding ✅
- Formal versioning policy ✅
- CNCF hard gate compliance (license, governance, CoC) ✅
- Spec-implementation separation ✅
- Myelin-AX reference implementation ✅

---

## Phase 1: CNCF Sandbox (Q2-Q3 2025)

**Goals**:
- [ ] Submit to CNCF Sandbox
- [ ] Establish governance structure (TSC, maintainers)
- [ ] Build community (adopters, implementers)
- [ ] Complete security audit of specification

**Work Items**:
- [ ] Security review by CNCF-recommended firm
- [ ] Finalize adopter partnerships (3-5 substrate implementers)
- [ ] Publish compliance test suite (ASI conformance)
- [ ] Establish release process (semantic versioning, LTS track)

---

## Phase 2: v1.1.0 — Enhanced Observability (Q3 2025)

**Goals**: Strengthen OpenTelemetry integration and observability

**Features**:
- [ ] OTel semantic conventions (stable track)
  - Agent lifecycle metrics (spawn, thinking, paused, terminated)
  - Tool execution metrics (latency, errors, rate)
  - Governance decision metrics (allows, denies, policy violations)
  - Token budget tracking (consumed, remaining, projected)

- [ ] Distributed tracing hooks
  - Checkpoint save/restore tracing
  - Tool call tracing with context propagation
  - Policy decision audit trail linking

- [ ] New RPC: `UsageObserve` for metrics subscription

**Backward Compatibility**: Fully backward-compatible with v1.0.0

---

## Phase 3: v1.2.0 — Advanced Memory & Scheduling (Q4 2025)

**Goals**: Add intelligent memory management and cognitive scheduling

**Features**:
- [ ] Bidirectional memory hints
  - Agent can suggest context chunks for demotion (PageOut hints)
  - Agent can predict memory pressure
  - Substrate provides pressure feedback loop

- [ ] Cognitive scheduling dimensions
  - Token burn rate prediction
  - Context window pressure index (CPI)
  - Provider rate limit awareness

- [ ] New RPC: `UsageMemoryPressure` for adaptive paging

**Backward Compatibility**: Additive-only (existing code works unchanged)

---

## Phase 4: v2.0.0 — Breaking Changes & New Trust Models (2026)

**Goals**: Enable new trust models and deployment patterns

**Breaking Changes** (require major version):
- [ ] Checkpoint header v2 format (enhanced security properties)
- [ ] ASI gRPC v2 (new RPC methods, simplified semantics)
- [ ] Policy schema v2 (unified time-based and attribute-based access control)

**New Features**:
- [ ] Multi-agent governance (cross-agent resource sharing)
- [ ] Federated governance (policy inheritance across trust boundaries)
- [ ] Hardware attestation integration (TEE/SGX/TDX support)

**Migration Path**: 1-year deprecation window (v1.15 → v2.0)

---

## Adopters & Implementations

### Phase 1 Adopter Targets

**Substrate Implementers** (1+ per category):
- [ ] Kubernetes-based: Myelin-AX (reference), AnythingLLM, Credal
- [ ] Serverless: AWS Lambda/SageMaker, Google Cloud Run, Azure Functions
- [ ] WASM: Wasmtime, WasmEdge substrate
- [ ] VM-based: KVM, QEMU, systemd-managed processes

**Enterprise Adopters** (early validation):
- [ ] Healthcare provider (HIPAA compliance validation)
- [ ] FinTech company (PCI-DSS compliance validation)
- [ ] SaaS platform (SOC2 compliance validation)

---

## Standards Track

### CNCF Graduation Path

```
Q2 2025: Sandbox Acceptance
    ↓
Q4 2025: Incubating Stage (2+ independent implementations, 10+ adopters)
    ↓
Q4 2026: Graduated Stage (5+ implementations, 50+ adopters, formal governance)
    ↓
2027+: Industry Standard (W3C/IETF/IEEE endorsement or equivalent)
```

### Alignment with Related Standards

- **OpenTelemetry**: Semantic conventions alignment (v1.1+)
- **CNCF Graduation**: Address all checklist items (security audit, IP policy, governance, CoC)
- **ISO/IEC**: Prepare for future ISO standardization (governance structure)
- **W3C/IETF**: Explore W3C Recommendation track or IETF RFC pathway

---

## Community Milestones

| Date | Milestone | Status |
|------|-----------|--------|
| 2025-03-15 | v1.0.0 release | ✅ Complete |
| 2025-04-15 | CNCF Sandbox application | 📅 Planned |
| 2025-06-15 | Security audit completion | 📅 Planned |
| 2025-09-15 | 3+ independent implementations | 📅 Planned |
| 2025-12-15 | v1.1.0 release (OTel integration) | 📅 Planned |
| 2026-03-15 | Incubating stage graduation | 📅 Planned |
| 2026-12-15 | v2.0.0 release | 📅 Planned |
| 2027-Q1 | Graduated stage nomination | 📅 Planned |

---

## How to Contribute

Interested in implementing USAGE or contributing to the specification?

1. **Read**: [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
2. **Review**: [GOVERNANCE.md](GOVERNANCE.md) for decision-making process
3. **Implement**: Start with [spec/usage-core.md](spec/usage-core.md) and [RFC/rfc-001-lifecycle.md](RFC/rfc-001-lifecycle.md)
4. **Feedback**: Join the discussion in GitHub issues/PRs or contact governance@usage-spec.io

---

## Questions?

- **General questions**: Open a GitHub issue
- **Security concerns**: Email security@usage-spec.io
- **Governance questions**: Email governance@usage-spec.io
- **Adopter partnerships**: Email adopters@usage-spec.io
