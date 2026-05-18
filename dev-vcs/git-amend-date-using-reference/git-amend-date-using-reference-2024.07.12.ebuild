# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KONSOLEBOX_SCRIPTS_EXT=bash
KONSOLEBOX_SCRIPTS_COMMIT=42a9c0947dff73988ffcd93a994d9fe006d366ea
KONSOLEBOX_SCRIPTS_PREFIX=git/

inherit konsolebox-scripts

DESCRIPTION="Updates current commit's date using another commit's date as reference"
LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="app-shells/bash dev-vcs/git"
