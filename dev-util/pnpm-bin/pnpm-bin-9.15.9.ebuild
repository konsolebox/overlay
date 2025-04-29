# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient package manager"
HOMEPAGE="https://pnpm.io/"

MY_PV=${PV/_alpha/-alpha.} MY_PV=${MY_PV/_beta/-beta.}

SRC_URI="
	arm64? ( https://github.com/pnpm/pnpm/releases/download/v${MY_PV}/pnpm-linux-arm64 -> ${P}-arm64 )
	amd64? ( https://github.com/pnpm/pnpm/releases/download/v${MY_PV}/pnpm-linux-x64 -> ${P}-amd64 )
"

S=${WORKDIR}
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
REQUIRED_USE="^^ ( amd64 arm64 )"
RESTRICT="mirror strip"
RDEPEND="!dev-util/pnpm"

src_install() {
	# Install as pnpm because of https://github.com/pnpm/pnpm/issues/8855
	# Adding a symlink isn't enough.  'pnpm setup' still names the copy as pnpm-bin.
	newbin "${DISTDIR}/${A}" pnpm
}
