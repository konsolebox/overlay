# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools edo strip-linguas xdg

LANGS="ar ast be bg ca cs de el en_GB es et eu fa fi fr gl he hi hu id it ja kk ko lb lt mn nl nn
		pl pt pt_BR ro ru sk sl sr sv tr uk vi zh_CN ZH_TW"
NOSHORTLANGS="en_GB zh_CN zh_TW"

DESCRIPTION="GTK+ based fast and lightweight IDE"
HOMEPAGE="https://www.geany.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/konsolebox/geany.git"
	EGIT_BRANCH=master
else
	COMMIT=225bd3a560d96a46acd722b92a37085c5ca55018
	LEXILLA_VERSION=5.4.1
	LEXILLA_TAG=rel-${LEXILLA_VERSION//./-}
	SRC_URI="
		https://github.com/konsolebox/geany/archive/${COMMIT}.tar.gz -> ${P/_p/-konsolebox-}-${COMMIT:0:8}.tar.gz
		https://github.com/ScintillaOrg/lexilla/archive/refs/tags/${LEXILLA_TAG}.tar.gz ->
				lexilla-${LEXILLA_VERSION}.tar.gz
	"
	S=${WORKDIR}/geany-${COMMIT}
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-2+ HPND"
SLOT=0
IUSE="doc konsolebox +vte"
REQUIRED_USE="konsolebox"
RESTRICT="mirror"

RDEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-2.24:2
	vte? ( x11-libs/vte:0 )"
DEPEND="${RDEPEND}
	doc? ( dev-python/docutils )
	dev-util/glib-utils
	dev-util/intltool
	sys-devel/gettext
	sys-devel/patch
	virtual/pkgconfig"

pkg_setup() {
	strip-linguas ${LANGS}
}

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		edo rmdir "${S}/lexilla"
		edo mv "${WORKDIR}/lexilla-${LEXILLA_TAG}" "${S}/lexilla"
	fi

	default

	# Syntax highlighting for Portage
	edo sed -i -e 's:*.sh;:*.sh;*.ebuild;*.eclass;:' data/filetype_extensions.conf

	eautoreconf
}

src_configure() {
	econf --docdir="${EPREFIX}/usr/share/doc/${PF}" \
			"$(use_enable doc html-docs)" \
			"$(use_enable vte)" \
			--disable-api-docs \
			--disable-dependency-tracking \
			--disable-pdf-docs
}

src_install() {
	emake DESTDIR="${D}" DOCDIR="${D}/usr/share/doc/${PF}" install
	edo rm -f "${D}/usr/share/doc/${PF}/"{COPYING,GPL-2,ScintillaLicense.txt}
	edo find "${D}" -name '*.la' -delete
}
