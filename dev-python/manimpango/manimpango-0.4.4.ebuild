# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A C binding for Pango using Cython"
HOMEPAGE="https://github.com/ManimCommunity/ManimPango https://pypi.org/project/manimpango"
SRC_URI="https://github.com/ManimCommunity/ManimPango/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug"

RDEPEND="
	dev-libs/glib:2
	media-libs/fontconfig
	x11-libs/cairo
	x11-libs/pango
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	x11-libs/pango
"
DEPEND="${BDEPEND}"

S=${WORKDIR}/ManimPango-${PV}

src_prepare() {
	rm -rf "${S}/tests" # ManimPango has to be installed for tests to work.
	distutils-r1_src_prepare
}
