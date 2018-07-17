# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='Sends signals to process trees'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

COMMIT=fa6e99f45311d8007d680f1d1983d0cc42ecde2e
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
