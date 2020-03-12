all: build

.PHONY: build

SHELL = /bin/sh

define HELP_TEXT

  Makefile commands

	make build        - Build caddy
	make destroy	  - Destroy all docker containers on the host (risky!)
	make run		  - Build and run docker with caddy

endef

help:
	$(info $(HELP_TEXT))

.pre-build:
	mkdir -p ./build

build: .pre-build
	docker build --target builder -t caddy-build .
	docker run -dti caddy-build
	docker cp `docker ps -l --no-trunc -q`:/usr/local/go/src/caddy/caddy ./build/caddy

destroy:
	docker stop $(shell docker ps -a -q)
	docker rm $(shell docker ps -a -q)
	docker image prune -a

run:
	docker build --target runner -t caddy-dev .
	docker run -dit -p 8080:8080 caddy-dev