# BAZAR Marketplace - Development Makefile

.PHONY: help install test build clean deploy

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies
	flutter pub get
	flutter pub run build_runner build

test: ## Run all tests
	flutter test
	flutter test integration_test/

test-unit: ## Run unit tests
	flutter test test/unit/

test-widget: ## Run widget tests
	flutter test test/widget/

test-integration: ## Run integration tests
	flutter test integration_test/

test-golden: ## Run golden tests
	flutter test test/golden/

test-coverage: ## Run tests with coverage
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

analyze: ## Analyze code
	flutter analyze

build-web: ## Build for web
	flutter build web --release

build-android: ## Build for Android
	flutter build apk --release

build-ios: ## Build for iOS
	flutter build ios --release

build-all: ## Build for all platforms
	make build-web
	make build-android
	make build-ios

clean: ## Clean build files
	flutter clean
	flutter pub get

deploy-staging: ## Deploy to staging
	flutter build web --release --dart-define=ENVIRONMENT=staging
	# Add staging deployment commands

deploy-production: ## Deploy to production
	flutter build web --release --dart-define=ENVIRONMENT=production
	# Add production deployment commands

docker-build: ## Build Docker image
	docker build -t bazar-marketplace .

docker-run: ## Run Docker container
	docker run -p 80:80 bazar-marketplace

performance: ## Run performance tests
	flutter test test/integration/flows/performance_test.dart

security: ## Run security audit
	flutter pub audit

format: ## Format code
	dart format .

lint: ## Run linter
	dart analyze

setup: ## Setup development environment
	make install
	make analyze
	make test
