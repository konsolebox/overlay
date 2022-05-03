# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Basically a wrapper for 'tail -f' and 'grep --line-buffered'"
LICENSE="MIT"
RDEPEND="app-shells/bash sys-apps/coreutils sys-apps/grep sys-fs/inotify-tools"
