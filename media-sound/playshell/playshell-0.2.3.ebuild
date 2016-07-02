# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION='A console-based frontend for playing media'
HOMEPAGE='https://sourceforge.net/projects/playshell'
LICENSE='public-domain'

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT=0
KEYWORDS='~amd64 ~x86'
IUSE=''

DEPEND='>=app-shells/bash-3.2:='
RDEPEND="${DEPEND} virtual/editor"

src_install() {
	emake DESTDIR="${D}" install
	dodoc Readme.txt ChangeLog.txt
}
