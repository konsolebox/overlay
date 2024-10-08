# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_COMMIT="eb02ed3cce567edceeb8d00e657636960504e419"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Basically a wrapper for 'tail -f' and 'grep --line-buffered'"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
RDEPEND="app-shells/bash sys-apps/coreutils sys-apps/grep"
