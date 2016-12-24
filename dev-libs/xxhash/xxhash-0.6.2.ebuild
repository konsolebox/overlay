# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils

DESCRIPTION='Extremely fast non-cryptographic hash algorithm'
HOMEPAGE='http://www.xxhash.com/'
SRC_URI="https://github.com/Cyan4973/xxHash/archive/v${PV}.tar.gz"
LICENSE=BSD-2
SLOT=0
KEYWORDS='~amd64 ~x86'
IUSE=
DEPEND=
RDEPEND=
S=${WORKDIR}/xxHash-${PV}/cmake_unofficial

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
