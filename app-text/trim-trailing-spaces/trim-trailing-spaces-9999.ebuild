# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION="Removes trailing spaces in files"
HOMEPAGE="https://github.com/konsolebox/scripts"
LICENSE="MIT"

SLOT=0
RDEPEND="app-shells/bash sys-apps/coreutils sys-apps/findutils sys-apps/grep sys-apps/sed"
EGIT_REPO_URI="https://github.com/konsolebox/scripts.git"
EGIT_BRANCH=master

src_install() {
	mv -- "${PN}.bash" "${PN}" && dobin "${PN}"
}
