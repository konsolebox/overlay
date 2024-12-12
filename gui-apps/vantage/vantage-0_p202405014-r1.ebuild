# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Lenovo Vantage for Linux"
HOMEPAGE="https://github.com/niizam/vantage"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/niizam/vantage.git"
	EGIT_BRANCH=main
else
	COMMIT=0e123d7508ca20bef26d4ea8ba2a13124f863d10
	SRC_URI="https://github.com/niizam/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
RESTRICT="mirror"

RDEPEND="
	gnome-extra/zenity
	media-libs/libpulse
	net-misc/networkmanager[tools]
	x11-apps/xinput
"

src_compile() {
	:
}

src_install() {
	dodoc README.md
	newbin vantage.sh vantage
	newicon icon.png vantage.png
	make_desktop_entry vantage "Lenovo Vantage" vantage System "Encoding=UTF-8\nTerminal=false"
}
