# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION='Inspired by the signage found in a historical neighborhood of Buenos Aires'
HOMEPAGE='http://www.fontsquirrel.com/fonts/montserrat'
SRC_URI="http://www.fontsquirrel.com/fonts/download/montserrat -> ${P}.zip"
LICENSE='OFL-1.1'
SLOT=0
KEYWORDS='~amd64 ~arm ~x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos'
IUSE=''
DEPEND='app-arch/unzip'
S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX='otf'
RESTRICT='binchecks strip test'
