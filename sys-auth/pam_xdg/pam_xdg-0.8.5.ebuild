# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal pam toolchain-funcs

DESCRIPTION="PAM module that manages XDG Base Directories"
HOMEPAGE="https://sdaoden.eu/code.html#s-toolbox"
SRC_URI="https://ftp.sdaoden.eu/${P}.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
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
	local DEFAULT_CFLAGS DEFAULT_LDFLAGS IFS=' '

	DEFAULT_CFLAGS=(
		-DNDEBUG -O2 -W -Wall -Wextra -pedantic -Wno-uninitialized -Wno-unused-result
		-Wno-unused-value -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-common
		-fstrict-aliasing -fstrict-overflow -fstack-protector-strong -D_FORTIFY_SOURCE=3
		-fcf-protection=full -fPIE -fPIC
	)

	DEFAULT_LDFLAGS=(
		-Wl,-z,relro -Wl,-z,now -Wl,-z,noexecstack -Wl,--as-needed -Wl,--enable-new-dtags -pie
		-fPIE -fPIC -shared
	)

	emake V=1 CC="$(tc-getCC)" \
			CFLAGS="-U_FORTIFY_SOURCE ${DEFAULT_CFLAGS[*]} ${CFLAGS-}" \
			LDFLAGS="${DEFAULT_LDFLAGS[*]} ${LDFLAGS-}" \
			LDLIBS="${LDLIBS}" \
			"${PN}.so"
}

multilib_src_install() {
	dopammod "${PN}.so"
}

multilib_src_install_all() {
	doman "${PN}.8"
}
