# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='Sends signals to process trees'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

COMMIT=db9d0c01d0244c67d370766009078b568af544ef
FN=${P}.bash

SRC_URI="https://raw.githubusercontent.com/konsolebox/scripts/${COMMIT}/${PN}.bash -> ${FN}"
S=${WORKDIR}

SLOT=0
KEYWORDS='~amd64 ~arm ~x86'
IUSE=

DEPEND=
RDEPEND='
	app-shells/bash
	sys-process/procps
'

src_unpack() {
	cp -v -- "${DISTDIR}/${FN}" "${WORKDIR}/${PN}"
}

src_install() {
	dobin "${PN}"
}
