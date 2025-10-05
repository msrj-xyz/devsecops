# DevSecOps Portfolio Makefile
# This Makefile provides convenient commands for development, testing, and deployment

.DEFAULT_GOAL := help
.PHONY: help setup clean install test lint security docker k8s infra docs

# Variables
PROJECT_NAME := devsecops-portfolio
DOCKER_IMAGE := ghcr.io/msrj-xyz/$(PROJECT_NAME)
DOCKER_TAG := latest
K8S_NAMESPACE := devsecops
TERRAFORM_DIR := infrastructure/terraform

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Help target
help: ## Show this help message
	@echo "$(BLUE)DevSecOps Portfolio - Available Commands$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)Examples:$(NC)"
	@echo "  make setup              # Initial project setup"
	@echo "  make security-scan      # Run all security scans"
	@echo "  make docker-build       # Build Docker image"
	@echo "  make test-all           # Run all tests"

# ==============================================
# SETUP AND INSTALLATION
# ==============================================

setup: ## Initial project setup with all dependencies and tools
	@echo "$(BLUE)Setting up DevSecOps portfolio...$(NC)"
	@bash scripts/setup.sh
	@echo "$(GREEN)Setup completed successfully!$(NC)"

clean: ## Clean all build artifacts and temporary files
	@echo "$(YELLOW)Cleaning build artifacts...$(NC)"
	rm -rf node_modules/
	rm -rf dist/
	rm -rf build/
	rm -rf coverage/
	rm -rf .nyc_output/
	rm -rf reports/
	rm -rf logs/
	rm -rf temp/
	docker system prune -f
	@echo "$(GREEN)Cleanup completed!$(NC)"

install: ## Install all dependencies
	@echo "$(BLUE)Installing dependencies...$(NC)"
	npm install
	pip3 install -r requirements.txt
	pip3 install -r requirements-dev.txt
	@echo "$(GREEN)Dependencies installed!$(NC)"

# ==============================================
# DEVELOPMENT
# ==============================================

dev: ## Start development environment
	@echo "$(BLUE)Starting development environment...$(NC)"
	npm run dev

dev-setup: ## Setup development environment
	@echo "$(BLUE)Setting up development environment...$(NC)"
	cp .env.example .env
	npm install
	pre-commit install
	@echo "$(GREEN)Development environment ready!$(NC)"

# ==============================================
# TESTING
# ==============================================

test: test-unit ## Run unit tests (default)

test-unit: ## Run unit tests
	@echo "$(BLUE)Running unit tests...$(NC)"
	npm run test:unit

test-integration: ## Run integration tests
	@echo "$(BLUE)Running integration tests...$(NC)"
	npm run test:integration

test-e2e: ## Run end-to-end tests
	@echo "$(BLUE)Running E2E tests...$(NC)"
	npm run test:e2e

test-security: ## Run security-focused tests
	@echo "$(BLUE)Running security tests...$(NC)"
	npm run test:security

test-all: test-unit test-integration test-security ## Run all tests
	@echo "$(GREEN)All tests completed!$(NC)"

# ==============================================
# CODE QUALITY
# ==============================================

lint: ## Run linter and formatter
	@echo "$(BLUE)Running linter...$(NC)"
	npm run lint
	npm run format

lint-check: ## Check code formatting without fixing
	@echo "$(BLUE)Checking code format...$(NC)"
	npm run format:check

# ==============================================
# SECURITY
# ==============================================

security-scan: ## Run comprehensive security scan
	@echo "$(BLUE)Running comprehensive security scan...$(NC)"
	npm run security:scan
	@echo "$(GREEN)Security scan completed! Check reports/ directory$(NC)"

security-secrets: ## Scan for secrets in code
	@echo "$(BLUE)Scanning for secrets...$(NC)"
	npm run security:secrets

security-deps: ## Scan dependencies for vulnerabilities
	@echo "$(BLUE)Scanning dependencies...$(NC)"
	npm run security:deps

security-sast: ## Run static application security testing
	@echo "$(BLUE)Running SAST scan...$(NC)"
	npm run security:sast

security-fix: ## Fix security vulnerabilities automatically
	@echo "$(BLUE)Fixing security vulnerabilities...$(NC)"
	npm run security:fix

