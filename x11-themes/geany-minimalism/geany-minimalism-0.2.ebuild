# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A collection of colour schemes for Geany"
HOMEPAGE="https://github.com/konsolebox/geany-minimalism"
LICENSE="GPL-2+"
SRC_URI="https://github.com/konsolebox/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
RDEPEND="dev-util/geany"

src_install() {
	default
	insinto /usr/share/geany/colorschemes
	doins minimalism.conf
}
