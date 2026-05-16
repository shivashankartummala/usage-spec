# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in the USAGIX specification or reference implementation, **please do not open a public GitHub issue**. Instead, report it confidentially to:

**Email**: security@usage-spec.io

**PGP Key**: [TBD - will be published on security@usage-spec.io]

### What to Include

Please include the following information in your report:

1. **Description**: Clear description of the vulnerability
2. **Location**: Which file(s) or component(s) are affected?
3. **Impact**: How could an attacker exploit this? What is the impact?
4. **Proof of Concept** (optional): Code or scenario demonstrating the issue
5. **Your Information**: Your name, email, and affiliation (optional for anonymity)

**Example**:
```
Subject: Security Issue - Specification compliance gap in §3.2

Description: The security model in spec/security-model.md states that 
audit logs "SHOULD be immutable," but fails to define the mechanism 
for enforcement.

Location: spec/security-model.md, §3.2 (Immutable Audit Trail)

Impact: Implementers might use weak immutability guarantees (file 
permissions, access control) instead of append-only storage, allowing 
audit log tampering by compromised substrates.

Proof of Concept:
- USAGIX v1.0 audit logs stored in S3 with bucket versioning disabled
- A compromised substrate with S3 write access can modify logs retroactively
- Tampering is undetectable because no cryptographic validation is specified

Recommendation: Either specify cryptographic signing of audit logs or 
require append-only storage (e.g., CloudTrail, immutable S3 object lock).
```

## Response Process

1. **Acknowledgment** (within 24 hours): We confirm receipt of your report
2. **Investigation** (1-2 weeks): We investigate the vulnerability
3. **Patch Development** (1-4 weeks): We develop a fix or mitigation
4. **Coordination** (optional): We coordinate with affected implementations
5. **Public Disclosure**: We publish a security advisory (with your permission)

### Disclosure Timeline

- **Day 1**: You report the vulnerability
- **Day 1**: We acknowledge receipt
- **Day 7**: Initial assessment and mitigation plan
- **Day 21**: Fix or mitigation released
- **Day 28**: Public disclosure and security advisory

If you need an expedited timeline (e.g., active exploitation), please indicate this in your report.

---

## Security Considerations for Implementers

### Specification Security Guarantees

USAGIX provides security guarantees in several areas. Implementers MUST:

1. **Trust Domain Separation** (Mandatory)
   - Cognitive Container runs in untrusted sandbox
   - Governance Enforcement Plane runs in trusted domain
   - No direct communication between container and external systems
   - All side effects mediated through enforcement plane

2. **Capability-Based Access Control** (Mandatory)
   - All tool invocations validated against capability ledger
   - Deny-by-default (absence of grant = denial)
   - Cryptographically signed capability tokens
   - Revocation must be immediate

3. **Token Budget Enforcement** (Mandatory)
   - Hard limit on LLM tokens consumed
   - Enforced at substrate level (agent cannot override)
   - Monotonic accounting (tokens consumed never decreases)
   - Budget exhaustion triggers agent termination

4. **Immutable Audit Trail** (Mandatory)
   - All governance decisions logged
   - Append-only storage (no deletion)
   - Cryptographically signed logs
   - Tamper-evident (integrity verification on read)

5. **Output Scrubbing** (Mandatory)
   - All tool results scanned for PII, secrets, malware patterns
   - Detected sensitive data redacted or blocked
   - Redaction decisions logged

6. **Memory Isolation** (Mandatory)
   - Agent cannot directly access other agents' context
   - Memory pages integrity-verified on retrieval
   - Expired pages unavailable (unless retention exception)

### Threat Model & Limitations

See [spec/security-model.md](spec/security-model.md) for detailed threat model.

**USAGIX assumes the following are secure**:
- Substrate implementation (code is correct)
- Hardware/infrastructure (no physical attacks)
- Tool implementations (tool code is correct)
- LLM model weights (not backdoored)

**USAGIX does NOT defend against**:
- Compromised substrate code
- Physical hardware compromise
- Tool implementation bugs
- Backdoored or adversarially-trained LLM models

