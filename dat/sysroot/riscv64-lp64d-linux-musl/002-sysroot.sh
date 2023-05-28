#!/bin/sh

set -e

host=$1; shift
arch=$1; shift
abi=$1; shift

# sysroot
################################################################################

$host-emerge -bkq \
	sys-apps/busybox
