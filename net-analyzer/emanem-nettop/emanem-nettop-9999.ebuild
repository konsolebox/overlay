# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 toolchain-funcs

DESCRIPTION="A simple process/network usage report for Linux"
HOMEPAGE="http://nettop.youlink.org"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"
RDEPEND="
	${DEPEND}
	!net-analyzer/nettop
"

src_unpack() {
	EGIT_REPO_URI="https://github.com/Emanem/nettop.git"
	EGIT_BRANCH=master
	git-r3_src_unpack
}

src_prepare() {
	local ncurses pcap pkgconfig
	pkgconfig=$(tc-getPKG_CONFIG) || die
	ncurses=$(${pkgconfig} --libs ncurses) || die
	pcap=$(${pkgconfig} --libs libpcap) || die
	sed -i -e "s|-lcurses|${ncurses}|g; s|-lpcap|${pcap}|g" Makefile || die
	default
}

src_install() {
	dosbin nettop
	dodoc README.md
}
