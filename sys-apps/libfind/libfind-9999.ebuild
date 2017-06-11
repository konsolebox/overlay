# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION='Finds library files based on expressions'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

EGIT_REPO_URI='git://github.com/konsolebox/scripts.git'
SRC_URI=

SLOT=0
KEYWORDS=
IUSE=

DEPEND=
RDEPEND='>=app-shells/bash-4.0'

src_install() {
	mv -- "${PN}.sh" "${PN}"
	dobin "${PN}"
}
