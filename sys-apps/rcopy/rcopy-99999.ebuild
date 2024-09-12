# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Relatively copies binaries along with their dependencies to a directory"
LICENSE="public-domain"
RDEPEND=">=app-shells/bash-4.0 sys-apps/coreutils sys-libs/glibc"
IUSE="nounset"
