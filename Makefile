SHELL := /bin/bash
ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: help lint proto-check schema-check conformance-smoke check tools

help:
	@echo "USAGE Spec Validation Targets"
	@echo "  make lint              - Validate repo structure and references"
	@echo "  make proto-check       - Parse/validate proto files (requires protoc)"
	@echo "  make schema-check      - Validate JSON schema and examples"
	@echo "  make conformance-smoke - Smoke-check conformance docs and CRDs"
	@echo "  make check             - Run lint + proto-check + schema-check + conformance-smoke"
	@echo "  make tools             - Show local tool availability"

lint:
	@bash "$(ROOT)tools/lint.sh"

proto-check:
	@bash "$(ROOT)tools/proto-check.sh"

schema-check:
	@bash "$(ROOT)tools/schema-check.sh"

conformance-smoke:
	@bash "$(ROOT)tools/conformance-smoke.sh"

check: lint proto-check schema-check conformance-smoke

tools:
	@bash "$(ROOT)tools/tools.sh"
