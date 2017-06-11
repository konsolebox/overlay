# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 toolchain-funcs

DESCRIPTION='chroot with more isolation'
HOMEPAGE='https://github.com/vincentbernat/jchroot'
EGIT_REPO_URI='https://github.com/vincentbernat/jchroot.git'

LICENSE='ISC'
SLOT=0
KEYWORDS=
IUSE=

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README.md
	doman "${PN}.8"
	dobin "${PN}"
}
