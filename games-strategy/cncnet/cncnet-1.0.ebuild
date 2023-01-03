# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="CnCNet"
HOMEPAGE="https://cncnet.org/"
SRC_URI="https://downloads.cncnet.org/cncnet-1.0-1-any.pkg.tar.xz"
LICENSE="CnCNet"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"
RDEPEND="|| (
	app-emulation/wine-d3d9
	app-emulation/wine-staging[abi_x86_32]
	app-emulation/wine-vanilla[abi_x86_32]
)"
S="${WORKDIR}"

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
