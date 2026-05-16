# USAGIX Specification Charter

## Mission

The USAGIX specification defines an open standard for agent governance, enabling safe, auditable, and interoperable AI systems across diverse infrastructure platforms. USAGIX serves as the semantic foundation for agent trust domains, governance policies, and capability-based access control—enabling organizations to deploy sophisticated AI applications with confidence.

---

## Vision Statement

To become the industry-standard specification for agent governance, analogous to POSIX for operating systems, ONNX for machine learning, and OpenTelemetry for observability.

---

## Scope

The USAGIX specification defines:

1. **Architecture & Trust Domains**
   - Separation between untrusted cognitive agents and trusted governance enforcement planes
   - Cross-platform trust boundary definitions
   - Substrate-agnostic interfaces for different deployment models

2. **Agent Substrate Interface (ASI)**
   - gRPC-based wire protocol for agent-substrate communication
   - System calls for memory, I/O, and governance interactions
   - Capability-based access control tokens
   - Tool invocation and result handling

3. **Memory Virtualization**
   - Multi-tier memory model (L1, L2, L3)
   - Context window management and checkpointing
   - Memory isolation guarantees
   - Predictable memory behavior across substrates

4. **Governance & Policy**
   - Declarative policy models for controlling agent behavior
   - Capability ledgers and access control
   - Resource quotas and rate limiting
   - Audit logging and compliance reporting

5. **Security Model**
   - Threat analysis and threat model documentation
   - Security guarantees and assumptions
   - Vulnerability disclosure and remediation processes
   - Mandatory security controls for implementers

6. **Runtime Semantics**
   - Agent lifecycle and state machine
   - Checkpoint/restore semantics
   - Tool call execution and result handling
   - Error handling and recovery

### Out of Scope

The USAGIX specification does NOT define:

- **LLM Model Selection**: Implementations may use any LLM provider or model
- **Policy Authoring Interfaces**: Individual substrates define their own policy UIs
- **Tool Implementations**: Tool behavior and semantics are defined by tool authors
- **Substrate Details**: Implementation-specific optimization strategies
- **Network Transport**: While ASI uses gRPC, substrates may optimize transport independently

---

## Governance

USAGIX is governed by a Technical Steering Committee (TSC) comprising:

- **Maintainers** (2-3): Core specification stewards
- **Community Representatives** (2-3): Implementers and adopters
- **Ex-Officio**: CNCF TAG representatives (if adopted into CNCF)

### Decision-Making

- **Consensus-based**: Decisions prefer unanimous agreement
- **Voting** (on impasse): Simple majority (50% + 1) for MINOR/PATCH; supermajority (2/3) for MAJOR
- **RFC process**: MAJOR changes require 2-week review + TSC vote
- **Transparency**: All decisions documented in GitHub issues/PRs

See [GOVERNANCE.md](GOVERNANCE.md) for full governance policy.

---

## Standards Alignment

USAGIX is designed for alignment with:

1. **CNCF Graduation Path**
   - Target: Sandbox acceptance (Q2 2025) → Incubating (Q4 2025) → Graduated (Q4 2026)
   - Requirements: Governance structure ✅, IP policy ✅, Code of Conduct ✅, Security audit (in progress)

2. **OpenTelemetry (v1.1+)**
   - Semantic conventions for agent lifecycle, tool execution, governance decisions
   - Distributed tracing hooks for checkpoint/restore and policy decisions
   - Metrics subscription via `UsageObserve` RPC

3. **W3C/IETF Standards Track (Future)**
   - Prepare governance structure for W3C Recommendation or IETF RFC pathway
   - Semantic alignment with web standards (authentication, authorization)

4. **ISO/IEC Standardization (2027+)**
   - Formal governance model supporting ISO submission
   - Comprehensive conformance test suite for certification

---

## Core Values

1. **Substrate Agnostic**: Specification works across Kubernetes, serverless, WASM, VMs, and future platforms
2. **Trust-First Design**: Security as a first-class concern, not an afterthought
3. **Interoperability**: Implementations can be swapped without application changes
4. **Auditability**: All decisions logged and cryptographically signed
5. **Open Governance**: Community-driven decision-making with transparent processes

---

## Specification Versioning

USAGIX follows semantic versioning with formal backward-compatibility guarantees:

- **MAJOR** (v2.0): Breaking changes; 1-year deprecation window
- **MINOR** (v1.1): New features; fully backward-compatible
- **PATCH** (v1.0.1): Bug fixes; fully backward-compatible

See [spec/versioning.md](spec/versioning.md) for detailed policy.

---

## Community & Adoption

### Adopters & Implementations

Organizations implementing USAGIX or using USAGIX-compliant substrates are tracked in [ADOPTERS.md](ADOPTERS.md). Featured adopter status requires:

- ≥80% specification compliance
- Passing official conformance tests
- Public implementation documentation
- Active maintenance of specification version updates

