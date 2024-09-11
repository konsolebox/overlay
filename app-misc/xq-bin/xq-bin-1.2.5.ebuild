# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Command-line XML and HTML beautifier and content extractor"
HOMEPAGE="https://github.com/sibprogrammer/xq"

BASE_SRC_URI="https://github.com/sibprogrammer/xq/releases/download"
SRC_URI="amd64? ( ${BASE_SRC_URI}/v${PV}/xq_${PV}_linux_amd64.tar.gz -> ${P}-amd64.tar.gz )
	arm64? ( ${BASE_SRC_URI}/v${PV}/xq_${PV}_linux_arm64.tar.gz -> ${P}-arm64.tar.gz )
	x86? ( ${BASE_SRC_URI}/v${PV}/xq_${PV}_linux_386.tar.gz -> ${P}-x86.tar.gz )"
S=${WORKDIR}

LICENSE="MIT"
SLOT=0
KEYWORDS="-* ~amd64 ~arm64 ~x86"
REQUIRED_USE="^^ ( amd64 arm64 x86 )"
QA_PRESTRIPPED=usr/bin/xq
RESTRICT="mirror"

src_install() {
	dodoc README.md
	dobin xq
}
