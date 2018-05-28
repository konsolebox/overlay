# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='Relatively copies binaries along with their dependencies to a directory'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

SRC_URI="https://raw.githubusercontent.com/konsolebox/scripts/6a899da0079e26f1454b32c6fbcfd8039d6469de/rcopy.bash -> rcopy-${PVR}.bash"
S=${WORKDIR}

SLOT=0
KEYWORDS='~amd64 ~arm ~x86'
IUSE=

DEPEND=
RDEPEND='>=app-shells/bash-4.0'

src_unpack() {
	cp -v -- "${DISTDIR}/${A}" "${WORKDIR}/rcopy"
}

src_install() {
	dobin rcopy
}
