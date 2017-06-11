# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='A console-based frontend for playing media'
HOMEPAGE='https://sourceforge.net/projects/playshell'
LICENSE='public-domain'

inherit git-r3
EGIT_REPO_URI='git://git.code.sf.net/p/playshell/code'
SRC_URI=

SLOT=0
KEYWORDS=
IUSE=

DEPEND='>=app-shells/bash-3.2:='
RDEPEND="${DEPEND} virtual/editor"
