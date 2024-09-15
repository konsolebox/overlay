# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Maps partitions in a block device to logical devices using dmsetup and sfdisk"
LICENSE="MIT"
RDEPEND=">=app-shells/bash-3.2 sys-apps/util-linux"
IUSE="nounset"
