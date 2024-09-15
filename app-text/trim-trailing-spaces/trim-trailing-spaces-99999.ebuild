# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Removes trailing spaces in files"
LICENSE="MIT"
RDEPEND="app-shells/bash sys-apps/coreutils sys-apps/findutils sys-apps/grep sys-apps/sed"
IUSE="nounset"
