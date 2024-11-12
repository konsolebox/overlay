# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	autoconf-mktime-2.53.patch #220040
	bash-3.0-protos.patch
	bash-3.0-rbash.patch #26854
	bash-2.05b-parallel-build.patch #41002
	bash-3.0-darwin-conn.patch #79124
	# read patch headers for more info ... many ripped from Fedora"/Debian[17]"/SuSe"/upstream
	bash-3.0-{afs,crash,jobs,manpage,pwd,ulimit,histtimeformat,locale,multibyteifs,subshell,volatile-command}.patch
	bash-3.0-read-builtin-pipe.patch #87093
	bash-3.0-trap-fg-signals.patch
	bash-3.0-pgrp-pipe-fix.patch #92349
	bash-3.0-strnlen.patch
	bash-3.1-dev-fd-buffer-overflow.patch #431850
)
_BASH_BUILD_USE_ARCHIVED_PATCHES=true
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
