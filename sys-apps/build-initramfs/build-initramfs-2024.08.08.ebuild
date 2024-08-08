# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KONSOLEBOX_SCRIPTS_COMMIT="8cc4a71c23fd0d7265510ea8437300915e7c5269"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Automates building of an initrd image"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RDEPEND=">=app-shells/bash-5 app-arch/cpio app-arch/xz-utils"
IUSE="nounset"
