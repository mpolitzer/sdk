EAPI=8

inherit autotools

DESCRIPTION="generate ext2 file systems"
HOMEPAGE="https://github.com/cartesi/genext2fs"
SRC_URI="https://github.com/cartesi/genext2fs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ~sparc x86"
DEPEND="app-arch/libarchive"

src_prepare() {
	default
	eautoreconf
}
