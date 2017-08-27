# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION='chroot with more isolation'
HOMEPAGE='https://github.com/vincentbernat/jchroot'
COMMIT=17f549cffe973cf8b6ddc0e88d8061ba7bb87ca0

SRC_URI="https://github.com/vincentbernat/jchroot/archive/${COMMIT}.zip -> jchroot-${COMMIT}.zip"
S=${WORKDIR}/jchroot-${COMMIT}

LICENSE='ISC'
SLOT=0
KEYWORDS='amd64 arm ~x86'
IUSE=

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README.md
	doman "${PN}.8"
	dobin "${PN}"
}
