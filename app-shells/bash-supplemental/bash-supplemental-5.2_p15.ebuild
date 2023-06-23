# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BASH_BUILD_INSTALL_TYPE=supplemental
BASH_BUILD_READLINE_VER=8.2
BASH_BUILD_PATCHES=(bash-5.0-syslog-history-extern.patch)
BASH_BUILD_PATCH_OPTIONS=(-p0)
BASH_BUILD_USE_ARCHIVED_PATCHES=false

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
