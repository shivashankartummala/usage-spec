# Scheduling Model

## Problem
CPU/RAM scheduling is insufficient for cognitive workloads that are quota-bound by tokens, context windows, and provider rate limits.

## Scheduling Dimensions
- Compute: CPU, memory, accelerator
- Cognitive: token budget, token rate, context pressure
- External: provider QPS/TPM, tool concurrency

## Policies
- Token Budget Class: `small`, `medium`, `large` with hard upper bounds.
- Context Pressure Index (CPI): ratio of L1 occupancy to configured max.
- Provider Backpressure State: normal, degraded, blocked.

## Decisions
- Admit when quotas and policy permit.
- Preempt/terminate when token budget exhausted.
- Force yield when CPI exceeds threshold.
- Defer tool calls under provider backpressure.
