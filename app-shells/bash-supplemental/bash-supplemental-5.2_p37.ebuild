# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	bash-5.0-syslog-history-extern.patch
	bash-5.2_p15-random-ub.patch
	bash-5.2_p15-configure-clang16.patch
	bash-5.2_p21-wpointer-to-int.patch
	bash-5.2_p32-memory-leaks.patch
	bash-5.2_p32-invalid-continuation-byte-ignored-as-delimiter-1.patch
	bash-5.2_p32-invalid-continuation-byte-ignored-as-delimiter-2.patch
	bash-5.2_p32-erroneous-delimiter-pushback-condition.patch
)
_BASH_BUILD_PATCH_OPTIONS=(-p0)
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
