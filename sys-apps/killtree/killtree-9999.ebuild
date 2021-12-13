# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION="Sends signals to process trees"
HOMEPAGE="https://github.com/konsolebox/scripts"
LICENSE="public-domain"

SLOT=0
RDEPEND="app-shells/bash sys-process/procps"
EGIT_REPO_URI="https://github.com/konsolebox/scripts.git"
EGIT_BRANCH=master

src_install() {
	mv -- "${PN}.bash" "${PN}" && dobin "${PN}"
}
