# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BASH_BUILD_INSTALL_TYPE=system
BASH_BUILD_READLINE_VER=6.3
BASH_BUILD_PATCHES=(
	bash-4.3-mapfile-improper-array-name-validation.patch
	bash-4.3-arrayfunc.patch
	bash-4.3-protos.patch
	bash-4.4-popd-offset-overflow.patch #600174
)
BASH_BUILD_USE_ARCHIVED_PATCHES=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
