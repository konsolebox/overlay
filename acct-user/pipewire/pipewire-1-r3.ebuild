# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for running PipeWire as a system-wide instance"
ACCT_USER_ID=509
ACCT_USER_GROUPS=( pipewire audio )
ACCT_USER_HOME=/var/lib/pipewire

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

acct-user_add_deps
