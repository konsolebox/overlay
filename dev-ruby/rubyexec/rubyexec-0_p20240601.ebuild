# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Ruby binary selector"
HOMEPAGE="https://github.com/konsolebox/rubyexec"

COMMIT="2856a8270172de3dd3be28b401397247d2484ae3"
SRC_URI="https://raw.githubusercontent.com/konsolebox/${PN}/${COMMIT}/${PN}.c -> ${PN}-${COMMIT}.c"
S=${WORKDIR}

LICENSE="MIT"
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
RESTRICT="mirror"

src_unpack() {
	cp "${DISTDIR}/${PN}-${COMMIT}.c" "${WORKDIR}/${PN}.c" || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" rubyexec
}

src_install() {
	dobin rubyexec
}
