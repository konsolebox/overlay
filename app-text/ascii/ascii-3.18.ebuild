# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.com/esr/ascii.git"
	inherit git-r3
else
	SRC_URI="http://www.catb.org/~esr/ascii/ascii-3.18.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="Lists ASCII idiomatic names and octal/decimal code-point forms"
HOMEPAGE="http://www.catb.org/~esr/ascii/"

LICENSE="BSD-2"
SLOT="0"

src_compile() {
	emake V=1 CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ascii
	doman ascii.1
	dodoc NEWS README
}
