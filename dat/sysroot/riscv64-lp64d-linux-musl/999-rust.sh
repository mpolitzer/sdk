#!/bin/sh

set -e

host=$1; shift
arch=$1; shift
abi=$1; shift

# rust toolchain
################################################################################
echo "=cross-$host/rust-std-1.68.2-r1 **" >> /etc/portage/package.accept_keywords/cross-$host
ln -s /var/db/repos/local/sys-devel/rust-std/ /var/db/repos/crossdev/cross-$host/
emerge -Dukq -j$(nproc) \
	virtual/rust \
	dev-lang/rust \
	cross-$host/rust-std