### Contribution Process

All contributions follow the process defined in [CONTRIBUTING.md](CONTRIBUTING.md):

- Bug reports and feature requests via GitHub issues
- Feature proposals via RFC process (MAJOR changes)
- PRs signed with Developer Certificate of Origin (DCO)
- Review by 1+ maintainers; TSC vote on MAJOR changes

### Communication

- **GitHub Issues**: Bugs, features, questions
- **GitHub Discussions**: General conversation
- **Email**:
  - governance@usage-spec.io (governance questions)
  - security@usage-spec.io (security issues)
  - adopters@usage-spec.io (adoption partnerships)

---

## Security & Compliance

USAGIX provides formal security guarantees to implementers:

1. **Mandatory Security Controls**: 6 areas (trust domains, capability-based access control, token budgets, immutable audit logging, output scrubbing, memory isolation)
2. **Threat Model**: Detailed threat analysis in [spec/security-model.md](spec/security-model.md)
3. **Vulnerability Disclosure**: Confidential reporting to security@usage-spec.io
4. **Audit Process**: Security audits planned for v1.0 (Q2 2025) and annually thereafter

See [SECURITY.md](SECURITY.md) for vulnerability reporting and security best practices.

---

## Intellectual Property

By contributing to USAGIX, contributors agree to:

1. **License Work Under Apache 2.0**: All contributions licensed under Apache 2.0
2. **Developer Certificate of Origin (DCO)**: All commits signed (`git commit -s`)
3. **Patent Grant**: Royalty-free, perpetual license under contributor patents (W3C model)

See [LICENSING.md](LICENSING.md) for full IP policy.

---

## Roadmap

USAGIX follows a multi-year evolution plan:

| Phase | Timeline | Focus |
|-------|----------|-------|
| **v1.0** | ✅ 2025-03 | Core architecture, ASI v1, memory model, governance, security |
| **Phase 1** | 📅 2025 Q2-Q3 | CNCF Sandbox, security audit, adopter partnerships |
| **v1.1** | 📅 2025 Q3 | OpenTelemetry integration, enhanced observability |
| **v1.2** | 📅 2025 Q4 | Advanced memory management, cognitive scheduling |
| **Phase 2** | 📅 2026 Q2 | CNCF Incubating nomination, 2+ independent implementations |
| **v2.0** | 📅 2026 Q4 | Breaking changes, new trust models, multi-agent governance |
| **Phase 3** | 📅 2027+ | CNCF Graduated, W3C/IETF alignment, industry standard |

See [ROADMAP.md](ROADMAP.md) for detailed timeline.

---

## Success Criteria

USAGIX is successful when:

1. **Community**: 3+ independent substrate implementations across different platforms
2. **Adoption**: 10+ organizations in early adoption phase by Q3 2025; 50+ by Q4 2026
3. **Standards**: Accepted into CNCF Sandbox (Q2 2025) with trajectory to Graduated (Q4 2026)
4. **Ecosystem**: Emerging tools for policy authoring, compliance validation, and observability
5. **Quality**: Zero critical security vulnerabilities; passing conformance tests across implementations

---

## Historical Context

USAGIX emerged from the need to safely deploy sophisticated AI agents in production environments. Prior to USAGIX, implementations lacked a common foundation for:

- Trustworthy governance across different infrastructure platforms
- Interoperable capability-based access control
- Portable memory models for agent checkpointing
- Auditable decision-making and compliance reporting

USAGIX fills these gaps by defining a substrate-agnostic specification that enables both innovation (substrate implementations can optimize independently) and interoperability (agent code is portable across compliant substrates).

---

## Related Documents

- **[README.md](README.md)** — Project overview and getting started
- **[GOVERNANCE.md](GOVERNANCE.md)** — TSC composition and decision-making
- **[CONTRIBUTING.md](CONTRIBUTING.md)** — Contribution guidelines and PR workflow
- **[ROADMAP.md](ROADMAP.md)** — Multi-year specification evolution plan
- **[ADOPTERS.md](ADOPTERS.md)** — Organizations implementing or adopting USAGIX
- **[SECURITY.md](SECURITY.md)** — Security guarantees and vulnerability disclosure
- **[LICENSING.md](LICENSING.md)** — IP policy, DCO, and patent grants
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** — Community standards and conduct
- **[TRADEMARK_POLICY.md](TRADEMARK_POLICY.md)** — Trademark usage guidelines

---

## Contact

- **Governance**: governance@usage-spec.io
- **Security**: security@usage-spec.io
- **Adopters**: adopters@usage-spec.io
- **GitHub**: [Open an issue](https://github.com/shivashankartummala/usage-spec/issues)

---

**Charter Approved**: 2025-03-15  
**Last Updated**: 2025-03-15  
**Maintained By**: USAGIX Specification Stewards
