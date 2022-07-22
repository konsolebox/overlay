# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Runs multiple instances of dnscrypt-proxy"
HOMEPAGE="https://github.com/konsolebox/scripts"
LICENSE="public-domain"

SLOT=0
IUSE="chroot"

RDEPEND="
	>=net-dns/dnscrypt-proxy-1.7.0
	<net-dns/dnscrypt-proxy-2
	>=dev-lang/ruby-2:=
	chroot? (
		app-portage/portage-utils
		sys-apps/findutils
		sys-apps/rcopy
		sys-process/psmisc
		virtual/awk
	)
"

EGIT_REPO_URI="https://github.com/konsolebox/scripts.git"
EGIT_BRANCH=master

src_install() {
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	if use chroot; then
		newconfd "${FILESDIR}/${PN}-chroot.confd" "${PN}-chroot"
		newinitd "${FILESDIR}/${PN}-chroot.initd" "${PN}-chroot"
	fi

	mv -- "${PN}.rb" "${PN}"
	dobin "${PN}"
}

pkg_postinst() {
	einfo ""

	if use chroot; then
		einfo "If you plan to run dnscrypt-proxy-multi in chroot mode, configure"
		einfo "/etc/conf.d/dnscrypt-proxy-multi-chroot, and run"
		einfo "/etc/init.d/dnscrypt-proxy-multi-chroot setup."
	else
		einfo "If you plan to run dnscrypt-proxy-multi in chroot mode, please enable"
		einfo "'chroot' use flag."
	fi

	einfo ""
}
