# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A portable command-line YAML, JSON, XML, CSV, TOML and properties processor"
HOMEPAGE="https://github.com/mikefarah/yq"

BASE_SRC_URI="https://github.com/mikefarah/yq/releases/download"
SRC_URI="amd64? ( ${BASE_SRC_URI}/v${PV}/yq_linux_amd64.tar.gz -> ${P}-amd64.tar.gz )
	arm? ( ${BASE_SRC_URI}/v${PV}/yq_linux_arm.tar.gz -> ${P}-arm.tar.gz )
	arm64? ( ${BASE_SRC_URI}/v${PV}/yq_linux_arm64.tar.gz -> ${P}-arm64.tar.gz )
	x86? ( ${BASE_SRC_URI}/v${PV}/yq_linux_386.tar.gz -> ${P}-x86.tar.gz )"

S=${WORKDIR}

LICENSE="MIT"
SLOT=0
KEYWORDS="-* ~amd64 ~arm ~arm64 ~x86"
REQUIRED_USE="^^ ( amd64 arm arm64 x86 )"
RDEPEND="!app-misc/yq"
QA_PRESTRIPPED=usr/bin/yq

src_install() {
	doman yq.1
	exeinto /usr/bin
	newexe yq_linux_* yq
}
