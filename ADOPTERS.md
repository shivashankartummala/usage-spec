# USAGIX Adopters and Implementations

This document tracks organizations and projects implementing or adopting the USAGIX specification.

## How to Add Your Project

If you're implementing USAGIX or using a USAGIX-compliant substrate, please submit a PR to add your project to the appropriate section below.

**Required information**:
- Organization/Project name
- Brief description (1-2 sentences)
- Implementation focus (Kubernetes, serverless, WASM, VM, etc.)
- USAGIX version(s) supported
- GitHub/Website link
- Contact email (optional)

---

## Reference Implementations

### Myelin-AX

- **Description**: Kubernetes-native reference implementation of USAGIX specification
- **Focus**: Kubernetes pods with sidecar governance (agent-brain + myelin-proxy)
- **USAGIX Version**: v1.0.0
- **Status**: Stable
- **Repository**: [github.com/shivashankartummala/myelin-ax](https://github.com/shivashankartummala/myelin-ax)
- **Documentation**: [Myelin-AX README](https://github.com/shivashankartummala/myelin-ax/blob/main/README.md)
- **Contact**: governance@usage-spec.io

---

## Substrate Implementations

*Implementations of USAGIX specification for different platforms*

### Kubernetes-Based Substrates

*(To be populated by community)*

### Serverless Substrates

*(To be populated by community)*

### WASM Substrates

*(To be populated by community)*

### VM-Based Substrates

*(To be populated by community)*

---

## Early Adopters

*Organizations early-adopting USAGIX or piloting implementations*

*(To be populated by early partners)*

---

## Compliance Validators

*Projects/services that validate USAGIX compliance*

### USAGIX Conformance Test Suite

- **Description**: Official ASI conformance tests and compliance validators
- **Status**: In development
- **Location**: [spec/compliance/](compliance/)

---

## Ecosystem Projects

*Tools, SDKs, and integrations for USAGIX ecosystems*

### SDKs & Client Libraries

*(To be populated by community)*

### Observability & Monitoring

*(To be populated by community)*

### Policy & Governance Tools

*(To be populated by community)*

### Developer Tools & Utilities

*(To be populated by community)*

---

## Case Studies & Testimonials

*Organizations sharing their USAGIX implementation experience*

*(To be populated by adopters)*

---

## Contributing Your Implementation

### Step 1: Verify Compliance

Ensure your implementation passes the USAGIX conformance tests:

```bash
# Run compliance suite
./tools/conformance-smoke.sh your-implementation
```

### Step 2: Document Your Implementation

Create a short document describing:
- How you implemented USAGIX (trust domain separation approach)
- Which features you support (ASI v1 methods, memory tiers, governance)
- Any extensions or customizations
- Performance characteristics (latency, throughput)
- Deployment instructions

### Step 3: Submit PR

1. Fork this repository
2. Add your project to the appropriate section in ADOPTERS.md
3. Include a link to your implementation documentation
4. Submit PR with title: "Add [Your Project] to adopters list"

---

## Becoming a Featured Adopter

Projects meet the "featured" status (highlighted in documentation) if they:
- Implement ≥80% of USAGIX v1.0 specification
- Pass official conformance tests
- Have public documentation of implementation
- Actively maintain compliance with new specification versions
- Contribute back to the USAGIX specification (PRs, RFCs, feedback)

---

## Governance & Questions

- **General questions**: Open GitHub issue in this repository
- **Adopter partnerships**: Email adopters@usage-spec.io
- **Compliance questions**: Email compliance@usage-spec.io
- **Trademark usage**: See [TRADEMARK_POLICY.md](TRADEMARK_POLICY.md)

---

## Recognition

Thank you to all organizations contributing implementations, feedback, and adoption of the USAGIX specification. Your participation is critical to making USAGIX a true industry standard.

---

**Last Updated**: 2025-03-15  
**Maintained By**: USAGIX Specification Stewards
