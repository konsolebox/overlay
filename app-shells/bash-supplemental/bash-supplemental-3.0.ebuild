# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_READLINE_VER=6.2
_BASH_BUILD_PATCHES=(
	"${FILESDIR}"/autoconf-mktime-2.53.patch #220040
	"${FILESDIR}"/bash-3.0-protos.patch
	"${FILESDIR}"/bash-3.0-rbash.patch #26854
	"${FILESDIR}"/bash-2.05b-parallel-build.patch #41002
	"${FILESDIR}"/bash-3.0-darwin-conn.patch #79124
	# read patch headers for more info ... many ripped from Fedora"/Debian[17]"/SuSe"/upstream
	"${FILESDIR}"/bash-3.0-{afs,crash,jobs,manpage,pwd,ulimit,histtimeformat,locale,multibyteifs,subshell,volatile-command}.patch
	"${FILESDIR}"/bash-3.0-read-builtin-pipe.patch #87093
	"${FILESDIR}"/bash-3.0-trap-fg-signals.patch
	"${FILESDIR}"/bash-3.0-pgrp-pipe-fix.patch #92349
	"${FILESDIR}"/bash-3.0-strnlen.patch
	"${FILESDIR}"/bash-3.1-dev-fd-buffer-overflow.patch #431850
)

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
