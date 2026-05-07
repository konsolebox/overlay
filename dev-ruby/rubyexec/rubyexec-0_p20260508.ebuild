# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Ruby binary selector"
HOMEPAGE="https://github.com/konsolebox/rubyexec"

COMMIT="f8abaf68594ba51a4183f06649e25c06cd8d4f7e"
SRC_URI="https://raw.githubusercontent.com/konsolebox/${PN}/${COMMIT}/${PN}.c -> ${PN}-${COMMIT}.c"
S=${WORKDIR}

LICENSE="MIT"
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
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
