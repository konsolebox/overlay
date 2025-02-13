# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=system
_BASH_BUILD_ALLOW_BASH_SOURCE_FULLPATH_DEFAULT=true
_BASH_BUILD_ETC_VERSION=1
_BASH_BUILD_PATCH_OPTIONS=(-p0)
_BASH_BUILD_PATCHES=(bash-5.0-syslog-history-extern.patch)
_BASH_BUILD_READLINE_VER=8.3_alpha
_BASH_BUILD_SNAPSHOT_COMMIT=c3ca11424d2ae66cafa2f931b008dfb728e209a5

inherit bash-build

RESTRICT="mirror"
