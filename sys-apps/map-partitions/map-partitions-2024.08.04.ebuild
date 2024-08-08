# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KONSOLEBOX_SCRIPTS_COMMIT="e7192b2f5d796506a0b56b1f98f137ea9bee6acb"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Maps partitions in a block device to logical devices using dmsetup and sfdisk"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
RDEPEND=">=app-shells/bash-3.2 sys-apps/util-linux"
IUSE="nounset"
