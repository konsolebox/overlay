# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_COMMIT="14a44c85505e72a23bc4e2f469d7a4abcc3e018f"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Finds entries in ~/.bash_history"
LICENSE="public-domain"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
RDEPEND="sys-apps/gawk"
