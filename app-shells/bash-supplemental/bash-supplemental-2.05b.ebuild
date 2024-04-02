# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	bash-2.05b-destdir.patch
	autoconf-mktime-2.53.patch #220040
	bash-2.05b-protos.patch
	bash-2.05b-empty-herestring.patch
	bash-2.05b-rbash.patch #26854
	bash-2.05b-parallel-build.patch #41002
	bash-2.05b-jobs.patch
	bash-2.05b-fix-job-warning.patch
	bash-3.1-dev-fd-buffer-overflow.patch #431850
)
_BASH_BUILD_USE_ARCHIVED_PATCHES=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
