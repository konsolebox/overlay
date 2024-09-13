# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A chroot with more isolation"
HOMEPAGE="https://github.com/vincentbernat/jchroot"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vincentbernat/${PN}.git"
	EGIT_BRANCH=master
else
	SRC_URI="https://github.com/vincentbernat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="ISC"
SLOT=0

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README.md
	doman "${PN}.8"
	dobin "${PN}"
}
