# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib multilib-minimal

DESCRIPTION="Message Digest functions from BSD systems"
HOMEPAGE="https://www.hadrons.org/software/libmd/"
SRC_URI="https://archive.hadrons.org/software/libmd/${P}.tar.xz"

LICENSE="|| ( BSD BSD-2 ISC BEER-WARE public-domain )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-static
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
}
