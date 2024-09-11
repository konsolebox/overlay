# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Lists ASCII idiomatic names and octal/decimal code-point forms"
HOMEPAGE="http://www.catb.org/~esr/ascii/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/esr/ascii.git"
else
	SRC_URI="http://www.catb.org/~esr/ascii/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="BSD-2"
SLOT="0"
RESTRICT="mirror"

src_compile() {
	emake V=1 CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ascii
	doman ascii.1
	dodoc README
	newdoc NEWS.adoc NEWS
}
