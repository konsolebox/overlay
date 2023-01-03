# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Pipe Watch: monitor recent lines of output from pipe"
HOMEPAGE="https://www.kylheku.com/cgit/pw/"
LICENSE="BSD-2"

SLOT=0
EGIT_REPO_URI="https://www.kylheku.com/git/pw.git"
EGIT_BRANCH=master

src_install() {
	doman pw.1 pw-relnotes.5
	dobin pw
}
