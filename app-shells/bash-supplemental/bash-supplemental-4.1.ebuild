# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	bash-4.1-fbsd-eaccess.patch #303411
	bash-4.1-parallel-build.patch
	bash-4.2-dev-fd-buffer-overflow.patch #431850
)
_BASH_BUILD_USE_ARCHIVED_PATCHES=true
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

src_prepare() {
	bash-build_src_prepare
	sed -i '1i#define NEED_FPURGE_DECL' execute_cmd.c || die # needs fpurge() decl
}

src_configure() {
	bash-build_src_configure --without-lispdir #335896
}
