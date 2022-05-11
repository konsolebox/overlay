# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KONSOLEBOX_SCRIPTS_COMMIT="82505717a86c7a60b23d73f6b9257a44a67200c2"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Relatively copies binaries along with their dependencies to a directory"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="public-domain"
RDEPEND=">=app-shells/bash-4.0 sys-apps/coreutils sys-libs/glibc"
