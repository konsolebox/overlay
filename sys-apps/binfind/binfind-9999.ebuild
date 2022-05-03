# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Searches files based on the value of \$PATH"
LICENSE="public-domain"
RDEPEND="app-shells/bash !app-text/binfind sys-apps/findutils"
IUSE="nounset"
