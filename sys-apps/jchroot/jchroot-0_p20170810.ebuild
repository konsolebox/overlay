# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION='chroot with more isolation'
HOMEPAGE='https://github.com/vincentbernat/jchroot'
COMMIT=3ad09cca4879c27f7eef657b7fa1dd8b4f6aa47b

SRC_URI="https://github.com/vincentbernat/jchroot/archive/${COMMIT}.zip -> jchroot-${COMMIT}.zip"
S=${WORKDIR}/jchroot-${COMMIT}

LICENSE='ISC'
SLOT=0
KEYWORDS='~amd64 ~arm ~x86'
IUSE=

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README.md
	doman "${PN}.8"
	dobin "${PN}"
}
