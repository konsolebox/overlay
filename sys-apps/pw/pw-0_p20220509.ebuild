# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="Pipe Watch: monitor recent lines of output from pipe"
HOMEPAGE="https://www.kylheku.com/cgit/pw/"
LICENSE="BSD-2"

SLOT=0
EGIT_REPO_URI="https://www.kylheku.com/git/pw.git"
EGIT_BRANCH=master
EGIT_COMMIT=4dc7fe9854ca533ea4de84221061fb857b6e0dd4
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
