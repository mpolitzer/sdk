#!/bin/sh

set -e

host=$1; shift
arch=$1; shift
abi=$1; shift

# utils
################################################################################
emerge -bkq \
	app-alternatives/cpio \
	app-arch/libarchive \
	app-editors/neovim \
	app-emulation/qemu \
	app-portage/eix \
	app-portage/gentoolkit \
	sys-fs/genext2fs \
	sys-fs/ncdu \
&& eix-update -x musl \
&& cp /usr/bin/qemu-riscv64 /usr/$host/usr/bin/

## use default config for podman
#cp /etc/containers/registries.conf{.example,}
#cp /etc/containers/policy.json{.example,}

# usermod --add-subuids 1065536-1131071 <user>
# usermod --add-subgids 1065536-1131071 <user>
