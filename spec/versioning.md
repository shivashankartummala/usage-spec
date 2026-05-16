# USAGIX Specification Versioning Policy

## Overview

This document defines semantic versioning (SemVer) policies for the USAGIX specification suite, 
wire protocols, and policy bundles. The goal is to provide clear, enforceable compatibility 
guarantees to substrate implementers and policy authors.

## Specification Version

The USAGIX specification follows **Semantic Versioning 2.0.0** (semver.org).

**Format**: `MAJOR.MINOR.PATCH` (e.g., `1.0.0`, `1.1.0`, `1.2.3`)

- **MAJOR**: Breaking changes to normative semantics or fundamental concepts
- **MINOR**: Additive features or clarifications that don't affect existing compliant implementations
- **PATCH**: Documentation fixes, examples, non-normative clarifications

**Current Specification Version**: 1.0.0 (released 2025-03-15)

## Wire Protocol Versioning (ASI gRPC)

### Stable Track: `proto/usage/v1/asi.proto`

**Status**: Stable  
**Compatibility**: Additive-only  
**Guarantees**:
- No field renumbering
- No removal of RPC methods
- No removal of message fields
- New fields added with explicit defaults
- New RPC methods added only with new minor versions
- Field semantics never change for existing field IDs

**Rule**: If you implement against `usagix.v1.asi.proto`, all future v1.x releases will remain wire-compatible.

**Breaking Changes Policy**: Breaking changes reserved for v2.0.0 only (and announced 1 year in advance).

### Alpha Track: `proto/usage/v1alpha*/asi.proto` (if applicable)

**Status**: Experimental  
**Compatibility**: No guarantees  
**Guarantees**: None. Alpha APIs can change arbitrarily between v1alpha1 → v1alpha2.

**Rule**: Avoid alpha APIs in production. Alpha APIs graduate to stable (v1) only after review and consensus.

## CRD apiVersion (Kubernetes-Specific)

For Kubernetes substrates, CRDs MUST follow Kubernetes API versioning conventions:

- **Stable**: `usage.io/v1` (stable, additive-only, same wire guarantee as ASI v1)
- **Beta**: `usage.io/v1beta1` (may have breaking changes in v1beta2)
- **Alpha**: `usage.io/v1alpha1` (no compatibility guarantee)

## OTel Attributes (Semantic Convention Stability)

USAGIX semantic attributes align with OpenTelemetry semantic convention stability model:

| Stability Track | Compatibility | Rules |
|-----------------|---|-------|
| **Stable** | Additive-only | No removal, no semantic change, new attributes with defaults only |
| **Experimental** | No guarantees | Can change or remove at any time |
| **Deprecated** | Scheduled removal | Deprecated in vN.M, removed in vN+1.0 |

**Deprecation Window**: Deprecated attributes remain functional for at least 1 year (or 2 minor versions) before removal.

**Example**: If attribute `usage.agent.token_budget` is stable in v1.2.0, it MUST function identically in v1.2.1, v1.3.0, v1.4.0, etc.

## Compliance Profiles (Policy Bundles)

Compliance profiles (e.g., `policy_governance_strict.yaml`) are versioned separately:

**Format**: `policy-compliance-{framework}-{version}.yaml`

Examples:
- `policy_governance_strict_v1.0.yaml` (HIPAA compliance, v1.0)
- `policy_governance_strict_v1.1.yaml` (HIPAA compliance, v1.1 — additive enhancements)

**Guarantee**: If an agent was authorized under `strict_v1.0`, it remains authorized under `strict_v1.1` (no removal of capabilities, only additions or clarifications).

## Backward Compatibility Matrix

| Source → Target | Compatible? | Notes |
|---|---|---|
| Spec v1.0 → v1.1 | ✅ Yes (backward compatible) | v1.1 is additive; v1.0 implementations work unchanged |
| Spec v1.1 → v1.0 | ❌ No (spec downgrade) | v1.1 code may use v1.1 features unavailable in v1.0 |
| ASI v1 → v1.x | ✅ Yes (wire-compatible) | New RPC methods available but optional |
| ASI v1.x → v1 | ✅ Yes (wire-compatible) | Older substrate sees only v1 methods |
| ASI v1 → v2 | ❌ No (breaking) | Requires coordinated upgrade |

## Deprecation Policy

When deprecating a feature (e.g., an OTel attribute, a RPC field, a capability):

1. **Announcement Phase** (v1.M): Feature marked `DEPRECATED` in comments/docs. Substrate MUST still support it. Span tags: `deprecated: true`.

2. **Grace Period**: Feature remains functional for minimum 1 year or 2 minor versions, whichever is longer.

3. **Removal Phase** (v2.0 or later): Feature removed. Migration guide published.

**Example Timeline**:
- v1.2.0 (Mar 2025): Attribute `token_budget_percent` marked DEPRECATED, guidance to use `token_budget_consumed` instead
- v1.3.0–v1.5.0 (through Mar 2026): Attribute still functional
- v2.0.0 (Apr 2026, after 1-year grace): Attribute removed from spec

## Stability Guarantees by Surface Area

| Surface | Stability | Version | Additive-Only? | Migration Path |
|---------|-----------|---------|---|---|
| ASI RPC methods | Stable | v1+ | Yes | New methods in v1.1+ |
| ASI message fields | Stable | v1+ | Yes | New fields in v1.1+ |
| OTel attributes (Stable) | Stable | 1.0+ | Yes | New attrs in 1.1+ |
| Capability types | Stable | 1.0+ | Yes | New capabilities in 1.1+ |
| Governance Model semantics | Stable | 1.0+ | Yes | New concepts in 1.1+ |
| Policy YAML schema | Beta | 1.0 | No (yet) | May break in policy_schema_v2 |
| Agent Manifest schema | Beta | 1.0 | No (yet) | May break in manifest_schema_v2 |

## Version Alignment

**Current alignment** (as of 2025-03-15):
- Specification: v1.0.0
- ASI gRPC: proto/usage/v1/asi.proto (stable)
- CRD: usage.io/v1 (stable)
- Agent Manifest schema: v1.0 (beta, may break in v2.0)
- Policy schema: v1.0 (beta, may break in v2.0)

## Communicating Version in Documentation

Every spec document MUST include frontmatter:

```yaml
---
specification_version: "1.0.0"
status: "stable"
last_updated: "2025-03-15"
---
```

Every proto file MUST include version in package declaration:

```protobuf
syntax = "proto3";
package usagix.v1;  // ← Reflects ASI v1 (stable)
```

## Testing and Validation

- [ ] All ASI v1 tests pass on v1.x releases
- [ ] Breaking change attempts fail CI (automated compatibility checks)
- [ ] Deprecation warnings emit in substrate logs when deprecated features are used
- [ ] Migration guides exist for all major version transitions
