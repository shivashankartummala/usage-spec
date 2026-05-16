# RFC-001: Process Lifecycle and State Machine

**RFC Number:** RFC-001  
**Title:** Process Lifecycle and State Machine  
**Status:** APPROVED  
**Last Updated:** 2026-05-15  
**Author(s):** USAGE Specification Authors  

---

## Executive Summary

This RFC formally specifies the state machine that governs the lifecycle of a USAGE-compliant agent process. The specification defines five fundamental engine phases (Pending, Active, Thinking, Paused, Terminated), the legal state transitions between them, the semantic guarantees and invariants at each state, and the mechanisms by which the substrate enforces state machine properties.

This specification ensures that all USAGE-compliant substrates maintain consistent, reproducible, and formally verifiable agent process semantics.

---

## Terminology

- **Agent Process**: An autonomous reasoning engine instantiated by `UsageSpawn()`. The agent executes within the bounds defined by the USAGE ASI.
- **Substrate**: The execution environment hosting the agent process. The substrate enforces state machine invariants and manages transitions.
- **Session**: A unique execution context for an agent process, identified by a `session_id` returned from `UsageSpawn()`.
- **State Transition**: A change in the agent's state. Only legal transitions (defined in this RFC) are permitted.
- **Context State**: The full serializable state of the agent's reasoning, including inference history, memory artifacts, and execution metadata.
- **Token Budget**: The maximum number of tokens the agent is allowed to consume, specified in `SpawnRequest.max_tokens_quota`.

---

## State Machine Definition

### The Five States

The USAGE agent lifecycle is governed by a finite state machine with exactly five states:

```
┌─────────────────────────────────────────────────────────────────────┐
│                     USAGE Agent State Machine                        │
└─────────────────────────────────────────────────────────────────────┘

                         ┌─────────────┐
                         │   PENDING   │
                         └──────┬──────┘
                                │
                         (identity boundary
                          established)
                                │
                                ▼
                         ┌─────────────┐
                         │   ACTIVE    │
                         └──────┬──────┘
                                │
                         (begin reasoning)
                                │
                                ▼
                         ┌─────────────┐     SIG_AGENT_PAUSE
                         │  THINKING   │◄────────────────────┐
                         └──────┬──────┘                      │
                                │                            │
                         (yield or                     ┌─────────────┐
                          complete)                    │   PAUSED    │
                                │                      └─────┬───────┘
                                ▼                            │
        ┌──────────────────────────────────────────────────────┘
        │
        │ (SIG_AGENT_TERMINATE or timeout)
        │
        ▼
   ┌─────────────┐
   │ TERMINATED  │
   └─────────────┘
```

#### State 1: PENDING

**Entry Condition:** `UsageSpawn()` returns successfully.

**Invariants:**
- The agent process has been initialized but has not yet established an identity boundary.
- No cognitive work (inference, reasoning, planning) occurs in this state.
- The substrate must not deliver `UsageYield()` requests from the agent; any such requests are dropped or cause an error.
- The agent has not yet consumed tokens.
- All capabilities and resource quotas are in place but unenforced.

**Valid Transitions:**
- → ACTIVE: The substrate verifies the agent's identity (via `SystemPrompt`, `ModelId`, etc.) and activates the identity boundary. This is a substrate-initiated transition, not agent-driven.
- → TERMINATED: A substrate-level error (e.g., invalid spawn configuration) causes immediate termination.

**Semantic Behavior:**
The substrate prepares the agent's execution environment: allocates memory, sets up logging, and acquires any necessary resources. The substrate should emit an event or notification indicating the agent has entered PENDING state and is awaiting identity activation.

---

#### State 2: ACTIVE

**Entry Condition:** Substrate successfully verifies the agent's identity and activates the identity boundary.

**Invariants:**
- The agent has a well-defined identity context (model, system prompt, initial memory state).
- The agent is ready to begin reasoning but has not yet started inference.
- No cognitive operations (inference, tool invocations) have occurred.
- Token budget tracking is initialized; tokens consumed counter starts at zero.
- Capabilities are active and will be enforced at the `UsageCallTool` boundary.

