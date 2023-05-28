#!/bin/sh

set -e

host=$1; shift
arch=$1; shift
abi=$1; shift

# C/C++ toolchain
################################################################################
emerge -NDukq -j$(nproc) \
	app-eselect/eselect-repository \
	dev-vcs/git \
	sys-devel/crossdev

eselect repository create crossdev # crossdev wants a separate overlay
eselect repository enable musl     # we'll use musl instead of glibc, fetch it
emaint sync -r musl

# set riscv64 profile
ln -sf /var/db/repos/gentoo/profiles/default/linux/riscv/23.0/rv64/$abi/musl \
	/usr/$host/etc/portage/make.profile
PORTAGE_CONFIGROOT=/usr/$host/ emerge baselayout

crossdev \
	--binutils '<2.36' \
	--gcc      '<12' \
	--kernel   '<5.15.64' \
	--libc     '<1.2.5' \
	--abis      $abi \
	--target $host --show-fail-log -P -kq

# clean crossdev pointless directories
rm -rf /usr/$host/lib32 /usr/$host/usr/lib32
