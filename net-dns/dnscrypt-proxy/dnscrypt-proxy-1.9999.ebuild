# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd user git-r3 autotools

DESCRIPTION="A tool for securing communications between a client and a DNS resolver"
HOMEPAGE="http://dnscrypt.org/"
LICENSE=ISC

SLOT=0
IUSE="plugins systemd"

CDEPEND="
	dev-libs/libsodium
	net-libs/ldns
	systemd? ( sys-apps/systemd )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND} virtual/pkgconfig"

EGIT_REPO_URI="https://github.com/konsolebox/${PN}.git"
EGIT_BRANCH=master

pkg_setup() {
	enewgroup dnscrypt
	enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --disable-static --docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable plugins) $(use_with systemd)
}

src_install() {
	default
	newinitd "${FILESDIR}/${PN}.initd-1.6.1" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd-1.6.0-r1" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	find "${D}" -name '*.la' -delete || die
	find "${D}" -name 'libdcplugin_example*' -delete || die
	dodoc AUTHORS ChangeLog NEWS README* THANKS *txt
}

pkg_postinst() {
	elog "After starting the service you will need to update your"
	elog "/etc/resolv.conf and replace your current set of resolvers"
	elog "with:"
	elog
	elog "nameserver <DNSCRYPT_LOCALIP>"
	elog
	elog "where <DNSCRYPT_LOCALIP> is what you supplied in"
	elog "/etc/conf.d/dnscrypt-proxy, default is \"127.0.0.1\"."
	elog
	elog "Also see https://github.com/jedisct1/dnscrypt-proxy#usage."
}
