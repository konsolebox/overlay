# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_READLINE_VER=6.2
_BASH_BUILD_INSTALL_TYPE=slotted
inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

PATCHES=(
	"${FILESDIR}"/autoconf-mktime-2.59.patch #220040
	"${FILESDIR}"/bash-3.2-loadables.patch
	"${FILESDIR}"/bash-2.05b-parallel-build.patch #41002
	"${FILESDIR}"/bash-3.2-protos.patch
	"${FILESDIR}"/bash-3.2-session-leader.patch #231775
	"${FILESDIR}"/bash-3.2-ldflags-for-build.patch #211947
	"${FILESDIR}"/bash-3.2-process-subst.patch
	"${FILESDIR}"/bash-3.2-ulimit.patch
	"${FILESDIR}"/bash-3.0-trap-fg-signals.patch
	"${FILESDIR}"/bash-3.2-dev-fd-test-as-user.patch #131875
	"${FILESDIR}"/bash-4.2-dev-fd-buffer-overflow.patch #431850
)
