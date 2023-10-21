-include .config

MAJOR   := 0
MINOR   := 1
PATCH   := 0
LABEL   := -dev
VERSION ?= $(MAJOR).$(MINOR).$(PATCH)$(LABEL)
#VERSION ?= $(shell git describe --tags --always)
ORG     := ghcr.io/mpolitzer/
TAG     :=:$(VERSION)
IMAGE   := $(ORG)$(sysroot)$(TAG)

all: build | copy
list:
	@echo -ne "available configs:\n"
	@echo -ne " "$(patsubst dat/sysroot/%/defconfig,"- %\n",$(wildcard dat/sysroot/*/defconfig))
help:
	@echo "generic targets (+ default):"
	@echo "+ default - build and copy"
	@echo "  help    - show available commands"
	@echo "  list    - show available targets"
	@echo "  config  - create a .config (required to build)"
	@echo "  xsetup  - setup Docker cross execution"
	@echo "  xsetup-required - evaluate if xsetup step is required"
	@echo "docker targets:"
	@echo "  build   - build the SDK image"
	@echo "  run     - run the SDK environment"
	@echo "  copy    - copy the compiled packages to cache/"
	@echo "  push    - push the SDK into a registry"
clean:
	@git clean -dfX -- cache
config: dat/sysroot/$(sysroot)/defconfig
	@cp $< .config
	@echo "using: $< as .config"
env:
	@echo export sysroot=$(sysroot)
	@echo export QEMU_LD_PREFIX=$(QEMU_LD_PREFIX)
ci.env:
	@echo VERSION=$(VERSION)
	@echo ORG=$(ORG)
	@echo IMAGE=$(IMAGE)
linux.env:
	@echo export CROSS_COMPILE=$(sysroot)-
	@echo export ARCH=riscv
	@echo export FW_PAYLOAD=y
	@echo export FW_PAYLOAD_PATH=$(PWD)/work/linux/arch/riscv/boot/Image
linux:
	make -j`nproc` -rC work/linux Image
	make -j`nproc` -rC work/opensbi \
		FW_OPTIONS=0x01 \
		PLATFORM=cartesi \
		FW_PAYLOAD=y \
		FW_PAYLOAD_PATH=$(PWD)/work/linux/arch/riscv/boot/Image
	cp work/opensbi/build/platform/cartesi/firmware/fw_payload.bin $(PWD)/work/linux.bin

build: dat/sysroot/$(sysroot)/rule .config
	@mkdir -p cache/$(build)/ cache/$(sysroot)/
	$(engine) buildx build --load --pull --progress=plain $(DOCKER_OPTS) \
		--build-arg build=$(build) \
		--build-arg sysroot=$(sysroot) \
		--build-arg target=$(target) \
		-t $(IMAGE) -f $< .
run:
	$(engine) run --rm -it --env-file=.config --volume=$(PWD):/mnt $(IMAGE)
copy:
	@mkdir -p cache/$(build)/ cache/$(sysroot)/
	ID=`$(engine) create $(IMAGE)` && \
	    $(engine) cp $$ID:/var/cache/$(build)/.   cache/$(build)/.   && \
	    $(engine) cp $$ID:/var/cache/$(sysroot)/. cache/$(sysroot)/. && \
	    $(engine) rm -v $$ID
push:
	$(engine) push $(IMAGE)
xsetup:
	docker run --privileged --rm  linuxkit/binfmt:bebbae0c1100ebf7bf2ad4dfb9dfd719cf0ef132
xsetup-required:
	@echo 'riscv64 buildx setup required:' `docker buildx ls | grep -q riscv64 && echo no || echo yes`
.PHONY: default list help config copy build run copy env clean xsetup xsetup-required
