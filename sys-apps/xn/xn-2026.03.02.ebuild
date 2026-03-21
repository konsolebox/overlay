# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=rb
KONSOLEBOX_SCRIPTS_COMMIT=c98560bda0826b7e35d94628b3267f14411cc28a
KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS=(ruby2{2..7} ruby3{0..4} ruby40)
KONSOLEBOX_SCRIPTS_RUBY_DEPENDENCIES=(digest-kangarootwelve)

inherit konsolebox-scripts

DESCRIPTION="Renames files and directories based on their 160-bit KangarooTwelve checksum"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"
