# USAGE Core Architecture Specification

## 1. Scope
USAGE standardizes the contract between autonomous cognitive processes and execution substrates. It is substrate-agnostic and does not prescribe model providers, prompting frameworks, or orchestration SDKs.

## 2. Normative Language
The key words MUST, MUST NOT, SHOULD, SHOULD NOT, and MAY are to be interpreted as described in RFC 2119.

## 3. Layered Model
- Layer 4 (Cognitive Application): intent formation, prompt orchestration, tool intent emission.
- Layer 3 (Governance and Aspect): policy checks, budget accounting, redaction, trace emission.
- Layer 2 (Runtime and Execution): session lifecycle, signal handling, checkpoint/resume.
- Layer 1 (SAL): substrate adaptation for compute, network, storage, and isolation primitives.

## 4. Trust Boundaries
- The cognitive container is untrusted by default.
- Governance and policy enforcement MUST execute outside the cognitive trust boundary.
- External side effects MUST be mediated through USAGE system calls.

## 5. Portability Contract
A USAGE-compliant cognitive workload MUST execute against any substrate implementing:
- ASI gRPC service behavior
- Lifecycle semantics
- Error model and result determinism constraints
- Minimum observability semantics

## 6. Determinism Requirements
- Lifecycle transitions MUST be explicit and auditable.
- Replayed checkpoints SHOULD reproduce equivalent policy and signal outcomes under identical policy snapshots and tool responses.

## 7. Compatibility
- Wire compatibility follows protobuf backward-compatible evolution.
- Behavioral compatibility requires preserving syscall semantics unless a major version bump is declared.
