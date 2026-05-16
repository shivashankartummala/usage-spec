# Memory Model

## Tiers
- L1 Hot Context: model-visible active window.
- L2 Warm Semantic Cache: low-latency retrieved context.
- L3 Cold Persistent Store: long-term durable memory.

## Page Semantics
- Page Unit: opaque context segment with policy labels.
- Page Metadata: `{page_id, hash, sensitivity, ttl, lineage}`.
- `UsageMemPageOut` demotes pages L1->L2/L3.

## Invariants
- Sensitive pages MUST carry policy labels across tiers.
- Page references MUST be integrity-verifiable.
- Expired pages MUST be unavailable to retrieval unless retention exception applies.

## Memory Wall Handling
- Trigger demotion by token pressure threshold.
- Maintain retrieval quality via semantic compaction.
- Avoid unbounded prompt growth by bounded L1 resident set.
