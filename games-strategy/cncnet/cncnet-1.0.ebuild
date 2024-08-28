# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Command & Conquer Online"
HOMEPAGE="https://cncnet.org/"
SRC_URI="https://downloads.cncnet.org/${P}-1-any.pkg.tar.xz"
S="${WORKDIR}"
LICENSE="CnCNet"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="|| (
	app-emulation/wine-d3d9[abi_x86_32]
	app-emulation/wine-proton[abi_x86_32]
	app-emulation/wine-staging[abi_x86_32]
	app-emulation/wine-vanilla[abi_x86_32]
)"
RESTRICT="mirror strip"

src_install() {
	dobin usr/games/cncnet
	insinto "usr/share/doc/${P}"
	doins usr/share/doc/cncnet/*
	sed -i 's|/usr/games/|/usr/bin/|' usr/share/applications/cncnet.desktop
	cp -pPR usr/share/{applications,icons} "${D}/usr/share/"
}

pkg_postinst() {
	xdg_icon_cache_update
}
