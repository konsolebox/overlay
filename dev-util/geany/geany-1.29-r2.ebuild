# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit strip-linguas xdg-utils

LANGS='ar ast be bg ca cs de el en_GB es et eu fa fi fr gl he hi hu id it ja kk ko lb lt mn nl nn pl pt pt_BR ro ru sk sl sr sv tr uk vi zh_CN ZH_TW'
NOSHORTLANGS='en_GB zh_CN zh_TW'

DESCRIPTION='GTK+ based fast and lightweight IDE'
HOMEPAGE='http://www.geany.org'
LICENSE="GPL-2+ HPND"

PATCH_VER=${PV}-konsolebox-20161128
SRC_URI="http://download.geany.org/${P}.tar.bz2
	https://github.com/konsolebox/geany-patches/releases/download/${PATCH_VER}/geany-${PATCH_VER}-patch.tar.gz"

SLOT=0
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc konsolebox +vte"

RDEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-2.24:2
	vte? ( x11-libs/vte:0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

pkg_setup() {
	strip-linguas ${LANGS}
}

src_prepare() {
	default
	use konsolebox && eapply "${WORKDIR}/geany-${PATCH_VER}-patch/geany-${PATCH_VER}.patch"

	# Syntax highlighting for Portage
	sed -i -e 's:*.sh;:*.sh;*.ebuild;*.eclass;:' data/filetype_extensions.conf || die
}

src_configure() {
	econf --disable-dependency-tracking --docdir="${EPREFIX}/usr/share/doc/${PF}" \
			--disable-gtk3 "$(use_enable vte)" "$(use_enable doc html-docs)"
}

src_install() {
	emake DESTDIR="${D}" DOCDIR="${D}/usr/share/doc/${PF}" install
	rm -f "${D}/usr/share/doc/${PF}/"{COPYING,GPL-2,ScintillaLicense.txt}
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
