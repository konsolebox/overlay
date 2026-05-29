# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 multilib-minimal

DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
HOMEPAGE="http://www.xxhash.com/"
EGIT_REPO_URI="https://github.com/Cyan4973/xxHash.git"
EGIT_BRANCH="dev"
S=${WORKDIR}/xxhash-${PV}/build/cmake
LICENSE="BSD-2 GPL-2+"
SLOT=0

multilib_src_configure() {
	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install
}

multilib_src_install_all() {
	local bin

	for bin in xxh{32,64,128,3}sum; do
		ln -sf xxhsum "${ED}/usr/bin/${bin}" || die
		ln -sf xxhsum.1.bz2 "${ED}/usr/share/man/man1/${bin}.1.bz2" || die
	done
}
