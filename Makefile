COMPOSE        = docker compose
COMPOSE_LOCAL  = docker compose -f docker-compose.yaml -f docker-compose.local.yaml
COMPOSE_OPUS   = docker compose -f docker-compose.yaml -f docker-compose.opus.yaml

.PHONY: run run-local run-opus build rebuild shell logs clean help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | \
	    awk 'BEGIN{FS=":.*##"} {printf "  %-14s %s\n", $$1, $$2}'

run: ## Haiku (main agent) + Ollama fallback + Claude Sonnet vision
	$(COMPOSE) up

run-local: ## All Ollama – completely free, no API keys needed
	$(COMPOSE_LOCAL) up

run-opus: ## Claude Opus 4 (main agent) + Sonnet vision – most capable
	$(COMPOSE_OPUS) up

build: ## Build Docker image (first run or after Dockerfile change)
	$(COMPOSE) build

rebuild: ## Force-rebuild without cache
	$(COMPOSE) build --no-cache

shell: ## Open bash shell in a running container
	$(COMPOSE) exec openmanus bash

logs: ## Tail container logs
	$(COMPOSE) logs -f

clean: ## Remove containers and image
	$(COMPOSE) down --rmi local
