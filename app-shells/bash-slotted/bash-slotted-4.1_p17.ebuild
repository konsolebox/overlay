# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_READLINE_VER=6.2
_BASH_BUILD_INSTALL_TYPE=slotted
inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

PATCHES=(
	"${FILESDIR}"/bash-4.1-fbsd-eaccess.patch #303411
	"${FILESDIR}"/bash-4.1-parallel-build.patch
	"${FILESDIR}"/bash-4.2-dev-fd-buffer-overflow.patch #431850
)

src_prepare() {
	bash-build_src_prepare
	sed -i '1i#define NEED_FPURGE_DECL' execute_cmd.c || die # needs fpurge() decl
}

src_configure() {
	bash-build_src_configure --without-lispdir #335896
}
