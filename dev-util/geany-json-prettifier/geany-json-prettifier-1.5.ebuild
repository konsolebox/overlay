# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit call toolchain-funcs

DESCRIPTION="A JSON formatter prettifier, minifier and validator plugin for Geany editor"
HOMEPAGE="https://plugins.geany.org/jsonprettifier.html"

MY_PN=Geany-JSON-Prettifier
MY_P=${MY_PN}-${PV}

SRC_URI="https://github.com/zhgzhg/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2+"
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-util/geany"
BDEPEND="
	${RDEPEND}
	app-shells/bash
	dev-build/cmake
	virtual/pkgconfig
"

RESTRICT="mirror"

src_configure() {
	( cd ./lloyd-yajl-66cb08c && call "${BROOT}/bin/bash" ./configure -p "${EPREFIX}/usr" ) || die
	cp ./lloyd-yajl-66cb08c/src/api/yajl_common.h \
			./lloyd-yajl-66cb08c/build/yajl-2.1.0/include/yajl || die
}

src_compile() {
	local CC=$(tc-getCC) LD=$(tc-getLD) geany_cflags geany_libs

	geany_cflags=$(pkg-config --cflags geany) && [[ ${geany_cflags} ]] || \
		die "Failed to get Geany CFLAGS."
	geany_libs=$(pkg-config --libs geany) && [[ ${geany_libs} ]] || \
		die "Failed to get Geany linker flags."

	emake -C ./lloyd-yajl-66cb08c CC="${CC}" CFLAGS="${CFLAGS}" distro || die

	call "${CC}" '-DLOCALEDIR=""' '-DGETTEXT_PACKAGE="zhgzhg"' -c ./geany_json_prettifier.c -fPIC \
			${geany_cflags} ${CFLAGS} || die
	call "${LD}" geany_json_prettifier.o -o jsonprettifier.so \
			"./lloyd-yajl-66cb08c/build/yajl-2.1.0/lib/libyajl_s.a" -shared ${geany_libs} || die
}

src_install() {
	insopts -m 755
	insinto "/usr/$(get_libdir)/geany"
	doins jsonprettifier.so
}
