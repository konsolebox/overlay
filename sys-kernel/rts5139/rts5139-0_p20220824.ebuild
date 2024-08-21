# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT=ee1b8bd4b447e140ec50a8d8ed5b399917d85862
DESCRIPTION="A temporary fix for RTS5129/RTS5139 USB MMC card reader on Linux 3.16+ kernels"
HOMEPAGE="https://github.com/asymingt/rts5139"
SRC_URI="https://github.com/asymingt/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

src_compile() {
	local modlist=( "${PN}=drivers/scsi" )
	local modargs=( KVER="${KV_FULL}" )
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	insinto /usr/lib/modules-load.d/
	doins "${FILESDIR}/${PN}.conf"
	insinto /usr/lib/modprobe.d/
	doins "${FILESDIR}/blacklist-rtsx.conf"
}
