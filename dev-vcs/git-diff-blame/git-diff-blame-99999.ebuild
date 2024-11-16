# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=rb
KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS=(ruby2{2..7} ruby3{0..4})
KONSOLEBOX_SCRIPTS_PREFIX=git/
inherit konsolebox-scripts

DESCRIPTION="Annotates each line in a diff hunk with author and commit information like blame"
LICENSE="Unlicense"

RDEPEND+="
	dev-vcs/git
"
