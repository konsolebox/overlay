# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

DESCRIPTION="Font inspired by the signage found in a historical neighborhood of Buenos Aires"
HOMEPAGE="https://github.com/JulietaUla/Montserrat/"
SRC_URI="https://github.com/JulietaUla/Montserrat/archive/v${PV}.zip -> ${P}.zip"
LICENSE="OFL-1.1"
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=
DEPEND="app-arch/unzip"
S=${WORKDIR}/Montserrat-${PV}
FONT_S=${S}/fonts/otf
FONT_SUFFIX=otf
RESTRICT="binchecks strip test"
