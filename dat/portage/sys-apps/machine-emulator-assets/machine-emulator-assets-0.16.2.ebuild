# SDK version

EAPI=8

KERNEL_VERSION="5.15.63-ctsi-2-v0.17.0"
ROM_VERSION="0.17.0"

#if [[ ${PV} == 9999 ]]; then
#	inherit git-r3
#	EGIT_REPO_URI="https://github.com/cartesi/machine-emulator.git"
#else
	SRC_URI="
		https://github.com/cartesi/image-kernel/releases/download/v0.17.0/linux-${KERNEL_VERSION}.bin
		https://github.com/cartesi/machine-emulator-rom/releases/download/v${ROM_VERSION}/rom-v${ROM_VERSION}.bin"
	KEYWORDS="amd64 arm64"
#fi

DESCRIPTION="Reference off-chain implementation of the Cartesi Machine Specification"
HOMEPAGE="https://cartesi.io/"

#LICENSE="LGPL3"
SLOT="0"
IUSE=""
S="${WORKDIR}"

DEPEND="
	sys-apps/machine-emulator
	"
RDEPEND="${DEPEND}"

src_unpack() {
	:
}
src_compile() {
	:
}

src_install() {
	IMAGES="${D}/usr/share/cartesi-machine/images"
	mkdir -p "${IMAGES}"
	cp ${DISTDIR}/linux-${KERNEL_VERSION}.bin ${IMAGES}/linux.bin
	cp ${DISTDIR}/rom-v${ROM_VERSION}.bin     ${IMAGES}/rom.bin
}

