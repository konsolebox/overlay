# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools strip-linguas xdg-utils

LANGS="ar ast be bg ca cs de el en_GB es et eu fa fi fr gl he hi hu id it ja kk ko lb lt mn nl nn pl pt pt_BR ro ru sk sl sr sv tr uk vi zh_CN ZH_TW"
NOSHORTLANGS="en_GB zh_CN zh_TW"

DESCRIPTION="GTK+ based fast and lightweight IDE"
HOMEPAGE="http://www.geany.org"
LICENSE="GPL-2+ HPND"
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc konsolebox +vte"
REQUIRED_USE="konsolebox"

COMMIT=6201e25bcc1b7b3a84d647bd2f8d8f21d51672ce
SRC_URI="https://github.com/konsolebox/geany/archive/${COMMIT}.tar.gz -> ${P%_*}-konsolebox-${PV#*_p}-${COMMIT:0:8}.tar.gz
		https://github.com/ScintillaOrg/lexilla/archive/refs/tags/rel-5-2-7.tar.gz -> lexilla-5.2.7.tar.gz"

RDEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-2.24:2
	vte? ( x11-libs/vte:0 )"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/intltool
	sys-devel/gettext
	sys-devel/patch
	virtual/pkgconfig"

S=${WORKDIR}/geany-${COMMIT}

pkg_setup() {
	strip-linguas ${LANGS}
}

src_prepare() {
	rmdir "${S}/lexilla" || die
	mv "${WORKDIR}/lexilla-rel-5-2-7" "${S}/lexilla" || die
	default

	# Syntax highlighting for Portage
	sed -i -e 's:*.sh;:*.sh;*.ebuild;*.eclass;:' data/filetype_extensions.conf || die

	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf --disable-dependency-tracking --docdir="${EPREFIX}/usr/share/doc/${PF}" \
			"$(use_enable vte)" "$(use_enable doc html-docs)"
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
