# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION='Relatively copies binaries along with their dependencies to a directory'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

EGIT_REPO_URI='https://github.com/konsolebox/scripts.git'
SRC_URI=

SLOT=0
KEYWORDS=
IUSE=

DEPEND=
RDEPEND='>=app-shells/bash-4.0'

src_install() {
	mv -- rcopy.bash rcopy && dobin rcopy
}
