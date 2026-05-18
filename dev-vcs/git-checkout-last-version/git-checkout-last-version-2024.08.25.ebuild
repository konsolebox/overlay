# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KONSOLEBOX_SCRIPTS_EXT=bash
KONSOLEBOX_SCRIPTS_COMMIT=d59ac4793a95c889039199ba51f3f7a01e36c11d
KONSOLEBOX_SCRIPTS_PREFIX=git/

inherit konsolebox-scripts

DESCRIPTION="Extracts the last version of a file before it was removed from git"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="app-shells/bash dev-vcs/git"
