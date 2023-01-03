# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3 multilib-minimal

DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
HOMEPAGE="http://www.xxhash.com/"
LICENSE="BSD-2 GPL-2+"

EGIT_REPO_URI="https://github.com/Cyan4973/xxHash.git"
EGIT_BRANCH="dev"
SLOT=0
S=${WORKDIR}/xxhash-${PV}/cmake_unofficial

multilib_src_configure() {
	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	local bin

	for bin in xxh{32,64,128}sum; do
		ln -sf /usr/bin/xxhsum "${ED}/usr/bin/$bin" || die
		ln -sf /usr/share/man/man1/xxhsum.1.bz2 "${ED}/usr/share/man/man1/$bin.1.bz2" || die
	done
}
