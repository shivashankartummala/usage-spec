# USAGE Core Architecture Specification

## 1. Scope
USAGE standardizes the contract between autonomous cognitive processes and execution substrates. It is substrate-agnostic and does not prescribe model providers, prompting frameworks, or orchestration SDKs.

## 2. Definitive Scope Trigger (Operational Binary)
USAGE classification is binary and programmatic. Behavioral, philosophical, or framework-based definitions of agency are out of scope for classification decisions.

A workload is unconditionally classified as an AI Agent under USAGE when both conditions are true:
- Inference Core Invocation: the workload invokes one or more foundation model or LLM calls to determine state or control flow.
- Peripheral Access Capabilities: the workload can invoke external tools, databases, web APIs, or native host system calls.

Any script, binary, service, job, or active execution thread meeting both conditions is in-scope for USAGE runtime enforcement.

## 3. Absolute Boundary Condition
No exception exists for code size, framework usage, or runtime longevity.

Rule of inclusion:
- A minimal script that calls an LLM endpoint and executes shell, filesystem, or API actions is semantically equivalent (for governance scope) to a multi-agent orchestration tree.

Rule of boundary enforcement:
- Upon meeting the scope trigger, the workload MUST be enclosed by the USAGE runtime boundary.
- The workload MUST relinquish direct external network/filesystem side-effect pathways except substrate-mediated pathways.
- The workload MUST authenticate with a distinct cryptographically verifiable workload identity.
- The workload MUST route external actions through the substrate tool-proxy path.
- The workload MUST submit to real-time token accounting and quota enforcement.

Non-compliance at substrate enforcement points MUST result in terminal execution signaling (for example `SIG_AGENT_TERMINATE`).

## 4. Normative Language
The key words MUST, MUST NOT, SHOULD, SHOULD NOT, and MAY are to be interpreted as described in RFC 2119.

## 5. Layered Model
- Layer 4 (Cognitive Application): intent formation, prompt orchestration, tool intent emission.
- Layer 3 (Governance and Aspect): policy checks, budget accounting, redaction, trace emission.
- Layer 2 (Runtime and Execution): session lifecycle, signal handling, checkpoint/resume.
- Layer 1 (SAL): substrate adaptation for compute, network, storage, and isolation primitives.

## 6. Trust Boundaries
- The cognitive container is untrusted by default.
- Governance and policy enforcement MUST execute outside the cognitive trust boundary.
- External side effects MUST be mediated through USAGE system calls.

## 7. Portability Contract
A USAGE-compliant cognitive workload MUST execute against any substrate implementing:
- ASI gRPC service behavior
- Lifecycle semantics
- Error model and result determinism constraints
- Minimum observability semantics

## 8. Determinism Requirements
- Lifecycle transitions MUST be explicit and auditable.
- Replayed checkpoints SHOULD reproduce equivalent policy and signal outcomes under identical policy snapshots and tool responses.

## 9. Compatibility
- Wire compatibility follows protobuf backward-compatible evolution.
- Behavioral compatibility requires preserving syscall semantics unless a major version bump is declared.
