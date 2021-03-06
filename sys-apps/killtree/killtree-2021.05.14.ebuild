# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Sends signals to process trees"
HOMEPAGE="https://github.com/konsolebox/scripts"
LICENSE="public-domain"

SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
RDEPEND="app-shells/bash sys-process/procps"
COMMIT="969d5b64ac6308a653806c67d192e4ad9a494305"
SRC_URI="https://raw.githubusercontent.com/konsolebox/scripts/${COMMIT}/${PN}.bash -> ${PN}-${PV}.bash"
S=${WORKDIR}

src_unpack() {
	cp -v -- "${DISTDIR}/${A}" "${WORKDIR}/${PN}"
}

src_install() {
	dobin "${PN}"
}
