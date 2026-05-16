# The Case for an Agent OS: Governance, Citizenship, and Liability

## 1. Context
The transition from deterministic software to autonomous agentic systems changes the control model of enterprise computing. Workloads are no longer pure function execution units; they become persistent decision-making processes with side-effect capabilities.

USAGE treats this shift as an operating-substrate problem, not an SDK problem.

## 2. The Digital Society Model
Autonomous agents are operational actors in enterprise environments. They access shared resources, trigger downstream systems, and interact with other automated processes.

Absent a substrate-level governance contract, this forms an unmanaged digital society with inconsistent policy boundaries.

### 2.1 Framework vs. Operating Substrate
- Frameworks define local reasoning and orchestration behavior.
- USAGE defines system-wide execution law: identity, permission boundaries, mediation paths, and enforcement semantics.

### 2.2 Constitutional Analogy
USAGE acts as a constitutional layer for agent execution:
- identity requirements
- capability constraints
- mediated external actions
- enforceable termination semantics

Operational analogy: granting an autonomous workload direct unmediated infrastructure access is equivalent to permitting access to restricted facilities without credential verification or controlled checkpoints.

## 3. The Liability Vacuum
Human labor models include accountability primitives (disciplinary, legal, contractual). Autonomous processes do not possess intrinsic legal agency or self-governing liability behavior.

When an unmanaged agent causes data disclosure, policy violation, or financial runaway behavior, enterprise liability is immediate and complete.

USAGE resolves this by moving accountability from the cognitive layer into the substrate layer.

```text
[Traditional Software] --> Runs with broad host/developer permissions
[USAGE-Governed Agent] --> Enclosed in an auditable liability boundary
```

## 4. Structural Liability Controls
USAGE mandates three substrate-level controls:

### 4.1 Immutable Attestation
Every mediated external action is bound to workload identity and policy decision metadata, producing a cryptographically verifiable chain of evidence.

### 4.2 Hard Budget Caps
Token and cost budgets are enforced at runtime control points. Unbounded recursive or degenerative loops cannot consume unlimited financial resources.

### 4.3 Sandboxed Isolation and Kill Semantics
Actions outside declared capability boundaries are denied. Persistent or critical violations terminate execution (`SIG_AGENT_TERMINATE`).

## 5. Design Mandate
Enterprise automation cannot rely on probabilistic behavioral compliance from language models. Reliable operation requires deterministic governance boundaries.

USAGE provides the rule set. Myelin-AX provides the enforcement substrate.