---

## Security Audits

The USAGIX specification undergoes regular security reviews:

### Audit Schedule

- **v1.0 Initial Audit**: Q2 2025 (CNCF-recommended firm)
- **Annual Audits**: Yearly security review
- **RFC Audits**: Security implications reviewed before MAJOR changes

### Publishing Audit Results

Security audit reports are published (with redactions for active issues) in the [compliance/security-audits/](compliance/) directory.

---

## Reporting Other Security Issues

### Non-Vulnerability Security Concerns

If you have security concerns that don't constitute a vulnerability (e.g., architectural recommendations, threat modeling suggestions), please:

1. **Open an issue** with the `security` label
2. **Email governance@usage-spec.io** for discussion
3. **Request an RFC** if your concern requires specification changes

### Implementation Security Issues

Found a security bug in Myelin-AX or another reference implementation?

- **Reference implementation bugs**: Report to the implementation project's security team
- **Specification gaps**: Report to security@usage-spec.io

---

## Security Best Practices for Adoption

### For Substrate Implementers

1. **Follow the specification exactly**: Security guarantees depend on compliance
2. **Implement all mandatory controls**: No exceptions for "simple" deployments
3. **Get security audited**: Have your implementation reviewed by a security firm
4. **Run conformance tests**: Validate compliance with USAGIX test suite
5. **Report issues upstream**: Any specification gaps should be reported

### For Adopters

1. **Verify implementation compliance**: Use official conformance tests
2. **Understand the threat model**: Read spec/security-model.md
3. **Configure policies correctly**: Weak governance policies undermine security
4. **Monitor audit logs**: Enable immutable audit logging
5. **Plan for key rotation**: Update signing keys regularly (90-day cycle)

### For Policy Authors

1. **Principle of least privilege**: Grant minimum necessary capabilities
2. **Short-lived credentials**: Issue short-lived capability tokens (TTL ≤ 1 hour)
3. **Re-validate on resume**: Policies may change during checkpoint suspension
4. **Audit suspicious activity**: Monitor policy violation attempts
5. **Incident response plan**: Document how to respond to policy violations

---

## Supported Versions

Security patches are released for:

- **Current version** (v1.0.0): All security fixes
- **Previous major version** (v1.x): Critical fixes only
- **Older versions**: No patches (upgrade recommended)

We recommend keeping implementations up-to-date with the latest specification version.

---

## Security Checklist for Deployments

Use this checklist before deploying a USAGIX-compliant substrate in production:

### Specification Compliance
- [ ] Trust domain separation implemented (agent ≠ governance plane)
- [ ] Capability-based access control enforced
- [ ] Token budget is hard limit (agent cannot override)
- [ ] All tool calls validated against capability ledger
- [ ] Output scrubbing implemented (PII/secret detection)
- [ ] Immutable audit logging enabled

### Operational Security
- [ ] Audit logs sent to external SIEM (CloudTrail, Datadog, etc.)
- [ ] Cryptographic signing of audit logs enabled
- [ ] Key rotation schedule established (90-day cycle)
- [ ] Access to governance policies restricted to admins
- [ ] Incident response plan documented
- [ ] Security scanning of substrate images enabled (container scanning)

### Compliance & Governance
- [ ] Governance policies defined and documented
- [ ] Data classification levels assigned
- [ ] PII handling policies configured
- [ ] Secret detection patterns customized for your environment
- [ ] Rate limits set appropriately for your workload
- [ ] Quota enforcement tested

### Monitoring & Alerting
- [ ] Policy violation attempts monitored
- [ ] Budget exhaustion alerts configured
- [ ] Tool execution latency baseline established
- [ ] Suspicious activity detection rules configured
- [ ] Oncall escalation process defined

---

## Contact

**Security Team**: security@usage-spec.io  
**Governance**: governance@usage-spec.io  
**General Questions**: Open a GitHub issue

---

**Last Updated**: 2025-03-15  
**Maintained By**: USAGIX Specification Stewards
