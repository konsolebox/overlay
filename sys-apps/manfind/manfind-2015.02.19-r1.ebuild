# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='Searches files based on the value of $PATH'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

SRC_URI='https://raw.githubusercontent.com/konsolebox/scripts/a8b3cec9ccc70e91a5c42ab87d875b606fa88fc3/manfind.sh -> manfind-2015.02.19.sh'
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
	cp -v -- "${DISTDIR}/${A}" "${S}/manfind"
}

src_install() {
	dobin manfind
}
