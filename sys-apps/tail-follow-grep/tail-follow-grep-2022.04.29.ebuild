# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KONSOLEBOX_SCRIPTS_COMMIT="f68b6af8d69f72dfb9070bf6cebfb1aef814ba85"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Basically a wrapper for 'tail -f' and 'grep --line-buffered'"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
RDEPEND="app-shells/bash sys-apps/coreutils sys-apps/grep"
