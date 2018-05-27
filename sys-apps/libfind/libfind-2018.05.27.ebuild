# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='Finds library files based on expressions'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

SRC_URI="https://raw.githubusercontent.com/konsolebox/scripts/982d58cbf1b817d81f1f084ceba683b42336e8aa/libfind.bash -> libfind-${PV}.bash"
S=${WORKDIR}

SLOT=0
KEYWORDS='~amd64 ~arm ~x86'
IUSE=

DEPEND=
RDEPEND='>=app-shells/bash-4.0'

src_unpack() {
	cp -v -- "${DISTDIR}/${A}" "${WORKDIR}/libfind"
}

src_install() {
	dobin libfind
}
