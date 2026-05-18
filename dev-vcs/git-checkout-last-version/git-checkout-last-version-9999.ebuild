# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KONSOLEBOX_SCRIPTS_EXT=bash
KONSOLEBOX_SCRIPTS_PREFIX=git/

inherit konsolebox-scripts

DESCRIPTION="Extracts the last version of a file before it was removed from git"
LICENSE="MIT"

RDEPEND="app-shells/bash dev-vcs/git"
