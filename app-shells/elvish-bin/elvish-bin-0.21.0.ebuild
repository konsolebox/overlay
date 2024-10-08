# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Elvish is an expressive programming language and a versatile interactive shell."
HOMEPAGE="https://elv.sh/ https://github.com/elves/elvish"

SRC_URI="amd64? ( https://dl.elv.sh/linux-amd64/elvish-v${PV}.tar.gz -> ${P}-amd64.tar.gz )
	arm64? ( https://dl.elv.sh/linux-arm64/elvish-v${PV}.tar.gz -> ${P}-arm64.tar.gz )
	x86? ( https://dl.elv.sh/linux-386/elvish-v${PV}.tar.gz -> ${P}-x86.tar.gz )"
S=${WORKDIR}

LICENSE="BSD-2"
SLOT=0
KEYWORDS="-* ~amd64 ~arm64 ~x86"
REQUIRED_USE="^^ ( amd64 arm64 x86 )"
RESTRICT="mirror"

src_install() {
	newbin "elvish-v${PV}" elvish
}
