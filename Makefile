-include .config

VERSION ?= $(shell git describe --tags --always)
ORG     := ghcr.io/mpolitzer/
TAG     :=:$(VERSION)
IMAGE   := $(ORG)$(host)$(TAG)

default: build | copy
list:
	@echo "available configs:"
	@echo "  " $(patsubst dat/host/%.config,"%", $(wildcard dat/host/*.config))
help:
	@echo "generic targets (+ default):"
	@echo "+ default - build and copy"
	@echo "  help    - show available commands"
	@echo "  list    - show available targets"
	@echo "  config  - create a .config (required to build)"
	@echo "docker targets:"
	@echo "  build   - build the SDK image"
	@echo "  run     - run the SDK environment"
	@echo "  copy    - copy the compiled packages to cache/"
	@echo "  push    - push the SDK into a registry"
clean:
	@git clean -dfX -- cache
config: dat/host/$(host)/defconfig
	@cp $< .config
	@echo "using: $< as .config"
env:
	@echo VERSION=$(VERSION)
	@echo ORG=$(ORG)
	@echo TAG=$(TAG)
	@echo IMAGE=$(IMAGE)
build: dat/host/$(host)/rule .config
	@mkdir -p cache/$(build)/ cache/$(host)/
	$(engine) buildx build --pull --progress=plain $(DOCKER_OPTS) \
		--build-arg build=$(build) \
		--build-arg host=$(host) \
		--build-arg target=$(target) \
		-t $(IMAGE) -f $< .
run:
	$(engine) run --rm -it --volume=$(PWD):/mnt $(IMAGE)
copy:
	@mkdir -p cache/$(build)/ cache/$(host)/
	ID=`$(engine) create $(IMAGE)` && \
	    $(engine) cp $$ID:/var/cache/$(build)/. cache/$(build)/. && \
	    $(engine) cp $$ID:/var/cache/$(host)/.  cache/$(host)/.  && \
	    $(engine) rm -v $$ID
push:
	$(engine) push $(IMAGE)

.PHONY: default list help config copy build run copy env clean
