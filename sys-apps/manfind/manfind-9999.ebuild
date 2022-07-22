# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Searches for manual pages based on \$MANPATH"
LICENSE="public-domain"
RDEPEND="app-shells/bash sys-apps/findutils"
IUSE="nounset"
