# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edo

DESCRIPTION="Convert a .deb file to a .tar.gz archive"
HOMEPAGE="http://www.miketaylor.org.uk/tech/deb/"

SRC_URI="http://www.miketaylor.org.uk/tech/deb/${PN}"
S=${WORKDIR}

LICENSE="public-domain"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"

RDEPEND="dev-lang/perl"

PATCHES=("${FILESDIR}/${P}-any-data-r1.patch") # Includes fix for bug #911878

src_unpack() {
	edo cp "${DISTDIR}/${PN}" "${S}"
}

src_install() {
	dobin "${PN}"
}
