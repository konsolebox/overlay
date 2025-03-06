# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Shows or modifies Bash's history data"
LICENSE="public-domain"
RDEPEND="sys-apps/gawk"
IUSE="nounset"
