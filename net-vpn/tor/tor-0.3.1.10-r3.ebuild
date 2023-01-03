# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit readme.gentoo-r1 systemd versionator user

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
IUSE="chroot lzma scrypt seccomp selinux systemd test tor-hardening web zstd"
RESTRICT="!test? ( test )"

DEPEND="
	app-text/asciidoc
	dev-libs/libevent[ssl]
	sys-libs/zlib
	dev-libs/openssl:0=
	lzma? ( app-arch/xz-utils )
	scrypt? ( app-crypt/libscrypt )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd )
	zstd? ( app-arch/zstd )"
RDEPEND="${DEPEND}
	chroot? (
		app-portage/portage-utils
		sys-apps/findutils
		>=sys-apps/rcopy-2021.03.29
		sys-process/psmisc
		|| (
			app-alternatives/awk
			virtual/awk
		)
	)
	selinux? ( sec-policy/selinux-tor )"

DOCS=(README ChangeLog ReleaseNotes doc/HACKING)

pkg_setup() {
	enewgroup tor
	enewuser tor -1 -1 /var/lib/tor tor
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}/var" \
		--enable-system-torrc \
		--enable-asciidoc \
		--disable-libfuzzer \
		--disable-rust \
		$(use_enable lzma) \
		$(use_enable scrypt libscrypt) \
		$(use_enable seccomp) \
		$(use_enable systemd) \
		$(use_enable tor-hardening gcc-hardening) \
		$(use_enable tor-hardening linker-hardening) \
		$(use_enable web tor2web-mode) \
		$(use_enable test unittests) \
		$(use_enable test coverage) \
		$(use_enable zstd)
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
