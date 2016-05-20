# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='Relatively copies binaries along with their dependencies to a directory'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

SRC_URI="https://raw.githubusercontent.com/konsolebox/scripts/8fac56379118292a45347f86010d8845043c879a/rcopy.sh -> rcopy-${PV}.sh"
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
	cp -v -- "${DISTDIR}/${A}" "${S}/rcopy"
}

src_install() {
	dobin rcopy
}
