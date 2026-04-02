# --- Project Configuration ---
PROJECT_NAME=mia-ai-agri-genome-stream
GO_MODULE=github.com/siralfbaez/$(PROJECT_NAME)

# --- Colors for Output ---
BLUE=\033[0;34m
NC=\033[0m

.PHONY: all scaffold init-go help

all: help

## 🏗️  scaffold: Create the "Nervous System" directory structure
scaffold:
	@echo "$(BLUE)Creating Directory Skeleton...$(NC)"
	mkdir -p services/signal-gateway/cmd \
		services/ingestion-transformer/internal/medallion \
		services/worker-dataflow/cmd \
		services/ai-agent/internal/logic/prompts \
		pkg/resilience pkg/vertexai pkg/genomics pkg/observability \
		api/proto api/openapi schemas/avro schemas/protobuf \
		terraform/environments/{dev,prod} \
		terraform/modules/{gke-cluster,alloydb,pubsub,vpc-network} \
		notebooks/exploration \
		database/migrations database/scripts/cdc-setup \
		docs/architecture/blueprints docs/compliance/nist-800-53 \
		agent/knowledge-base/genomic-standards
	@echo "$(BLUE)Skeleton Complete.$(NC)"

## 🐹 init-go: Initialize Go modules for all services
init-go:
	@echo "$(BLUE)Initializing Go Workspace...$(NC)"
	go mod init $(GO_MODULE)
	@echo "Creating service main files..."
	@touch services/signal-gateway/cmd/main.go
	@touch services/ingestion-transformer/cmd/main.go
	@touch services/ai-agent/cmd/main.go
	@echo "Go initialization complete."

## 🧹 clean: Remove binaries and temporary files
clean:
	rm -rf bin/
	find . -name "*.log" -type f -delete

## ❓ help: Show this help message
help:
	@echo "$(BLUE)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