**Valid Transitions:**
- → THINKING: The substrate directs the agent to begin reasoning, triggering the first inference cycle.
- → TERMINATED: Substrate sends `SIG_AGENT_TERMINATE`, or a fatal initialization error occurs.

**Semantic Behavior:**
The substrate may perform identity verification (cryptographic signatures, capability checks, etc.) in this state. Once verification completes, the substrate transitions the agent to THINKING and begins model inference.

---

#### State 3: THINKING

**Entry Condition:** Substrate has activated identity and directs the agent to begin inference.

**Invariants:**
- The agent is actively engaged in inference, planning, or reasoning.
- The model is consuming tokens; token budget tracking is active.
- The agent may issue `UsageCallTool()` requests; the substrate gates each request against the agent's capability set.
- The agent may issue `UsageMemPageOut()` requests to manage its memory tiers.
- The agent does not issue `UsageYield()` while in the THINKING state, unless explicitly transitioning to PAUSED.
- The substrate monitors token consumption against the quota; if the agent exceeds its budget, the substrate sends `SIG_AGENT_TERMINATE`.

**Valid Transitions:**
- → PAUSED: The agent calls `UsageYield()`, serializing its state and yielding control. The agent transitions to PAUSED and awaits substrate action.
- → THINKING: The agent continues reasoning without yielding (looping within THINKING state).
- → TERMINATED: `SIG_AGENT_TERMINATE` is received, token budget is exceeded, or a timeout occurs.

**Semantic Behavior:**
This is the primary productive state. The agent performs inference in a tight loop:

1. Execute model forward pass (inference).
2. Update reasoning state.
3. Optionally invoke tools via `UsageCallTool()`.
4. Optionally page memory via `UsageMemPageOut()`.
5. Check for signals; if `SIG_AGENT_PAUSE` is received, prepare to transition to PAUSED.
6. Optionally yield via `UsageYield()` for checkpointing or memory management.
7. Repeat until yielding, signal termination, or timeout.

If token budget is exceeded during THINKING, the substrate immediately transitions to TERMINATED and delivers `SIG_AGENT_TERMINATE`.

---

#### State 4: PAUSED

**Entry Condition:** Agent calls `UsageYield()` while in THINKING, or substrate sends `SIG_AGENT_PAUSE`.

**Invariants:**
- The agent's state has been serialized and stored by the substrate (via the context_state_blob in `YieldRequest`).
- The agent process is suspended and not consuming computational resources.
- Token budget tracking is frozen at the point of yield.
- The substrate may inspect, modify, or persist the serialized state for governance purposes.
- No further token consumption occurs until resumption.
- Memory tier transitions triggered by `UsageMemPageOut()` requests issued during THINKING have completed; the agent awaits their results.

**Valid Transitions:**
- → THINKING: Substrate resumes the agent, restoring its serialized state. The agent re-enters THINKING and continues reasoning from the checkpoint.
- → TERMINATED: Substrate sends `SIG_AGENT_TERMINATE`, or a timeout configured at spawn time expires.
- → ACTIVE: Substrate explicitly resets the agent (rare; used for identity boundary reset or error recovery).

**Semantic Behavior:**
Upon entering PAUSED, the substrate:

1. Stores the serialized context_state_blob in durable storage (via `checkpoint_id` in `YieldResponse`).
2. May perform governance evaluations (quota checks, policy compliance audits, security reviews).
3. May trigger memory tier management (flushing L1 to L2, compacting L2 to L3, etc.).
4. Awaits an external signal (e.g., tool result availability, manual resume, timeout) to re-enter THINKING.

The agent may remain in PAUSED for an indefinite duration. The substrate may evict the agent's memory or move it to cold storage while PAUSED.

---

#### State 5: TERMINATED

**Entry Condition:** Any of the following:
- `SIG_AGENT_TERMINATE` is delivered (and acted upon).
- Token budget is exceeded.
- Session timeout expires.
- Substrate encounters a fatal error.
- Agent completes all work and explicitly requests termination.

**Invariants:**
- The agent process is fully shut down; all resources are released.
- No further RPCs are accepted on this `session_id`.
- The final state snapshot (if available) is archived for audit and replay.
- Token consumption is finalized; the session's accounting is closed.
- All tools are forcibly released; pending `UsageCallTool()` operations are aborted.

