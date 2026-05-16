# Multi-Agent Coordination Model

## Process Tree
USAGIX models agent orchestration as a supervision tree.
- Parent sessions own child sessions.
- Ownership includes budget partitioning and termination semantics.

## Spawn Semantics
- Parent MAY allocate sub-budget to child at `UsagixSpawn`.
- Child MUST inherit policy floor from parent; narrowing is allowed, widening is denied.

## Failure Semantics
- Child failure can be `isolated` or `escalating` based on parent policy.
- Cascading termination behavior is explicit (`NONE`, `CHILDREN`, `SUBTREE`).

## Deadlock and Loop Control
- Maximum recursion depth MUST be bounded.
- Repeated identical tool-call signatures SHOULD trigger circuit-breaker policy.
