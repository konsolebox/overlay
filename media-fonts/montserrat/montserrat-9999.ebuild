# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font git-r3

DESCRIPTION="Font inspired by the signage found in a historical neighborhood of Buenos Aires"
HOMEPAGE="https://github.com/JulietaUla/Montserrat/"
EGIT_REPO_URI="https://github.com/JulietaUla/Montserrat.git"
EGIT_BRANCH=master
LICENSE="OFL-1.1"
SLOT=0
FONT_S=${S}/fonts/otf
FONT_SUFFIX=otf
RESTRICT="binchecks strip test"