**Valid Transitions:**
- → None (absorbing state). TERMINATED is a final state. No further transitions are possible.

**Semantic Behavior:**
Upon entering TERMINATED, the substrate:

1. Forcibly exits the model inference loop.
2. Releases all computational resources (GPU, memory, network connections).
3. Archives the final context state (if available) for audit, logging, and future debugging.
4. Closes the session in the substrate's session tracking system.
5. Finalizes billing/quota accounting.
6. Emits a termination event to observability systems.

---

## State Transition Rules

### Legal Transitions

The following table defines the legal state transitions:

| From State | Signal/Event | To State | Conditions |
|------------|-------------|----------|-----------|
| PENDING | Identity verified | ACTIVE | Substrate successfully validates agent identity |
| PENDING | Fatal error | TERMINATED | Invalid spawn config, auth failure, or resource exhaustion |
| ACTIVE | Begin reasoning | THINKING | Substrate directs model inference to start |
| ACTIVE | SIG_AGENT_TERMINATE | TERMINATED | Substrate or external source sends terminate signal |
| THINKING | UsageYield() | PAUSED | Agent serializes state and yields control |
| THINKING | Continue looping | THINKING | Agent continues inference without yielding |
| THINKING | SIG_AGENT_PAUSE | PAUSED | Substrate sends pause signal; agent transitions after current op completes |
| THINKING | Token quota exceeded | TERMINATED | Substrate enforces budget; agent exceeds max_tokens_quota |
| THINKING | SIG_AGENT_TERMINATE | TERMINATED | Substrate sends terminate signal |
| THINKING | Timeout | TERMINATED | Session exceeds sessionTimeoutSeconds |
| PAUSED | Resume signal | THINKING | Substrate resumes agent from checkpoint; state is restored |
| PAUSED | SIG_AGENT_TERMINATE | TERMINATED | Substrate sends terminate signal |
| PAUSED | Timeout | TERMINATED | Agent remains paused beyond a substrate-configured timeout |
| PAUSED | Reset signal | ACTIVE | Substrate explicitly resets identity (rare; error recovery) |

### Illegal Transitions

The following transitions are **forbidden** and must trigger a substrate-level error:

1. **Pending → Thinking**: Illegal; agent must establish identity first (PENDING → ACTIVE → THINKING).
2. **Active → Paused**: Illegal; agent must transition through THINKING (ACTIVE → THINKING → PAUSED).
3. **Paused → Active**: Illegal; resumed agents enter THINKING, not ACTIVE.
4. **Any → Pending**: Illegal; PENDING is only reachable at spawn time.
5. **Terminated → Any**: Illegal; TERMINATED is absorbing; no transitions out.
6. **Active → Active**: Illegal; no self-loops except THINKING → THINKING.

A substrate implementation that permits any illegal transition is in violation of this specification.

---

## Memory Serialization During UsageYield

When an agent in the THINKING state calls `UsageYield()`, the following steps occur:

### Step 1: Context Serialization
The agent encodes its full reasoning state into a serializable blob:

- **Inference History**: All previous model outputs, token embeddings, and logits.
- **Memory Artifacts**: Notes, summaries, embeddings stored in L1 context window.
- **Execution Metadata**: Current token consumption counter, tool invocation history, memory page-out references.
- **Capability Metadata**: Current capability grants, tool invocation counts, policy compliance state.

The serialized blob is opaque to the substrate; the agent provides the blob in `YieldRequest.context_state_blob`.

### Step 2: Substrate Acknowledgment
The substrate receives the `YieldRequest`, acknowledges successful storage via `YieldResponse`, and assigns a `checkpoint_id` for future reference.

### Step 3: Token Budget Preservation
The substrate records `YieldRequest.tokens_consumed`. When the agent is resumed, the substrate re-initializes token tracking with the saved count, ensuring the agent's remaining budget is accurate:

```
remaining_budget = initial_quota - tokens_consumed_at_yield
```

### Step 4: Memory Tier Management
While the agent is PAUSED, the substrate may automatically manage memory tiers:

