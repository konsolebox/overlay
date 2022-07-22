# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KONSOLEBOX_SCRIPTS_EXT=rb
inherit konsolebox-scripts

DESCRIPTION="Renames files and directories based on their 160-bit KangarooTwelve checksum"
LICENSE="MIT"
RDEPEND="dev-lang/ruby dev-ruby/digest-kangarootwelve"
