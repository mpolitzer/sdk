#!/bin/sh

set -e

host=$1; shift
arch=$1; shift
abi=$1; shift

# sysroot
################################################################################

$host-emerge -bkq \
	sys-apps/toybox \
	app-shells/bash

# install toybox links
# for i in $(toybox --long); do toybox ln -s /usr/bin/toybox $i; done
