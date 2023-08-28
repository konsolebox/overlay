# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KONSOLEBOX_SCRIPTS_EXT=rb
KONSOLEBOX_SCRIPTS_COMMIT=477a405477544fbfa71cb7289e08e335431024e6
KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS=(ruby2{6..7} ruby3{0..2})
KONSOLEBOX_SCRIPTS_RUBY_DEPENDENCIES=(digest-kangarootwelve)

inherit konsolebox-scripts

DESCRIPTION="Renames files and directories based on their 160-bit KangarooTwelve checksum"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
LICENSE="MIT"
