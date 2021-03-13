# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font git-r3

DESCRIPTION="Font inspired by the signage found in a historical neighborhood of Buenos Aires"
HOMEPAGE="https://github.com/JulietaUla/Montserrat/"
SRC_URI=
EGIT_REPO_URI="https://github.com/JulietaUla/Montserrat.git"
LICENSE="OFL-1.1"
SLOT=0
KEYWORDS=
IUSE=
DEPEND="app-arch/unzip"
FONT_S=${S}/fonts/otf
FONT_SUFFIX=otf
RESTRICT="binchecks strip test"
