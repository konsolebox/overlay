# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

MY_P=CEGUI-${PV%b}
DESCRIPTION="Crazy Eddie's GUI System"
HOMEPAGE="http://www.cegui.org.uk/"
SRC_URI="https://downloads.sourceforge.net/crayzedsgui/CEGUI%20Mk-2/0.6.2/CEGUI-0.6.2b.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devil opengl"

RDEPEND="dev-libs/libpcre
	media-libs/freetype:2
	devil? ( media-libs/devil )
	opengl? (
		virtual/opengl
		media-libs/freeglut
		media-libs/glew:=
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	eapply -p0 "${FILESDIR}"/${P}-gcc43.patch
	eapply -p1 "${FILESDIR}"/${P}-dups.patch \
		"${FILESDIR}"/${P}-gcc46.patch \
		"${FILESDIR}"/${P}-pointer-comparison-fix.patch
	eapply_user
	sed -i \
		-e 's/ILvoid/void/g' \
		ImageCodecModules/DevILImageCodec/CEGUIDevILImageCodec.cpp || die
	eautoreconf #220040
}

src_configure() {
	econf \
		--disable-debug \
		$(use_enable devil) \
		--disable-samples \
		--disable-expat \
		--disable-irrlicht-renderer \
		--disable-external-toluapp \
		--disable-lua-module \
		--disable-toluacegui \
		$(use_enable opengl external-glew) \
		$(use_enable opengl opengl-renderer) \
		--disable-xerces-c \
		--disable-libxml \
		--disable-static \
		--enable-tga \
		--enable-tinyxml \
		--disable-corona \
		--disable-dependency-tracking \
		--disable-external-tinyxml \
		--disable-freeimage \
		--disable-samples \
		--disable-silly \
		--without-gtk2 \
		--without-ogre-renderer
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
