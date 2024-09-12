# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="A tool for securing communications between a client and a DNS resolver"
HOMEPAGE="https://dnscrypt.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dyne/${PN}.git"
	EGIT_BRANCH=master
else
	COMMIT=71e5980bfd4134651a2f73f126d69964566605d0
	SRC_URI="https://github.com/dyne/${PN}/archive/${COMMIT}.tar.gz -> ${PN}-${PV%_p*}-${COMMIT:0:8}.tar.gz"
	S=${WORKDIR}/${PN}-${COMMIT}
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="hardened +plugins ssl systemd"
RESTRICT="mirror"

RDEPEND="
	acct-group/dnscrypt-proxy
	acct-user/dnscrypt-proxy
	dev-libs/libsodium:=
	net-libs/ldns
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
}

src_configure() {
	eautoreconf
	econf \
		--disable-static \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable hardened pie) \
		$(use_enable plugins) \
		$(use_enable ssl openssl) \
		$(use_with systemd)
}

src_install() {
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}.socket" "${PN}.socket"
	insinto /etc
	doins "${FILESDIR}/${PN}.conf" /etc
	dodoc AUTHORS ChangeLog NEWS README* THANKS *txt
}

pkg_preinst() {
	# ship working default configuration for systemd users
	if use systemd; then
		sed -i 's/Daemonize yes/Daemonize no/g' "${D}/etc/${PN}.conf"
	fi
}

pkg_postinst() {
	elog "After starting the service you will need to update your"
	elog "/etc/resolv.conf and replace your current set of resolvers"
	elog "with:"
	elog
	elog "nameserver 127.0.0.1"
	elog
	use systemd && elog "With systemd dnscrypt-proxy, ignores LocalAddress setting in the config file."
	use systemd && elog "Edit dnscrypt-proxy.socket if you need to change the defaults."
	elog
	elog "Also see https://github.com/jedisct1/dnscrypt-proxy#usage."
}