- **L1 Eviction**: The agent's L1 context window is flushed to L2 cache or L3 storage to free computational resources.
- **L2/L3 Compaction**: The substrate may compress or deduplicate context artifacts stored in L2/L3.
- **L2/L3 Garbage Collection**: Old, unreferenced state may be discarded according to the configured L2CachePolicy.

The substrate must preserve the `checkpoint_id` and the mapping to physical storage locations so that resumption is possible.

### Step 5: Resumption
When the substrate resumes the agent (via an external signal or timeout), it:

1. Restores the serialized context from the stored blob.
2. Re-initializes L1 context window with the checkpointed state.
3. Re-initializes token tracking with the saved `tokens_consumed` counter.
4. Transitions the agent from PAUSED to THINKING.
5. Resumes model inference from the checkpoint.

---

## Invariant Enforcement

### Invariant 1: No Silent State Violations
Any attempt to violate the state machine (e.g., Pending → Thinking without Active) must be detected and rejected at the substrate level. The substrate must not silently skip states or coerce illegal transitions.

### Invariant 2: Token Budget Monotonicity
Once a token is consumed, it cannot be "uncounted." Token consumption is monotonically increasing:

```
tokens_consumed(t1) <= tokens_consumed(t2) for t1 < t2
```

If resumption occurs, token counts from previous checkpoints are preserved.

### Invariant 3: State Snapshot Consistency
If an agent yields via `UsageYield()`, the serialized state blob must be completely consistent and complete. The substrate must not accept partial or corrupted snapshots. Resumption from a checkpoint must restore the agent to an identical cognitive state.

### Invariant 4: Capability Enforcement at Tool Boundary
Every `UsageCallTool()` request (issued while in THINKING state) must be validated against the agent's granted capabilities. If a tool is not in the `allowedTools` list, the substrate must reject the request and send `ToolResponse.execution_success = false` with an appropriate error message. The agent must not be able to invoke unauthorized tools.

### Invariant 5: Signal Atomicity
When a signal is delivered (SIG_AGENT_TERMINATE, SIG_AGENT_PAUSE, etc.), the state transition must be atomic. The agent must not observe a partial state change. Either the signal is fully processed and the state transition completes, or the signal is rejected and state is unchanged.

### Invariant 6: No Concurrent State
An agent session identified by a `session_id` may only have one active state at any given time. Concurrent execution or multi-threaded state mutations are not permitted. The substrate must serialize all operations on a session's state machine.

---

## Error Handling and Recovery

### Invalid Transition Attempt
If an agent (or external entity) attempts an illegal transition, the substrate must:

1. Reject the transition request.
2. Emit an error response with a clear error message identifying the illegal transition (e.g., "Illegal transition PENDING → THINKING").
3. Leave the agent's state unchanged.
4. Log the violation for audit purposes.

**Recommended Behavior:** Repeated illegal transition attempts may indicate a misconfigured or malicious agent. The substrate may escalate to `SIG_AGENT_TERMINATE` if violations persist.

### State Corruption Recovery
If the agent's serialized state is corrupted or unrecoverable:

1. The substrate must detect the corruption during deserialization (e.g., via checksums or signature verification).
2. The substrate must send `SIG_AGENT_TERMINATE` and transition to TERMINATED.
3. The substrate must log the corruption event and archive the corrupted state for forensics.

The agent is **not** resumed from a corrupted checkpoint.

### Timeout Handling
If an agent remains in PAUSED state beyond the substrate's configured timeout:

1. The substrate sends `SIG_AGENT_TERMINATE`.
2. The agent transitions to TERMINATED.
3. The substrate may archive the final state for later replay or debugging.

