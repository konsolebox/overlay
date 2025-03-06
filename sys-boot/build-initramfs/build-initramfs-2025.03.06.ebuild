# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_COMMIT="4d2c18c763231303438a2d336f82e227514fb836"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Automates building of an initrd image"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RDEPEND=">=app-shells/bash-5 app-arch/cpio app-arch/xz-utils"
