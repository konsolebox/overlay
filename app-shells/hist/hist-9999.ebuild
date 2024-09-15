# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Finds entries in ~/.bash_history"
LICENSE="public-domain"
RDEPEND="sys-apps/gawk"
IUSE="nounset"
