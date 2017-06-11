# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils systemd user

DESCRIPTION='BitTorrent Client using libtorrent'
HOMEPAGE='https://rakshasa.github.io/rtorrent/'
SRC_URI="http://rtorrent.net/downloads/${P}.tar.gz"

LICENSE=GPL-2
SLOT=0
KEYWORDS='~amd64 ~arm ~x86'
IUSE='chroot daemon debug ipv6 selinux test xmlrpc'

COMMON_DEPEND="~net-libs/libtorrent-0.13.${PV##*.}
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses:0=
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )
	chroot? (
		sys-apps/jchroot
		sys-apps/rcopy
		sys-process/psmisc
		virtual/awk
	)
	selinux? ( sec-policy/selinux-rtorrent )
"
DEPEND="${COMMON_DEPEND}
	dev-util/cppunit
	virtual/pkgconfig"
REQUIRED_USE="chroot? ( daemon )"

DOCS=( doc/rtorrent.rc )

pkg_setup() {
	if use daemon; then
		enewgroup rtorrent
		enewuser rtorrent -1 -1 /var/lib/rtorrent rtorrent
	fi
}

src_prepare() {
	# bug #358271
	epatch \
		"${FILESDIR}"/${PN}-0.9.1-ncurses.patch \
		"${FILESDIR}"/${PN}-0.9.4-tinfo.patch

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	eautoreconf
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default
	doman doc/rtorrent.1

	if use daemon; then
		newinitd "${FILESDIR}/rtorrent.init" rtorrent
		newconfd "${FILESDIR}/rtorrent.conf" rtorrent
		systemd_newunit "${FILESDIR}/rtorrent_at.service" "rtorrent@.service"

		if use chroot; then
			newinitd "${FILESDIR}/rtorrent-chroot.init" rtorrent-chroot
			newconfd "${FILESDIR}/rtorrent-chroot.conf" rtorrent-chroot
		fi
	fi
}

pkg_postinst() {
	if use daemon; then
		if use chroot; then
			einfo "If you plan to run rtorrent daemon in chroot mode, configure"
			einfo "'/etc/conf.d/rtorrent-chroot', and run"
			einfo "'/etc/init.d/rtorrent-chroot setup'."
		else
			einfo "If you plan to run rtorrent daemon in chroot mode, please enable"
			einfo "'chroot' use flag."
		fi
	fi
}
