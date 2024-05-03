# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Ruby binary selector"
HOMEPAGE="https://github.com/konsolebox/rubyexec"
LICENSE="MIT"

SLOT=0
COMMIT="c9a952f739dd82955734b44ffbb4209a7e9f21b0"
SRC_URI="https://raw.githubusercontent.com/konsolebox/${PN}/${COMMIT}/${PN}.c -> ${PN}-${COMMIT}.c"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${PN}-${COMMIT}.c" "${WORKDIR}/${PN}.c" || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" rubyexec
}

src_install() {
	dobin rubyexec
}
