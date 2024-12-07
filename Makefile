MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
COREDNS_CONTAINER_IP ?= $(shell docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dns)

OS_TYPE ?= $(shell uname)
TEST_COMPOSE_CMD := $(shell docker compose version >/dev/null 2>&1 && echo yes || echo no)


ifeq ($(OS_TYPE), Darwin)
LOCAL_DNS_IP ?= $(shell ifconfig $$(route get 8.8.8.8 | grep interface | awk '{ print $$2 }') | grep -E "inet " | awk '{ print $$2 }')
else
LOCAL_DNS_IP ?= $(shell ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')
endif

ifeq ($(TEST_COMPOSE_CMD),yes)
DOCKER_COMPOSE := docker compose
else
DOCKER_COMPOSE := docker-compose
endif

ECHO := echo
CP := cp
EGREP := egrep

-include .env
-include .env.local
export

export PUID ?= $(shell id -u)
export PGID ?= $(shell id -g)


DOCKER := docker
DOCKER_COMPOSE := docker compose

all: help
.PHONY: all

env:
	printenv
.PHONY: env

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

restart: ## Start all services
	$(DOCKER_COMPOSE) stop && $(DOCKER_COMPOSE) up -d
.PHONY: start-all

start: ## Starts the application for local development (detached)
	$(DOCKER_COMPOSE) up -d
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

clean: ## Stops and removes all docker items related to this service
	@$(DOCKER_COMPOSE) down -v --remove-orphans
.PHONY: clean

$(addprefix shell-, $(APP_SERVICES)): shell-%
shell-%: ## Builds the service given as last part from the make target
	$(DOCKER_COMPOSE) run --remove-orphans $* bash
.PHONY: shell-%