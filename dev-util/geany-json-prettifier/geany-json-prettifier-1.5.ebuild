# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

DESCRIPTION='A JSON formatter prettifier, minifier and validator plugin for Geany editor'
HOMEPAGE='https://plugins.geany.org/jsonprettifier.html'
LICENSE=GPL-2+

MY_PN=Geany-JSON-Prettifier
MY_P=${MY_PN}-${PV}
SRC_URI="https://github.com/zhgzhg/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

SLOT=0

KEYWORDS='amd64 x86'
IUSE=
LINGUAS=

DEPEND="${RDEPEND}"
RDEPEND="dev-util/geany"

S=${WORKDIR}/${MY_P}

src_compile() {
	make || die
}

src_install() {
	install -m 755 -D ./jsonprettifier.so "${ED}/usr/$(get_libdir)/geany/jsonprettifier.so" || die
}
