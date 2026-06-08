# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

_BASH_BUILD_INSTALL_TYPE=system
_BASH_BUILD_ALLOW_BASH_SOURCE_FULLPATH_DEFAULT=true
_BASH_BUILD_ETC_VERSION=2
_BASH_BUILD_PATCHES=(
	bash-5.0-syslog-history-extern.patch
	bash-5.3_p9-general-workaround-aliasing-violation-in-REVERSE_LIS.patch
	bash-5.3_p9-pid-reuse.patch
)
_BASH_BUILD_PATCH_OPTIONS=(-p0)
_BASH_BUILD_READLINE_VER=8.3
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
