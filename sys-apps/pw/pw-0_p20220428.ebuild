# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 toolchain-funcs

DESCRIPTION="Pipe Watch: monitor recent lines of output from pipe"
HOMEPAGE="https://www.kylheku.com/git/pw.git"
LICENSE="BSD-2"

SLOT=0
EGIT_REPO_URI="https://www.kylheku.com/cgit/pw/"
EGIT_BRANCH=master
EGIT_COMMIT=c85080d345eae0d76b0373d767e0e0d627faabb2
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_prepare() {
	rm -f Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" pw
}

src_install() {
	doman "${PN}.1"
	dobin "${PN}"
}