# ==============================================
# DOCKER
# ==============================================

docker-build: ## Build Docker image
	@echo "$(BLUE)Building Docker image...$(NC)"
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "$(GREEN)Docker image built: $(DOCKER_IMAGE):$(DOCKER_TAG)$(NC)"

docker-scan: ## Scan Docker image for vulnerabilities
	@echo "$(BLUE)Scanning Docker image...$(NC)"
	npm run docker:scan

docker-run: ## Run Docker container locally
	@echo "$(BLUE)Running Docker container...$(NC)"
	docker run -p 3000:3000 --env-file .env $(DOCKER_IMAGE):$(DOCKER_TAG)

docker-push: docker-build ## Build and push Docker image
	@echo "$(BLUE)Pushing Docker image...$(NC)"
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	@echo "$(GREEN)Docker image pushed!$(NC)"

docker-clean: ## Clean Docker images and containers
	@echo "$(YELLOW)Cleaning Docker resources...$(NC)"
	docker system prune -f
	docker image prune -f

# ==============================================
# KUBERNETES
# ==============================================

k8s-validate: ## Validate Kubernetes manifests
	@echo "$(BLUE)Validating Kubernetes manifests...$(NC)"
	npm run k8s:validate

k8s-deploy: ## Deploy to Kubernetes
	@echo "$(BLUE)Deploying to Kubernetes...$(NC)"
	kubectl create namespace $(K8S_NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	npm run k8s:deploy

k8s-delete: ## Delete from Kubernetes
	@echo "$(YELLOW)Deleting from Kubernetes...$(NC)"
	npm run k8s:delete

k8s-status: ## Show Kubernetes deployment status
	@echo "$(BLUE)Kubernetes status:$(NC)"
	kubectl get all -n $(K8S_NAMESPACE)

k8s-logs: ## Show application logs from Kubernetes
	@echo "$(BLUE)Application logs:$(NC)"
	kubectl logs -l app=$(PROJECT_NAME) -n $(K8S_NAMESPACE) --tail=100 -f

# ==============================================
# INFRASTRUCTURE
# ==============================================

infra-validate: ## Validate Terraform configuration
	@echo "$(BLUE)Validating Terraform configuration...$(NC)"
	cd $(TERRAFORM_DIR) && terraform init -backend=false
	cd $(TERRAFORM_DIR) && terraform validate
	cd $(TERRAFORM_DIR) && terraform fmt -check -recursive

infra-plan: ## Create Terraform execution plan
	@echo "$(BLUE)Creating Terraform plan...$(NC)"
	cd $(TERRAFORM_DIR) && terraform plan -var-file=environments/dev.tfvars

infra-apply: ## Apply Terraform changes
	@echo "$(BLUE)Applying Terraform changes...$(NC)"
	cd $(TERRAFORM_DIR) && terraform apply -var-file=environments/dev.tfvars

infra-destroy: ## Destroy Terraform infrastructure
	@echo "$(RED)Destroying Terraform infrastructure...$(NC)"
	@read -p "Are you sure you want to destroy the infrastructure? [y/N] " confirm && [[ $$confirm == [yY] ]] || exit 1
	cd $(TERRAFORM_DIR) && terraform destroy -var-file=environments/dev.tfvars

infra-scan: ## Scan infrastructure for security issues
	@echo "$(BLUE)Scanning infrastructure...$(NC)"
	npm run infra:scan

infra-cost: ## Estimate infrastructure costs
	@echo "$(BLUE)Estimating infrastructure costs...$(NC)"
	cd $(TERRAFORM_DIR) && infracost breakdown --path .

# ==============================================
# MONITORING
# ==============================================

monitor-start: ## Start monitoring stack
	@echo "$(BLUE)Starting monitoring stack...$(NC)"
	npm run monitor:start
	@echo "$(GREEN)Monitoring stack started!$(NC)"
	@echo "Prometheus: http://localhost:9090"
	@echo "Grafana: http://localhost:3001"

monitor-stop: ## Stop monitoring stack
	@echo "$(YELLOW)Stopping monitoring stack...$(NC)"
	npm run monitor:stop

monitor-status: ## Show monitoring stack status
	@echo "$(BLUE)Monitoring stack status:$(NC)"
	docker-compose -f monitoring/docker-compose.yml ps

# ==============================================
# DOCUMENTATION
# ==============================================

docs-generate: ## Generate project documentation
	@echo "$(BLUE)Generating documentation...$(NC)"
	npm run docs:generate
	@echo "$(GREEN)Documentation generated in docs/ directory$(NC)"

docs-serve: ## Serve documentation locally
	@echo "$(BLUE)Serving documentation at http://localhost:8080$(NC)"
	npm run docs:serve

# ==============================================
# COMPLIANCE
# ==============================================

compliance-check: ## Run compliance validation
	@echo "$(BLUE)Running compliance checks...$(NC)"
	npm run compliance:check
	@echo "$(GREEN)Compliance check completed!$(NC)"

compliance-report: ## Generate compliance report
	@echo "$(BLUE)Generating compliance report...$(NC)"
	@mkdir -p reports
	@echo "# Compliance Report" > reports/compliance-report.md
	@echo "Generated: $$(date)" >> reports/compliance-report.md
	@echo "" >> reports/compliance-report.md
	@echo "## Security Scan Results" >> reports/compliance-report.md
	@make security-scan >> reports/compliance-report.md 2>&1 || true
	@echo "## Infrastructure Scan Results" >> reports/compliance-report.md
	@make infra-scan >> reports/compliance-report.md 2>&1 || true
	@echo "$(GREEN)Compliance report generated: reports/compliance-report.md$(NC)"

# ==============================================
# CI/CD
# ==============================================

ci-test: ## Run CI pipeline tests locally
	@echo "$(BLUE)Running CI pipeline tests...$(NC)"
	make lint
	make test-all
	make security-scan
	make docker-build
	make docker-scan
	@echo "$(GREEN)CI pipeline tests completed!$(NC)"

pre-commit: ## Run pre-commit checks
	@echo "$(BLUE)Running pre-commit checks...$(NC)"
	pre-commit run --all-files

# ==============================================
# UTILITIES
# ==============================================

logs: ## Show application logs
	@echo "$(BLUE)Showing application logs...$(NC)"
	tail -f logs/app.log 2>/dev/null || echo "No log file found"

shell: ## Open interactive shell in container  
	@echo "$(BLUE)Opening shell in container...$(NC)"
	docker run -it --rm $(DOCKER_IMAGE):$(DOCKER_TAG) /bin/sh

backup: ## Create backup of important files
	@echo "$(BLUE)Creating backup...$(NC)"
	@mkdir -p backups
	tar -czf backups/backup-$$(date +%Y%m%d-%H%M%S).tar.gz \
		--exclude=node_modules \
		--exclude=.git \
		--exclude=dist \
		--exclude=coverage \
		.
	@echo "$(GREEN)Backup created in backups/ directory$(NC)"

version: ## Show version information
	@echo "$(BLUE)Version Information:$(NC)"
	@echo "Node.js: $$(node --version)"
	@echo "npm: $$(npm --version)"
	@echo "Docker: $$(docker --version)"
	@echo "Terraform: $$(terraform --version | head -n1)"
	@echo "kubectl: $$(kubectl version --client --short 2>/dev/null || echo 'Not available')"

# ==============================================
# ENVIRONMENT SPECIFIC
# ==============================================

deploy-dev: ## Deploy to development environment
	@echo "$(BLUE)Deploying to development...$(NC)"
	make docker-build
	make docker-push
	cd $(TERRAFORM_DIR) && terraform apply -var-file=environments/dev.tfvars -auto-approve

deploy-staging: ## Deploy to staging environment
	@echo "$(BLUE)Deploying to staging...$(NC)"
	make docker-build
	make docker-push
	cd $(TERRAFORM_DIR) && terraform apply -var-file=environments/staging.tfvars

deploy-prod: ## Deploy to production environment
	@echo "$(RED)Deploying to production...$(NC)"
	@read -p "Are you sure you want to deploy to production? [y/N] " confirm && [[ $$confirm == [yY] ]] || exit 1
	make ci-test
	make docker-build
	make docker-push
	cd $(TERRAFORM_DIR) && terraform apply -var-file=environments/production.tfvars