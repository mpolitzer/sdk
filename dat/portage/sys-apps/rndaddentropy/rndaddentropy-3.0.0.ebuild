EAPI=8

inherit toolchain-funcs

DESCRIPTION="This is a wrapper for the RNDADDENTROPY ioctl, and is used for directly adding entropy to the Linux primary pool"
HOMEPAGE="https://github.com/rfinnie/twuewand"
SRC_URI="https://github.com/rfinnie/twuewand/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 riscv"
IUSE="static"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND=""
S="${WORKDIR}/twuewand-3.0.0/rndaddentropy"


src_prepare() {
	tc-export AR CC CXX PKG_CONFIG
	default
}

src_install() {
	if use static ; then
		CFLAGS+="-static"
	fi
	emake install \
		DESTDIR="${D}" PREFIX="/usr"
}
