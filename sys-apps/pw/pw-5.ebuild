# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Pipe Watch: monitor recent lines of output from pipe"
HOMEPAGE="https://www.kylheku.com/cgit/pw/about/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://www.kylheku.com/git/pw.git"
	EGIT_BRANCH=master
else
	SRC_URI="https://www.kylheku.com/cgit/pw/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="BSD-2"
SLOT=0

src_install() {
	doman pw.1 pw-relnotes.5
	dodoc README.md
	dobin pw
}
