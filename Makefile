MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

DOCKER := docker
DOCKER_COMPOSE := docker compose

all: help
.PHONY: all

help:
	@echo -e "\033[0;32m Usage: make [target] "
	@echo
	@echo -e "\033[1m targets:\033[0m"
	@egrep '^(.+):*\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'
.PHONY: help

run: start
.PHONY: run

shell: ## Run a shell inside the
	$(DOCKER_COMPOSE) run --rm app sh
.PHONY: shell

start-all: ## Start all services
	$(DOCKER_COMPOSE) up -d
.PHONY: start-all

start-attached: ## Starts the application for local development (attached)  (run make build at least once first!)
	$(DOCKER_COMPOSE) up --build --remove-orphans php-symfony
	@echo"The application is available at http://localhost:8081"
.PHONY: start-attached

start: ## Starts the application for local development (detached)
	$(DOCKER_COMPOSE) up -d --remove-orphans php-symfony
	@echo "The application is available at http://localhost:8081"
.PHONY: start

start-js: ## Starts the application for local development (detached)
	$(DOCKER_COMPOSE) up -d --remove-orphans js-react
	@echo "The application is available at http://localhost:8081"
.PHONY: start-js

$(addprefix logs-, $(APP_SERVICES)): logs-%
logs-%: ## Builds the service given as last part from the make target
	$(DOCKER_COMPOSE) logs -f $*
.PHONY: logs-%

$(addprefix attach-, $(APP_SERVICES)): attach-%
attach-%: ## Builds the service given as last part from the make target
	$(DOCKER_COMPOSE) exec -u root:root $* sh
.PHONY: attach-%

$(addprefix start-attached-, $(APP_SERVICES)): start-attached-%
start-attached-%: ## Starts the service given as last part from the make target
	$(DOCKER_COMPOSE) up $*
.PHONY: start-attached-%

$(addprefix start-, $(APP_SERVICES)): start-%
start-%: ## Starts the service given as last part from the make target
	$(DOCKER_COMPOSE) up -d $*
.PHONY: start-%

$(addprefix stop-, $(APP_SERVICES)): stop-%
stop-%: ## Starts the service given as last part from the make target
	$(DOCKER_COMPOSE) stop $*
.PHONY: stop-%

$(addprefix build-, $(APP_SERVICES)): build-%
build-%: ## Builds the service given as last part from the make target
	$(DOCKER_COMPOSE) build --build-arg BUILDKIT_INLINE_CACHE=1 $*
.PHONY: build-%

