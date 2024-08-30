# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal pam toolchain-funcs

DESCRIPTION="PAM module that defines DBUS_SESSION_BUS_ADDRESS"
HOMEPAGE="https://github.com/konsolebox/pam_dsba"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/konsolebox/${PN}.git"
	EGIT_BRANCH=master
else
	COMMIT=bba55900f54df80cc1ee35618be6e0386e43c4e5
	SRC_URI="https://github.com/konsolebox/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
BDEPEND="sys-libs/pam"
RDEPEND="${BDEPEND}"
RESTRICT="mirror"

pkg_setup() {
	export LDLIBS="$(pkg-config --libs pam) ${LDLIBS-}"
}

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="-fPIC ${CFLAGS-}" LDFLAGS="-shared ${LDFLAGS-}" LDLIBS="${LDLIBS}" "${PN}.so"
}

multilib_src_install() {
	dopammod "${PN}.so"
}
