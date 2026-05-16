# Contributing to USAGIX

Thank you for your interest in contributing to the USAGIX specification! This document provides guidelines for participating in the project.

## Code of Conduct

This project adheres to the [CNCF Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold this code.

---

## Getting Started

1. **Read the spec**: Start with [README.md](README.md) and [spec/usage-core.md](spec/usage-core.md)
2. **Understand governance**: Read [GOVERNANCE.md](GOVERNANCE.md) for decision-making process
3. **Check existing discussions**: Look at open issues and PRs before starting new work
4. **Join the conversation**: Ask questions in GitHub issues or discussions

---

## How to Contribute

### Bug Reports

Found a problem in the specification? Please file an issue with:

- **Title**: Clear, concise description of the problem
- **Description**: What is the issue and where in the spec?
- **Impact**: How does this affect implementations?
- **Suggested fix** (optional): If you have an idea for a fix

**Example**:
```
Title: RFC 2119 keyword "SHOULD" under-specified in §3.2 of security-model.md

Description: Section 3.2 states "Audit logs SHOULD be immutable" but doesn't 
specify the mechanism by which immutability is enforced or validated.

Impact: Implementers may use weak immutability guarantees (e.g., file permissions 
instead of append-only storage), creating compliance loopholes.

Suggested fix: Change to "MUST" and specify append-only storage requirement, 
or add clarification on acceptable immutability mechanisms.
```

### Feature Requests & RFCs

Want to propose a new feature or change to the specification?

**For minor features** (MINOR version bump):
1. Open a GitHub issue describing the feature
2. Wait for feedback from maintainers (3-5 days)
3. If approved, submit a PR with specification changes

**For major features** (MAJOR version bump or breaking changes):
1. Open a GitHub issue with "RFC" label
2. Create a formal RFC in [RFC/](RFC/) directory (see RFC template below)
3. RFC review period: 2 weeks minimum
4. Submit to TSC for voting
5. Once approved, submit spec changes as PR

**RFC Template** (`RFC/rfc-NNN-short-title.md`):

```markdown
# RFC NNN: Short Title

## Summary
One paragraph summary of the proposal.

## Motivation
Why is this change necessary? What problem does it solve?

## Specification
Detailed technical specification of the proposed change.

## Backward Compatibility
Impact on existing implementations. Can v1.0.0 code run on v1.1.0?

## Security Considerations
Any security implications of the proposed change?

## Implementation Guide
How would a substrate implement this change?

## Alternatives Considered
What other approaches were considered and why were they rejected?

## Open Questions
Unresolved questions for community feedback.
```

### Documentation

Improvements to specification documentation are always welcome:

- Clarify ambiguous language
- Add examples
- Fix typos and formatting
- Improve accessibility

Simply submit a PR with your improvements.

### Specification Changes

Proposing changes to the USAGIX specification itself?

1. **Understand the scope**: Is this a clarification (PATCH), addition (MINOR), or breaking change (MAJOR)?
2. **Get feedback**: Open an issue first to discuss the change
3. **Create RFC** (if MAJOR): Propose in RFC if it's a major change
4. **Submit PR**: Link to the issue/RFC discussion
5. **Review process**: Maintainers will review; TSC votes on major changes

**Specification Change Checklist**:
- [ ] RFC opened and reviewed (if MAJOR)
- [ ] All affected spec files updated
- [ ] Versioning policy updated (if new surface area)
- [ ] Examples added (if new feature)
- [ ] Backward compatibility preserved (or documented as breaking)
- [ ] RFC 2119 keywords correct and binding
- [ ] Tests/conformance updated (if applicable)

### Implementation & Reference Code

Contributing a reference implementation or improving Myelin-AX?

See [reference/myelin-ax/CONTRIBUTING.md](reference/myelin-ax/CONTRIBUTING.md) (TBD) for implementation-specific guidelines.

---

## PR Workflow

### Before You Submit a PR

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/usage-spec.git
   cd usage-spec
   git checkout -b your-feature-branch
   ```

2. **Make your changes**
   - Edit spec files in `/spec/` or other relevant directories
   - Ensure changes comply with RFC 2119 normative language binding
   - Add examples if introducing new concepts

3. **Sign your commits**
   ```bash
   git commit -s -m "Your commit message"
   ```
   This signs the Developer Certificate of Origin (DCO). See [LICENSING.md](LICENSING.md) for details.

4. **Test your changes**
   ```bash
   # Lint specification files
   ./tools/lint.sh
   
   # Check protocol buffers
   ./tools/proto-check.sh
   
   # Validate schema
   ./tools/schema-check.sh
   ```

5. **Push and create PR**
   ```bash
   git push origin your-feature-branch
   ```
   Then create a PR on GitHub.

### PR Template

When creating a PR, please use this template:

```markdown
## Description
Brief description of the change.

## Related Issue/RFC
Links to related GitHub issues or RFCs (e.g., "Fixes #123" or "Related to RFC-NNN").

## Changes Made
- Change 1
- Change 2
- Change 3

## Type of Change
- [ ] Bug fix (non-breaking)
- [ ] New feature (non-breaking)
- [ ] Breaking change (requires MAJOR version)
- [ ] Documentation update
- [ ] RFC implementation

## Backward Compatibility
- [ ] Backward compatible (v1.0.0 code works on v1.1.0)
- [ ] Breaking change (requires MAJOR version or deprecation window)

## Testing
How was this change tested? (link to conformance tests, etc.)

## Reviewer Checklist
- [ ] RFC 2119 keywords correct
- [ ] Versioning policy followed
- [ ] Examples added (if new feature)
- [ ] Security implications considered
- [ ] Documentation updated
```

### PR Review Process

1. **Automated Checks**: CI runs lint, schema validation, proto checks
2. **Maintainer Review**: 1-2 maintainers review for clarity and correctness
3. **TSC Review** (if MAJOR): TSC votes on breaking changes
4. **Approval**: PR approved when 1+ maintainers sign off and no TSC objections (3 days)
5. **Merge**: PR merged by maintainer

**Review Timeline**:
- PATCH/MINOR: 3-7 days
- MAJOR/RFC: 3-5 weeks (includes RFC review)

---

## Licensing & IP

By contributing to USAGIX, you agree to:

1. **License Your Work**: Contributions are licensed under Apache 2.0 (see [LICENSING.md](LICENSING.md))
2. **Sign DCO**: All commits must be signed with `git commit -s` (Developer Certificate of Origin)
3. **Grant Patent Rights**: You grant a royalty-free, perpetual license under your patents that read on the specification

See [LICENSING.md](LICENSING.md) for full details.

---

## Communication Channels

- **GitHub Issues**: Questions, bugs, feature requests
- **GitHub Discussions**: General conversation and ideas
- **Email**: 
  - governance@usage-spec.io (governance questions)
  - security@usage-spec.io (security issues)
  - adopters@usage-spec.io (adoption partnerships)

---

## Recognition

Contributors to USAGIX are recognized in:
1. **Commit history**: All PR merges are in git history
2. **Release notes**: Major contributors listed in release announcements
3. **Contributors page**: TBD (contributors.md or GitHub contributors)

---

## Getting Help

- **Spec questions**: Open a GitHub discussion or issue
- **Implementation questions**: See [reference/myelin-ax/](reference/myelin-ax/) or ask in issues
- **Process questions**: See [GOVERNANCE.md](GOVERNANCE.md)
- **Quick chat**: Join CNCF Slack #usage channel (TBD)

---

## Code of Conduct Violations

If you experience or witness a violation of the Code of Conduct, please report it to:

conduct@usage-spec.io

All reports are treated confidentially and investigated promptly.

---

**Thank you for contributing to making USAGIX a better specification!**
