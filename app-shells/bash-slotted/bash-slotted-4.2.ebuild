# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=slotted
_BASH_BUILD_READLINE_VER=6.2
_BASH_BUILD_PATCHES=(
	"${FILESDIR}"/bash-4.2-execute-job-control.patch #383237
	"${FILESDIR}"/bash-4.2-parallel-build.patch
	"${FILESDIR}"/bash-4.2-no-readline.patch
	"${FILESDIR}"/bash-4.2-read-retry.patch #447810
	"${FILESDIR}"/bash-4.2-speed-up-read-N.patch
)

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