Timeouts are configurable per-agent via `SpawnRequest` (or via the agent manifest's `sessionTimeoutSeconds`).

---

## Formal Semantics

### State Transition Function

Let `S` be the set of all valid states: `S = {PENDING, ACTIVE, THINKING, PAUSED, TERMINATED}`.

Let `Σ` be the set of all signals and events: `Σ = {SpawnOK, IdentityVerified, BeginReasoning, UsageYield, SIG_AGENT_TERMINATE, SIG_AGENT_PAUSE, TokenQuotaExceeded, SessionTimeout, SignalResume}`.

The state transition function `δ: S × Σ → S` is defined by the transition table above. Undefined transitions (not listed in the legal transitions table) are **rejected** and leave state unchanged.

### Token Budget Preservation Predicate

For any sequence of states `[s₀, s₁, ..., sₙ]` where state transitions are legal:

Let `budget_initial = SpawnRequest.max_tokens_quota`.

For all i, j where i < j:
```
consumed(sᵢ) ≤ consumed(sⱼ) ≤ budget_initial
```

If j is a PAUSED state and i is a THINKING state immediately preceding j (via UsageYield), then:
```
consumed(sⱼ) = YieldRequest.tokens_consumed
```

When resuming from PAUSED → THINKING, the new budget is:
```
new_budget = budget_initial - consumed(paused_state)
```

---

## Implementation Guidance for Substrates

### Checkpoint Management
Substrates should implement a robust checkpoint store:

- **Durability:** Checkpoints must be persisted to durable storage (disk, database, cloud blob store).
- **Retrieval:** Checkpoints must be retrievable by `checkpoint_id`.
- **Garbage Collection:** Checkpoints for terminated sessions may be archived or deleted according to retention policies.
- **Integrity:** Checksums or cryptographic signatures should verify checkpoint integrity before resumption.

### Signal Delivery
Substrates should implement signal delivery as follows:

- **Signal Queue:** Maintain a queue of pending signals for each session.
- **Atomic Processing:** Process one signal at a time for a given session; signals are serialized, not concurrent.
- **Acknowledgment:** Emit `SignalResponse` only after the state transition has completed.

### Token Budget Enforcement
Substrates should enforce token budgets via:

- **Consumption Tracking:** Track tokens consumed after each inference step.
- **Quota Checks:** Before each inference step, verify that remaining budget > 0.
- **Quota Overrun:** If an agent exceeds its budget, immediately send `SIG_AGENT_TERMINATE` and transition to TERMINATED.

### Logging and Observability
Substrates should log:

- **State Transitions:** Every transition (timestamp, old state, new state, event).
- **Illegal Transitions:** Any rejected transitions (with error details).
- **Token Consumption:** Cumulative token consumption at each checkpoint.
- **Signal Delivery:** All signal deliveries and responses.

---

## Compliance Checklist

A substrate is compliant with this RFC if it:

- [ ] Implements all five states (PENDING, ACTIVE, THINKING, PAUSED, TERMINATED).
- [ ] Enforces legal transitions; rejects illegal transitions.
- [ ] Initializes token budget tracking at spawn time.
- [ ] Preserves token budgets across checkpoints (UsageYield).
- [ ] Enforces token quota limits; terminates agents that exceed budget.
- [ ] Serializes agent context during UsageYield; assigns checkpoint_id.
- [ ] Restores agent context during resumption; preserves token counts.
- [ ] Enforces capability gating at the UsageCallTool boundary.
- [ ] Delivers signals atomically and logs all transitions.
- [ ] Detects and rejects illegal transition attempts.
- [ ] Recovers from serialized state corruption (via termination).
- [ ] Handles timeouts appropriately (via SIG_AGENT_TERMINATE).
- [ ] Maintains audit logs of all state transitions and signals.

---

## Future Extensions

Future RFCs may extend the state machine with:

- **Suspended State:** A long-lived pause state with automatic garbage collection.
- **Migration State:** A state for migrating agent contexts between substrate instances.
- **Checkpointing Strategies:** Multiple checkpoint policies (incremental, differential, etc.).
- **Multi-Agent Coordination:** States for agent-to-agent handoff and coordination.

All extensions must maintain backward compatibility with USAGE v1.0 state machine semantics.

---

## References

- USAGE Core Specification (`spec/usage-core.md`)
- ASI System Calls Specification (`spec/asi-system-calls.md`)
- Memory Model Specification (`spec/memory-model.md`)
- OCI Runtime Specification (inspired state machine design)

---

## Approval

**Status:** APPROVED  
**Approved By:** [USAGE Specification Committee]  
**Approval Date:** 2026-05-15  
**Implementation Deadline:** Substrates must be compliant by 2026-12-01 (v1.0 release).
