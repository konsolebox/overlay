# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_READLINE_VER=7.0
_BASH_BUILD_INSTALL_TYPE=system
inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

PATCHES=(
	"${FILESDIR}"/bash-4.4-jobs_overflow.patch #644720
	"${FILESDIR}"/bash-4.4-set-SHOBJ_STATUS.patch #644720
)
