# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=rb
KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS=(ruby2{2..7} ruby3{0..4})
KONSOLEBOX_SCRIPTS_TEST=hyphenate.test.rb
KONSOLEBOX_SCRIPTS_TEST_DEPENDENCIES=(test-unit)

inherit konsolebox-scripts

DESCRIPTION="Renames files and directories to the hyphenated version of their filenames"
LICENSE="MIT"
