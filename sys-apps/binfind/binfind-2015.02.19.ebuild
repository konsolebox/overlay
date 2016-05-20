# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='Searches files based on the value of $PATH'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

SRC_URI='https://raw.githubusercontent.com/konsolebox/scripts/a8b3cec9ccc70e91a5c42ab87d875b606fa88fc3/binfind.sh -> binfind-2015.02.19.sh'
S=${WORKDIR}

SLOT=0
KEYWORDS='~amd64 ~x86'
IUSE=

DEPEND=
RDEPEND='>=app-shells/bash-4.0'

src_unpack() {
	:
}

src_prepare() {
	cp -v -- "${DISTDIR}/${A}" "${S}/binfind"
}

src_install() {
	dobin binfind
}
