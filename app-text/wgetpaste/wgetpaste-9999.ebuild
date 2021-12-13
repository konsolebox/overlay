# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit git-r3

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="http://wgetpaste.zlin.dk/"
EGIT_REPO_URI="https://github.com/zlin/wgetpaste.git"
EGIT_BRANCH=master
LICENSE="public-domain"
SLOT="0"
IUSE="+ssl"
RDEPEND="net-misc/wget[ssl?]"

src_prepare() {
	sed -i -e "s:/etc:\"${EPREFIX}\"/etc:g" wgetpaste || die
	default
}

src_install() {
	dobin "${PN}"
	insinto /usr/share/zsh/site-functions
	doins _wgetpaste
}
