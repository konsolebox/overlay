# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KONSOLEBOX_SCRIPTS_COMMIT="8839aae5a30a747a0e5d3bafe0d88f7c5cb08170"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Sends signals to process trees"
LICENSE="public-domain"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
RDEPEND="app-shells/bash sys-process/procps"
