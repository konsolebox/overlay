# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic readme.gentoo-r1 systemd versionator user

MY_PV=$(replace_version_separator 4 -)
MY_PF=tor-${MY_PV}
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="http://www.torproject.org/"
SRC_URI="https://www.torproject.org/dist/${MY_PF}.tar.gz
	https://archive.torproject.org/tor-package-archive/${MY_PF}.tar.gz"
S=${WORKDIR}/${MY_PF}

LICENSE="BSD GPL-2"
SLOT=0
KEYWORDS="~amd64 ~arm ~x86"
IUSE="-bufferevents chroot libressl scrypt seccomp selinux stats systemd test tor-hardening transparent-proxy web"

DEPEND="
	app-text/asciidoc
	dev-libs/libevent
	sys-libs/zlib
	bufferevents? ( dev-libs/libevent[ssl] )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	scrypt? ( app-crypt/libscrypt )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}
	chroot? (
		app-portage/portage-utils
		sys-apps/findutils
		sys-apps/rcopy
		sys-process/psmisc
		virtual/awk
	)
	selinux? ( sec-policy/selinux-tor )"

DOCS=(README ChangeLog ReleaseNotes doc/HACKING)

pkg_setup() {
	enewgroup tor
	enewuser tor -1 -1 /var/lib/tor tor
}

src_configure() {
	# Upstream isn't sure of all the user provided CFLAGS that
	# will break tor, but does recommend against -fstrict-aliasing.
	# We'll filter-flags them here as we encounter them.
	filter-flags -fstrict-aliasing

	econf \
		--enable-system-torrc \
		--enable-asciidoc \
		$(use_enable stats instrument-downloads) \
		$(use_enable bufferevents) \
		$(use_enable scrypt libscrypt) \
		$(use_enable seccomp) \
		$(use_enable systemd) \
		$(use_enable tor-hardening gcc-hardening) \
		$(use_enable tor-hardening linker-hardening) \
		$(use_enable transparent-proxy transparent) \
		$(use_enable web tor2web-mode) \
		$(use_enable test unittests) \
		$(use_enable test coverage)
}

src_install() {
	default
	readme.gentoo_create_doc

	newconfd "${FILESDIR}"/0.2.8.9/tor.confd tor
	newinitd "${FILESDIR}"/0.2.8.9/tor.initd tor

	if use chroot; then
		newconfd "${FILESDIR}"/0.2.8.9/tor-chroot.confd tor-chroot
		newinitd "${FILESDIR}"/0.2.8.9/tor-chroot.initd tor-chroot
	fi

	systemd_dounit "${FILESDIR}"/0.2.8.9/tor.service

	keepdir /var/lib/tor
	fperms 750 /var/lib/tor
	fowners tor:tor /var/lib/tor

	insinto /etc/tor/
	newins "${FILESDIR}"/0.2.8.9/torrc torrc
	newins "${FILESDIR}"/0.2.8.9/torrc.notes torrc.notes
}

pkg_postinst() {
	readme.gentoo_print_elog
}
