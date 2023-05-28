# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_VERSION="5.15.63-ctsi-2-v0.18.0"
ROM_VERSION="0.17.0"

#if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cartesi/machine-emulator.git"
	EGIT_COMMIT="v${PV}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	KEYWORDS="amd64 arm64"
#else
#fi

DESCRIPTION="Reference off-chain implementation of the Cartesi Machine Specification"
HOMEPAGE="https://cartesi.io/"

#LICENSE="LGPL3"
SLOT="0"
IUSE=""

DEPEND="
	dev-cpp/nlohmann_json
	dev-lang/lua:5.4
	dev-libs/boost[context]
	dev-libs/crypto++
	dev-libs/libb64
	dev-lua/lpeg
	dev-lua/luaposix
	dev-lua/luasec
	dev-lua/luasocket
	dev-lua/md5
	dev-util/patchelf
	net-libs/grpc
	"
RDEPEND="${DEPEND}"

src_compile() {
	emake downloads
	emake dep
	emake
}

src_install() {
	emake DESTDIR=${D}                       \
		PREFIX=/usr                          \
		LIB_RUNTIME_PATH=/usr/lib64          \
		LUA_RUNTIME_CPATH=/usr/lib64/lua/5.4 \
		install-emulator install-strip
}
