# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop

DESCRIPTION="Secret Maryo Chronicles"
HOMEPAGE="http://www.secretmaryo.org/"

MUSIC_V=5.0
MUSIC_P=SMC_Music_${MUSIC_V}_high
SRC_URI="https://downloads.sourceforge.net/project/smclone/Secret%20Maryo%20Chronicles/${PV}/${P}.tar.bz2
	music? ( https://downloads.sourceforge.net/project/smclone/Addon%20-%20Music/${MUSIC_V}/${MUSIC_P}.zip )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+music"
RESTRICT="mirror"

RDEPEND="<dev-games/cegui-0.7[opengl,devil]
	dev-libs/boost
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	dev-libs/libpcre[unicode]
	media-libs/libpng:0
	media-libs/libsdl[X,joystick,opengl]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	music? ( app-arch/unzip )"

src_unpack() {
	unpack "${P}.tar.bz2"
	cd "${S}"
	use music && unpack "${MUSIC_P}.zip"
}

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}-boost150.patch"
	eapply -p1 "${FILESDIR}/${P}-underlink.patch"
	eapply_user
	eautoreconf
}

src_install() {
	default
	newicon data/icon/window_32.png smc.png
	make_desktop_entry "${PN}" "Secret Maryo Chronicles"
	doman makefiles/unix/man/smc.6
	dodoc docs/*.txt
	docinto html
	dodoc docs/*.{css,html}
}
