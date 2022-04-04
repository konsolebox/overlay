# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: konsolebox-scripts.eclass
# @MAINTAINER:
# konsolebox@gmail.com
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: Eclass for installing konsolebox's scripts
# @DESCRIPTION:
# This eclass contains unified code for installing konsolebox's scripts

# @ECLASS-VARIABLE: KONSOLEBOX_SCRIPTS_GIT_BRANCH
# @DESCRIPTION:
# Git branch to checkout when PV == 9999.  Default is master.
: ${KONSOLEBOX_SCRIPTS_GIT_BRANCH=master}

# @ECLASS-VARIABLE: KONSOLEBOX_SCRIPTS_COMMIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Commit version that contain the script when PV != 9999
: ${KONSOLEBOX_SCRIPTS_COMMIT=}

# @ECLASS-VARIABLE: KONSOLEBOX_SCRIPTS_EXT
# @DESCRIPTION:
# Extension name of the script
# @REQUIRED

[[ ${EAPI} == [5678] ]] || die "EAPI needs to be 5, 6, 7 or 8."

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/konsolebox/scripts.git"
	EGIT_BRANCH=${KONSOLEBOX_SCRIPTS_GIT_BRANCH}
else
	SRC_URI="https://raw.githubusercontent.com/konsolebox/scripts/${KONSOLEBOX_SCRIPTS_COMMIT}/${PN}.${KONSOLEBOX_SCRIPTS_EXT} -> ${PN}-${PV}.${KONSOLEBOX_SCRIPTS_EXT}"
	S=${WORKDIR}
fi

HOMEPAGE="https://github.com/konsolebox/scripts"
SLOT=${SLOT-0}

# @FUNCTION: konsolebox-scripts_src_unpack()
# @DESCRIPTION:
# Implements src_prepere
konsolebox-scripts_src_unpack() {
	if [[ ${PV} != 9999 ]]; then
		cp -v -- "${DISTDIR}/${A}" "${WORKDIR}/${PN}" || die
	else
		git-r3_src_unpack
	fi
}

# @FUNCTION: konsolebox-scripts_src_prepare()
# @DESCRIPTION:
# Implements src_prepere
konsolebox-scripts_src_prepare() {
	if [[ ${PV} == 9999 ]]; then
		mv -- "${PN}.${KONSOLEBOX_SCRIPTS_EXT}" "${PN}" || die
	fi
}

# @FUNCTION: konsolebox-scripts_src_install()
# @DESCRIPTION:
# Implements src_install
konsolebox-scripts_src_install() {
	dobin "${PN}"
}

EXPORT_FUNCTIONS src_unpack src_prepare src_install
