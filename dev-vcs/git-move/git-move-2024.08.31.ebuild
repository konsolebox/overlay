# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KONSOLEBOX_SCRIPTS_EXT=bash
KONSOLEBOX_SCRIPTS_COMMIT=46319c555015e164aa224370a0c95737342223fe
KONSOLEBOX_SCRIPTS_PREFIX=git/

inherit konsolebox-scripts

DESCRIPTION="Moves commits in a context to a new base commit within the same context"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="app-shells/bash dev-vcs/git"
