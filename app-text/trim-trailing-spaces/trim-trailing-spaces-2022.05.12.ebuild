# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KONSOLEBOX_SCRIPTS_COMMIT="684211752678c445a4ca1c1dd974d0ce93946e9d"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Removes trailing spaces in files"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
RDEPEND="app-shells/bash sys-apps/coreutils sys-apps/findutils sys-apps/grep sys-apps/sed"
