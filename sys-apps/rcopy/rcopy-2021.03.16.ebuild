# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Relatively copies binaries along with their dependencies to a directory"
HOMEPAGE="https://github.com/konsolebox/scripts"
LICENSE="public-domain"

SLOT=0
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RDEPEND=">=app-shells/bash-4.0 sys-apps/coreutils sys-libs/glibc"
COMMIT="8839aae5a30a747a0e5d3bafe0d88f7c5cb08170"
SRC_URI="https://raw.githubusercontent.com/konsolebox/scripts/${COMMIT}/${PN}.bash -> ${PN}-${PV}.bash"
S=${WORKDIR}

src_unpack() {
	cp -v -- "${DISTDIR}/${A}" "${WORKDIR}/${PN}"
}

src_install() {
	dobin "${PN}"
}
