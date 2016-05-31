# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

DESCRIPTION='Runs multiple instances of dnscrypt-proxy'
HOMEPAGE='https://github.com/konsolebox/scripts'
LICENSE='public-domain'

EGIT_REPO_URI='git://github.com/konsolebox/scripts.git'
SRC_URI=

SLOT=0
KEYWORDS=
IUSE=

DEPEND=
RDEPEND='
	=net-dns/dnscrypt-proxy-9999
	>=dev-lang/ruby-2:=
'

src_install() {
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	mv -- "${PN}.rb" "${PN}"
	dobin "${PN}"
}
