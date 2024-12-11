# Copyright 1999-2024 Gentoo Authors
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
RDEPEND="!dev-util/pnpm" # Until https://github.com/pnpm/pnpm/issues/8855 is resolved

src_install() {
	newbin "${DISTDIR}/${A}" "${PN}"

	# Create a symlink because https://github.com/pnpm/pnpm/issues/8855
	dosym "${PN}" /usr/bin/pnpm
}
