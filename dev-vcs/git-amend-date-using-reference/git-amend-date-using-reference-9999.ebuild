# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KONSOLEBOX_SCRIPTS_EXT=bash
KONSOLEBOX_SCRIPTS_PREFIX=git/

inherit konsolebox-scripts

DESCRIPTION="Updates current commit's date using another commit's date as reference"
LICENSE="MIT"

RDEPEND="app-shells/bash dev-vcs/git"
