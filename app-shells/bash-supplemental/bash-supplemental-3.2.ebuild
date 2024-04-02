# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	autoconf-mktime-2.59.patch #220040
	bash-3.2-loadables.patch
	bash-2.05b-parallel-build.patch #41002
	bash-3.2-protos.patch
	bash-3.2-session-leader.patch #231775
	bash-3.2-ldflags-for-build.patch #211947
	bash-3.2-process-subst.patch
	bash-3.2-ulimit.patch
	bash-3.0-trap-fg-signals.patch
	bash-3.2-dev-fd-test-as-user.patch #131875
	bash-4.2-dev-fd-buffer-overflow.patch #431850
)
_BASH_BUILD_USE_ARCHIVED_PATCHES=true
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
