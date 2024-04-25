# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Notification daemon"
HOMEPAGE="https://gitlab.gnome.org/Archive/notification-daemon"

EGIT_REPO_URI="https://gitlab.gnome.org/Archive/${PN}.git"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
IUSE="auto-remove-old-notifications max-notifications-99 konsolebox"
REQUIRED_USE="
	auto-remove-old-notifications? ( konsolebox )
	max-notifications-99? ( konsolebox )
"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-3.19.5:3[X]
	sys-apps/dbus
	x11-libs/libX11
	!x11-misc/notify-osd
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

DOCS=(AUTHORS ChangeLog NEWS)

src_unpack() {
	use konsolebox && EGIT_REPO_URI="https://github.com/konsolebox/${PN}.git"
	git-r3_src_unpack
}

src_configure() {
	use konsolebox && eautoreconf
	econf "$(use_enable auto-remove-old-notifications)" "$(use_enable max-notifications-99)" \
			--disable-Werror
}

src_install() {
	default

	insinto /usr/share/dbus-1/services
	newins <<'EOF' - org.freedesktop.Notifications.service
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=/usr/libexec/notification-daemon
EOF
}
