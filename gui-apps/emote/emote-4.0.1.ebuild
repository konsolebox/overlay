# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit meson python-single-r1 xdg

DESCRIPTION="A modern emoji picker for Linux"
HOMEPAGE="https://github.com/tom-james-watson/Emote"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tom-james-watson/Emote.git"
else
	SRC_URI="https://github.com/tom-james-watson/Emote/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/Emote-${PV}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '>=dev-python/dbus-python-1.2.18[${PYTHON_USEDEP}]
			>=dev-python/manimpango-0.4.3[${PYTHON_USEDEP}]
			>=dev-python/setproctitle-1.3.2[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]')
	dev-libs/keybinder
	media-fonts/noto-emoji
	x11-misc/xdotool
	x11-themes/hicolor-icon-theme"

src_install() {
	meson_src_install
	python_fix_shebang "${ED}/usr/bin/emote"
	rm -f "${ED}/usr/share/emote/static/"{com.tomjwatson.Emote.desktop,meson.build,prepare-launch} || die
}
