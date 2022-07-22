# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A chroot with more isolation"
HOMEPAGE="https://github.com/vincentbernat/jchroot"
LICENSE="ISC"

SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SRC_URI="https://github.com/vincentbernat/jchroot/archive/v${PV}.tar.gz -> jchroot-${PV}.tar.gz"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README.md
	doman "${PN}.8"
	dobin "${PN}"
}
