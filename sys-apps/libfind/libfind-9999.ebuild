# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION="Finds library files based on expressions"
HOMEPAGE="https://github.com/konsolebox/scripts"
LICENSE="public-domain"

SLOT=0
RDEPEND="app-shells/bash sys-apps/findutils"
EGIT_REPO_URI="https://github.com/konsolebox/scripts.git"

src_install() {
	mv -- "${PN}.bash" "${PN}" && dobin "${PN}"
}
