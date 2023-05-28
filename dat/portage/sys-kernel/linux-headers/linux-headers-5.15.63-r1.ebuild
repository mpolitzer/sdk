EAPI=7

ETYPE="headers"
H_SUPPORTEDARCH="riscv"
inherit kernel-2
detect_version

SRC_URI="https://github.com/cartesi/linux/archive/refs/tags/v${PV}-ctsi-1.tar.gz"
S="${WORKDIR}/linux-${PV}-ctsi-1"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	app-arch/xz-utils
	dev-lang/perl"

# bug #816762
RESTRICT="test"

src_unpack() {
	default
}

src_prepare() {
	default
}

src_test() {
	emake headers_check ${xmakeopts}
}

src_install() {
	kernel-2_src_install

	find "${ED}" \( -name '.install' -o -name '*.cmd' \) -delete || die
	# delete empty directories
	find "${ED}" -empty -type d -delete || die
}
