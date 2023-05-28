# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing savedconfig toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/landley/toybox.git"
else
	SRC_URI="https://landley.net/code/toybox/downloads/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="Common linux commands in a multicall binary"
HOMEPAGE="https://landley.net/code/toybox/"

LICENSE="0BSD"
SLOT="0"
IUSE="make-symlinks"

DEPEND="virtual/libcrypt:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-verbose-build-fix.patch
)

src_prepare() {
	default
	restore_config .config
}

src_configure() {
	tc-export CC STRIP
	export HOSTCC="$(tc-getBUILD_CC)"
	# Respect CFLAGS
	export OPTIMIZE="${CFLAGS}"

	if [[ -f .config ]]; then
		yes "" | emake -j1 oldconfig > /dev/null
		return 0
	else
		einfo "Could not locate user configfile, so we will save a default one"
		emake -j1 defconfig > /dev/null
	fi
}

src_compile() {
	unset CROSS_COMPILE
	export CPUS=$(makeopts_jobs)
	emake V=1 install PREFIX=_install
}

src_test() {
	emake V=1 tests
}

src_install() {
	use savedconfig && save_config .config
	dobin toybox

	tar cf toybox-links.tar -C _install .
	insinto /usr/share/${PN}
	use make-symlinks && doins toybox-links.tar
	use make-symlinks && tar kxf "${T}"/toybox-links.tar -C "${ROOT}"/
}

pkg_preinst() {
	if use make-symlinks ; then
		mv "${ED}"/usr/share/${PN}/toybox-links.tar "${T}"/ || die
	fi
}

pkg_postinst() {
	if use make-symlinks ; then
		tar kxf "${T}"/toybox-links.tar -C "${ROOT}"/
	fi
}
