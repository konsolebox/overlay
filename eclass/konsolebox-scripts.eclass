# Copyright 1999-2023 Gentoo Authors
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

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_GIT_BRANCH
# @DESCRIPTION:
# Git branch to checkout when PV == 9999*.  Default is 'testing' if
# PV == 99999, or 'master' otherwise.

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_COMMIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Commit version that contain the script when PV != 9999

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_EXT
# @DESCRIPTION:
# Extension name of the script
# @REQUIRED

[[ ${EAPI} == [5678] ]] || die "EAPI needs to be 5, 6, 7 or 8."
[[ ${PV} == 9999* ]] && inherit git-r3
inherit call

# @FUNCTION: _konsolebox-scripts_set_globals
# @DESCRIPTION:
# Sets up global variables
# @INTERNAL
_konsolebox-scripts_set_globals() {
	if [[ ${PV} == 9999* ]]; then
		EGIT_REPO_URI="https://github.com/konsolebox/scripts.git"
		EGIT_BRANCH=${KONSOLEBOX_SCRIPTS_GIT_BRANCH-}
		[[ -z ${EGIT_BRANCH} && ${PV} == 99999 ]] && EGIT_BRANCH=testing
		[[ -z ${EGIT_BRANCH} ]] && EGIT_BRANCH=master
	else
		[[ -z ${KONSOLEBOX_SCRIPTS_COMMIT-} ]] && die "Commit version not specified."
		SRC_URI="https://raw.githubusercontent.com/konsolebox/scripts/${KONSOLEBOX_SCRIPTS_COMMIT}/${PN}.${KONSOLEBOX_SCRIPTS_EXT} -> ${PN}-${PV}.${KONSOLEBOX_SCRIPTS_EXT}"
		S=${WORKDIR}
	fi

	HOMEPAGE="https://github.com/konsolebox/scripts"
	SLOT=${SLOT-0}
}

# @FUNCTION: konsolebox-scripts_src_unpack()
# @DESCRIPTION:
# Implements src_unpack
konsolebox-scripts_src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	else
		call cp -- "${DISTDIR}/${A}" "${WORKDIR}/${PN}.${KONSOLEBOX_SCRIPTS_EXT}" || die
	fi
}

# @FUNCTION: konsolebox-scripts_src_compile()
# @DESCRIPTION:
# Implements src_compile
konsolebox-scripts_src_compile() {
	call cp -- "${PN}.${KONSOLEBOX_SCRIPTS_EXT}" "${PN}" || die

	if [[ ${KONSOLEBOX_SCRIPTS_EXT} == rb ]]; then
		call sed -i -e '1s|.*|#!/usr/bin/ruby|' "${PN}" || die
	fi

	if has nounset ${IUSE//+} && use nounset; then
		[[ ${KONSOLEBOX_SCRIPTS_EXT} == bash ]] || die "Nounset is only valid in bash scripts."
		call sed -i -e '1s|.*|&\n\n\[\[ BASH_VERSINFO -ge 5 \]\] \&\& set -u|' "${PN}" || die
	fi
}

# @FUNCTION: konsolebox-scripts_src_install()
# @DESCRIPTION:
# Implements src_install
konsolebox-scripts_src_install() {
	dobin "${PN}"
}

_konsolebox-scripts_set_globals
EXPORT_FUNCTIONS src_unpack src_compile src_install
