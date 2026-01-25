# ============================================================================
# GOVBANK CORE - MAKEFILE
# Comandos para build, deploy e testes
# ============================================================================

.PHONY: help setup build test clean deploy-dev deploy-prod

help: ## Mostra este help
	@echo "==================================================="
	@echo "  GOVBANK CORE - COMANDOS DISPONÍVEIS"
	@echo "==================================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Configura o ambiente (primeira vez)
	@echo "📦 Instalando dependências..."
	mkdir -p logs/api logs/cobol logs/postgres
	touch logs/.gitkeep logs/api/.gitkeep logs/cobol/.gitkeep logs/postgres/.gitkeep
	cp -n .env.example .env || true
	@echo "✅ Ambiente configurado! Edite o arquivo .env se necessário"

db-start: ## Inicia apenas o banco de dados
	docker compose -f docker/postgres/docker-compose.yml up -d

db-stop: ## Para o banco de dados
	docker compose -f docker/postgres/docker-compose.yml down

db-reset: ## Reseta o banco (CUIDADO: apaga tudo!)
	docker compose -f docker/postgres/docker-compose.yml down -v
	docker compose -f docker/postgres/docker-compose.yml up -d
	sleep 5
	docker compose -f docker/postgres/docker-compose.yml exec postgres psql -U govbank_app -d govbank_core -f /docker-entrypoint-initdb.d/01-schema.sql

build-api: ## Compila a API Java
	cd api && mvn clean package -DskipTests

build-cobol: ## Compila os programas COBOL
	cd core && ./compile.sh

build-all: build-api build-cobol ## Compila tudo

run-api: ## Executa a API localmente
	cd api && mvn spring-boot:run

run-cobol: ## Executa programa COBOL específico (use PROG=nome)
	cd core/bin && ./$(PROG)

test-api: ## Roda testes da API
	cd api && mvn test

test-integration: ## Roda testes de integração
	./scripts/test/run-integration-tests.sh

clean: ## Limpa builds
	cd api && mvn clean || true
	rm -rf core/bin/* || true
	rm -rf logs/*.log || true

# ============================================================================
# DOCKER COMMANDS
# ============================================================================

docker-build: ## Constrói todas as imagens Docker
	docker compose build

docker-up: ## Sobe todos os containers
	docker compose up -d

docker-down: ## Para todos os containers
	docker compose down

docker-restart: ## Reinicia todos os containers
	docker compose restart

docker-logs: ## Mostra logs dos containers
	docker compose logs -f

docker-logs-api: ## Logs apenas da API
	docker compose logs -f api

docker-logs-cobol: ## Logs apenas do COBOL
	docker compose logs -f cobol

docker-logs-db: ## Logs apenas do PostgreSQL
	docker compose logs -f postgres

docker-ps: ## Lista containers em execução
	docker compose ps

docker-clean: ## Remove containers, volumes e redes
	docker compose down -v --remove-orphans

docker-shell-api: ## Acessa shell do container API
	docker compose exec api sh

docker-shell-cobol: ## Acessa shell do container COBOL
	docker compose exec cobol bash

docker-shell-db: ## Acessa psql do PostgreSQL
	docker compose exec postgres psql -U govbank_app -d govbank_core

deploy-dev: ## Deploy em ambiente DEV
	./scripts/deploy/deploy-dev.sh

deploy-prod: ## Deploy em PRODUÇÃO
	./scripts/deploy/deploy-prod.sh

backup: ## Faz backup do banco
	./scripts/backup/backup-database.sh

logs-tail: ## Acompanha logs em tempo real
	tail -f logs/api/application.log logs/cobol/processing.log || true