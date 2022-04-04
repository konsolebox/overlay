# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Finds library files based on expressions"
LICENSE="public-domain"
RDEPEND="app-shells/bash sys-apps/findutils"
