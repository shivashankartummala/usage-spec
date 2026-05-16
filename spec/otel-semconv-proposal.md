# OpenTelemetry Semantic Conventions Proposal (USAGIX)

## Scope
Defines telemetry attributes and events for USAGIX substrates.

## Resource Attributes
- `usage.substrate.name`
- `usage.substrate.version`
- `usage.session.id`
- `usage.agent.blueprint`

## Span Attributes
- `usage.syscall.name`
- `usage.syscall.result`
- `usage.policy.decision`
- `usage.policy.bundle.version`
- `usage.token.consumed`
- `usage.token.remaining`
- `usage.memory.tier.target`
- `usage.tool.name`

## Events
- `usage.state.transition`
- `usage.signal.delivered`
- `usage.pageout.completed`
- `usage.tool.denied`
- `usage.quota.exhausted`

## Metric Suggestions
- `usage_syscall_latency_ms`
- `usage_policy_denials_total`
- `usage_tokens_consumed_total`
- `usage_active_sessions`
- `usage_pageout_operations_total`
