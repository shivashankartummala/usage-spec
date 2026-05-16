# USAGE Specification Governance

## Overview

The USAGE specification is governed by a Technical Steering Committee (TSC) that ensures quality, 
consistency, and community input for all normative and architectural changes.

## Roles

### Maintainers

Maintainers review PRs, manage releases, and steward the day-to-day specification.

**Responsibilities**:
- Review and merge PRs
- Respond to issues within 5 business days
- Propose new features and improvements
- Cut releases (following semantic versioning)

**Nomination**: Active contributors with 10+ merged PRs and 1+ year involvement

### Technical Steering Committee (TSC)

The TSC ratifies major decisions (MAJOR version changes, breaking API changes, governance changes).

**Composition**: 5-7 members drawn from:
- 2-3 substrate implementers (maintainers of compliant substrates)
- 1-2 spec maintainers
- 1-2 enterprise adopters / security experts
- 1 policy expert (for governance model changes)

**Responsibilities**:
- Ratify all normative spec changes (RFC process)
- Approve breaking changes with consensus
- Review and approve governance model updates
- Resolve appeals on controversial decisions

## Decision-Making Process

### Minor Changes (MINOR/PATCH)

**Examples**: New OTel attributes, new capability types, documentation clarifications, examples

**Process**:
1. File issue or PR with description
2. Maintainers review (GitHub discussions encouraged)
3. **No explicit vote required** — approval by 1-2 maintainers + no TSC objection within 3 days
4. Merge

**Timeline**: 3-7 days

### Major Changes (MAJOR version, breaking APIs)

**Examples**: Removing an RPC method, changing governance semantics, introducing new trust domains

**Process**:
1. File RFC (Request for Comments) in `spec/rfc-*.md`
2. RFC review period: 2 weeks minimum
3. TSC discussion and vote (simple majority = 4 votes yes out of 7 needed)
4. Consensus-building (address objections if any)
5. Approve or reject

**Timeline**: 3-5 weeks

### Security Issues

Report security concerns to security@usage-spec.io.

## Conflict Resolution and Appeals

Disagreement on a decision? Follow this path:

1. **Discussion Phase**: Post concern in GitHub issue, tag maintainers
2. **Escalation**: If unresolved after 1 week, escalate to TSC
3. **TSC Review**: TSC deliberates and provides decision rationale
4. **Appeal**: If still unsatisfied, appeal to CNCF mediator (for CNCF-graduated projects)

## Voting Rules

All votes on normative changes require:
- **Simple majority** (>50%) of TSC members present
- **Minimum quorum**: 4 of 7 TSC members
- **Discussion period**: 1 week minimum before vote
- **Record**: All votes and rationale logged in spec/governance-decisions.md

## Code of Conduct

All participants agree to the CNCF Code of Conduct (see `CODE_OF_CONDUCT.md`).

Conduct violations reported to conduct@usage-spec.io.

## Release Cycle

- **Minor/Patch releases**: As-needed (when features or fixes are ready)
- **Major releases**: Planned annually (every ~12 months)
- **Release notes**: Mandatory (list all normative changes, deprecations, breaking changes)
- **Compatibility notes**: Every release MUST document compatibility with prior major version

## Contributing

For contribution guidelines, see the GitHub CONTRIBUTING.md (TBD).
