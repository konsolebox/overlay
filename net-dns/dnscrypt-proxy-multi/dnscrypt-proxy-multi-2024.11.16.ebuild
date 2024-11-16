# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KONSOLEBOX_SCRIPTS_EXT=rb
KONSOLEBOX_SCRIPTS_COMMIT=d043cca6c5fb166386424a9f8031fbd4d93eb207
KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS=(ruby2{2..7} ruby3{0..4})

inherit konsolebox-scripts

DESCRIPTION="Runs multiple instances of dnscrypt-proxy"
[[ ${PV} != 9999 ]] && KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="public-domain"
IUSE+=" chroot"

RDEPEND+="
	>=net-dns/dnscrypt-proxy-1.7.0
	<net-dns/dnscrypt-proxy-2
	chroot? (
		app-alternatives/awk
		app-portage/portage-utils
		sys-apps/findutils
		sys-apps/rcopy
		sys-process/psmisc
	)
"

src_install() {
	konsolebox-scripts_src_install
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	if use chroot; then
		newconfd "${FILESDIR}/${PN}-chroot.confd" "${PN}-chroot"
		newinitd "${FILESDIR}/${PN}-chroot.initd" "${PN}-chroot"
	fi
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
