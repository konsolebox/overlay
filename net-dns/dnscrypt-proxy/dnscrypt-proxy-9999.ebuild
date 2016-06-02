# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils systemd user git-r3 autotools

DESCRIPTION='A tool for securing communications between a client and a DNS resolver'
HOMEPAGE='http://dnscrypt.org/'
LICENSE='ISC'

EGIT_REPO_URI="https://github.com/jedisct1/${PN}"

SLOT=0
KEYWORDS=
IUSE='+plugins ldns systemd'

DEPEND='dev-libs/libsodium
	ldns? ( net-libs/ldns )'

RDEPEND="${DEPEND}
	systemd? ( sys-apps/systemd )"

DOCS=( AUTHORS ChangeLog COPYING NEWS README.markdown README-PLUGINS.markdown
	THANKS )

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable plugins) $(use_with systemd)
}

src_install() {
	default
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}
