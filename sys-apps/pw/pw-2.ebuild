# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Pipe Watch: monitor recent lines of output from pipe"
HOMEPAGE="https://www.kylheku.com/cgit/pw/"
LICENSE="BSD-2"

SLOT=0
SRC_URI="https://www.kylheku.com/cgit/pw/snapshot/pw-${PV}.tar.bz2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

src_install() {
	doman pw.1 pw-relnotes.5
	dobin pw
}
