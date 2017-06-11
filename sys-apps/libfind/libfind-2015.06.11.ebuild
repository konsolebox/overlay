# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION='Finds library files based on expressions'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

SRC_URI='https://raw.githubusercontent.com/konsolebox/scripts/34611edd00554a7a7f6e5de277faf54a1961cfee/libfind.sh -> libfind-2015.06.11.sh'
S=${WORKDIR}

SLOT=0
KEYWORDS='~amd64 ~arm ~x86'
IUSE=

DEPEND=
RDEPEND='>=app-shells/bash-4.0'

src_unpack() {
	:
}

src_prepare() {
	cp -v -- "${DISTDIR}/${A}" "${S}/libfind"
}

src_install() {
	dobin libfind
}
