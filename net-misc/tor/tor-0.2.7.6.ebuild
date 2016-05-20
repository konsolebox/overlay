# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic readme.gentoo systemd toolchain-funcs versionator user

MY_PV=$(replace_version_separator 4 -)
MY_PF=${PN}-${MY_PV}
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="http://www.torproject.org/"
SRC_URI="https://www.torproject.org/dist/${MY_PF}.tar.gz
	https://archive.torproject.org/tor-package-archive/${MY_PF}.tar.gz"
S=${WORKDIR}/${MY_PF}

LICENSE="BSD GPL-2"
SLOT=0
KEYWORDS="amd64 arm ~mips ppc ppc64 sparc x86 ~ppc-macos"
IUSE="-bufferevents libressl scrypt seccomp selinux stats systemd tor-hardening transparent-proxy test web"

DEPEND="
	app-text/asciidoc
	dev-libs/libevent
	sys-libs/zlib
	bufferevents? ( dev-libs/libevent[ssl] )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:= )
	scrypt? ( app-crypt/libscrypt )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-tor )"

pkg_setup() {
	enewgroup tor
	enewuser tor -1 -1 /var/lib/tor tor
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.2.7.4-torrc.sample.patch"
	epatch_user
}

src_configure() {
	# Upstream isn't sure of all the user provided CFLAGS that
	# will break tor, but does recommend against -fstrict-aliasing.
	# We'll filter-flags them here as we encounter them.
	filter-flags -fstrict-aliasing

	econf \
		--enable-system-torrc \
		--enable-asciidoc \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
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
	readme.gentoo_create_doc

	newconfd "${FILESDIR}"/tor.confd-konsolebox tor
	newinitd "${FILESDIR}"/tor.initd-konsolebox tor
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_dotmpfilesd "${FILESDIR}/${PN}.conf"

	emake DESTDIR="${D}" install

	keepdir /var/lib/tor

	dodoc README ChangeLog ReleaseNotes doc/HACKING

	fperms 750 /var/lib/tor
	fowners tor:tor /var/lib/tor

	insinto /etc/tor/
	newins "${FILESDIR}"/torrc-konsolebox torrc
}

pkg_postinst() {
	readme.gentoo_pkg_postinst

	einfo

	if has_version sys-apps/rcopy; then
		einfo "If you plan to run Tor as chroot, please install sys-apps/rcopy and see"
		einfo "/etc/conf.d/tor for details."
	else
		einfo "If you plan to run Tor as chroot, please see /etc/conf.d for details."
	fi

	einfo

	if [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -eq 8 && $(gcc-micro-version) -ge 1 ]] ; then
		ewarn "Due to a bug in  >=gcc-4.8.1, compiling ${P} with -Os leads to an infinite"
		ewarn "loop.  See:"
		ewarn
		ewarn "    https://trac.torproject.org/projects/tor/ticket/10259"
		ewarn "    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=59358"
		ewarn
	fi
}

_call() {
	"$@" || die "Command failed: $*"
}

_mknod() {
	local target mode
	target=$1 mode=$2
	shift 2

	if [ -e "${target}" ]; then
		if [ -c "${target}" ]; then
			ewarn "Skipping creation of ${target} as it already exists."
			return 0
		else
			eerror "${target} exists but is not a device node."
			return 1
		fi
	else
		_call mknod -m "${mode}" "${target}" "$@"
	fi
}

pkg_config() {
	if ! has_version sys-apps/rcopy; then
		eerror "Setting up chroot for Tor requires rcopy."
		eerror "Please install sys-apps/rcopy."
		return 1
	fi

	CHROOT=$(. /etc/conf.d/tor; echo "${CHROOT}")

	if [ -z "${CHROOT}" ]; then
		eerror "This config script prepares a chroot environment for Tor."
		eerror "Please set a value for 'CHROOT' in '/etc/conf.d/tor'."
		return 1
	fi

	if [ -d "${CHROOT}" ]; then
		ewarn "${CHROOT} already exists and some things might be overridden."
		ewarn "Press CTRL+C within 10 seconds if you don't want to continue."
		sleep 10
	fi

	echo
	ebegin "Setting up the chroot directory"

	local __

	for __ in '' /dev /etc/tor /usr/bin /var/lib/tor /var/tmp /tmp; do
		_call mkdir -p "${CHROOT}$__"
	done

	for __ in hosts host.conf localtime nsswitch.conf resolv.conf; do
		_call cp -- "/etc/$__" "${CHROOT}"/etc/
	done

	local libdir
	libdir=$(ldd /usr/bin/tor | awk -F/ '$1 ~ /=>/ && $2 ~ /^lib/ && NF > 2 { print $2; exit }')
	_call /usr/bin/rcopy -t "${CHROOT}" -- /usr/bin/tor "/${libdir}/libnss_compat.so."*

	grep --color=never ^tor: /etc/passwd > "${CHROOT}"/etc/passwd || die "Failed to create or update ${CHROOT}/etc/passwd."
	grep --color=never ^tor: /etc/group > "${CHROOT}"/etc/group || die "Failed to create or update ${CHROOT}/etc/group."

	_mknod "${CHROOT}"/dev/random 644 c 1 8 || return 1
	_mknod "${CHROOT}"/dev/urandom 644 c 1 9 || return 1
	_mknod "${CHROOT}"/dev/null 666 c 1 3 || return 1

	einfo "Done."
}
