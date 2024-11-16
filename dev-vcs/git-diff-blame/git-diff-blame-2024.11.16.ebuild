# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=rb
KONSOLEBOX_SCRIPTS_COMMIT=e6f1e4102531591fc381002ea536352bed0dca10
KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS=(ruby2{2..7} ruby3{0..4})
KONSOLEBOX_SCRIPTS_PREFIX=git/

inherit konsolebox-scripts

DESCRIPTION="Annotates each line in a diff hunk with author and commit information like blame"
LICENSE="Unlicense"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND+="
	dev-vcs/git
"
