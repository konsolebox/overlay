# Copyright 1999-2025 Gentoo Authors
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
# Commit version that contains the script when PV != 9999

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_EXT
# @DESCRIPTION:
# Extension name of the script
# @REQUIRED

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_PREFIX
# @DESCRIPTION:
# Specifies the prefix path to the file in the repository

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS
# @DESCRIPTION:
# Ruby targets a Ruby script can be installed for

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_RUBY_DEPENDENCIES
# @DESCRIPTION:
# Dependencies of a Ruby script

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_TEST
# @DEFAULT_UNSET
# @DESCRIPTION:
# Name of the test script in the tests/ directory (e.g., hyphenate.test.rb)

# @ECLASS_VARIABLE: KONSOLEBOX_SCRIPTS_TEST_DEPENDENCIES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Dependencies for running the test

[[ ${EAPI} == [5678] ]] || die "EAPI needs to be 5, 6, 7 or 8."
[[ ${PV} == 9999* ]] && inherit git-r3
[[ ${KONSOLEBOX_SCRIPTS_EXT} == rb ]] && inherit ruby-utils-compat
inherit call

# @FUNCTION: _konsolebox-scripts_get_ruby_exec
# @USAGE: <ruby_target>
# @DESCRIPTION:
# Gets the execution path of a Ruby target and saves it to the
# _ruby_exec variable
# @INTERNAL
_konsolebox-scripts_get_ruby_exec() {
	local target=$1
	_ruby_exec=

	case ${target} in
	ruby1[89]|ruby2[0-7]|ruby3[0-4])
		_ruby_exec=$(type -P "ruby${target#ruby}") || die "Executable for ${target} not found"
		;;
	ree18)
		_ruby_exec=$(type -P "ruby") || die "Executable for ${target} not found"
		;;
	jruby)
		_ruby_exec=$(type -P "jruby") || die "Executable for ${target} not found"
		;;
	rbx)
		_ruby_exec=$(type -P "rbx") || die "Executable for ${target} not found"
		;;
	*)
		die "Unknown Ruby target: ${target}"
		;;
	esac

	[[ ${_ruby_exec} && -x ${_ruby_exec} ]] || die "Invalid Ruby executable: ${_ruby_exec}"
}

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
		[[ ${KONSOLEBOX_SCRIPTS_COMMIT-} ]] || die "Commit version not specified."
		local base_src_uri="https://raw.githubusercontent.com/konsolebox/scripts/${KONSOLEBOX_SCRIPTS_COMMIT}"
		local remote_filename=${KONSOLEBOX_SCRIPTS_PREFIX-}${PN}.${KONSOLEBOX_SCRIPTS_EXT}
		local local_filename=${PN}-${PV}-${KONSOLEBOX_SCRIPTS_COMMIT:0:8}.${KONSOLEBOX_SCRIPTS_EXT}
		SRC_URI="${base_src_uri}/${remote_filename} -> ${local_filename}"

		if [[ ${KONSOLEBOX_SCRIPTS_TEST} ]]; then
			if [[ ${KONSOLEBOX_SCRIPTS_TEST} != [![:space:]/.]*.test.[![:space:]/.]* ]]; then
				die "Invalid test filename: ${KONSOLEBOX_SCRIPTS_TEST}"
			elif [[ ${KONSOLEBOX_SCRIPTS_TEST} != *.bash && ${KONSOLEBOX_SCRIPTS_TEST} != *.rb ]]; then
				die "Unsupported test filename extension: ${KONSOLEBOX_SCRIPTS_TEST##*.}"
			fi

			local_filename=${KONSOLEBOX_SCRIPTS_TEST}.${KONSOLEBOX_SCRIPTS_COMMIT:0:8}
			SRC_URI+=$'\n'"${base_src_uri}/tests/${KONSOLEBOX_SCRIPTS_TEST} -> ${local_filename}"
		fi

		S=${WORKDIR}
	fi

	HOMEPAGE="https://github.com/konsolebox/scripts"
	SLOT=${SLOT-0}
	RESTRICT="mirror"

	if [[ ${KONSOLEBOX_SCRIPTS_EXT} == rb ]]; then
		[[ ${KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS+.} ]] || die "No Ruby targets specified"

		local deps impl_dep target test_deps= valid_flags=

		for target in "${KONSOLEBOX_SCRIPTS_RUBY_SINGLE_TARGETS[@]}"; do
			[[ ${target} == ruby* ]] || die "Specified Ruby target is unsupported: ${target}"

			if [[ -z ${RUBY_TARGETS_PREFERENCE-} || " ${RUBY_TARGETS_PREFERENCE} " == *" ${target} "* ]]; then
				impl_dep=$(_ruby_implementation_depend "${target}") && [[ ${impl_dep} ]] || die
				valid_flags+=" ruby_single_target_${target}"

				if [[ ${KONSOLEBOX_SCRIPTS_RUBY_DEPENDENCIES+.} ]]; then
					printf -v deps ' dev-ruby/%s[FLAG]' "${KONSOLEBOX_SCRIPTS_RUBY_DEPENDENCIES[@]}"
					deps=${deps//FLAG/ruby_targets_${target}}
					RDEPEND+=" ruby_single_target_${target}? ( ${impl_dep}${deps} )"
				else
					RDEPEND+=" ruby_single_target_${target}? ( ${impl_dep} )"
				fi

				if [[ ${KONSOLEBOX_SCRIPTS_TEST} && ${KONSOLEBOX_SCRIPTS_TEST_DEPENDENCIES+.} ]]; then
					printf -v deps 'dev-ruby/%s[FLAG] ' "${KONSOLEBOX_SCRIPTS_TEST_DEPENDENCIES[@]}"
					deps=${deps//FLAG/ruby_targets_${target}}
					test_deps+=" ruby_single_target_${target}? ( ${deps% } )"
				fi
			fi
		done

		[[ ${valid_flags} ]] || die "None of the specified Ruby targets are supported"
		IUSE+=" ${valid_flags}"
		REQUIRED_USE="^^ ( ${valid_flags} )"
		[[ ${test_deps} ]] && BDEPEND+=" test? ( ${test_deps} )"
	fi

	if [[ ${KONSOLEBOX_SCRIPTS_EXT} != bash ]] && has nounset ${IUSE//+}; then
		die "Nounset use flag is only valid in bash scripts."
	fi

	if [[ ${KONSOLEBOX_SCRIPTS_TEST} ]]; then
		IUSE+=" test"
		RESTRICT+=" !test? ( test )"
	fi
}

# @FUNCTION: konsolebox-scripts_src_unpack
# @DESCRIPTION:
# Implements src_unpack
konsolebox-scripts_src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	else
		local src dest

		for src in ${A}; do
			if [[ ${src} == *.test.* ]]; then
				dest=${KONSOLEBOX_SCRIPTS_TEST}
			else
				dest=${PN}.${KONSOLEBOX_SCRIPTS_EXT}
			fi

			call cp "${DISTDIR}/${src}" "${WORKDIR}/${dest}" || die
		done
	fi
}

# @FUNCTION: konsolebox-scripts_src_compile
# @DESCRIPTION:
# Implements src_compile
konsolebox-scripts_src_compile() {
	if [[ ${PV} == 9999* ]]; then
		call cp -- "${KONSOLEBOX_SCRIPTS_PREFIX-}${PN}.${KONSOLEBOX_SCRIPTS_EXT}" "${PN}" || die
	else
		call cp -- "${PN}.${KONSOLEBOX_SCRIPTS_EXT}" "${PN}" || die
	fi

	if [[ ${KONSOLEBOX_SCRIPTS_EXT} == rb ]]; then
		local _ruby_exec use

		for use in ${IUSE}; do
			if [[ ${use} == ruby_single_target_* ]] && use "${use}"; then
				_konsolebox-scripts_get_ruby_exec "${use#ruby_single_target_}"
				break
			fi
		done

		[[ ${_ruby_exec} ]] || die "No Ruby implementation selected"
		call sed -i -e "1s|.*|#!${_ruby_exec}|" "${PN}" || die
	fi

	if has nounset ${IUSE//+} && use nounset; then
		call sed -i -e '1s|.*|&\n\n\[\[ BASH_VERSINFO -ge 5 \]\] \&\& set -u|' "${PN}" || die
	fi
}

# @FUNCTION: konsolebox-scripts_src_test
# @DESCRIPTION:
# Implements src_test
konsolebox-scripts_src_test() {
	if [[ ${KONSOLEBOX_SCRIPTS_TEST} ]]; then
		local test=${KONSOLEBOX_SCRIPTS_TEST} subject=${PN}.${KONSOLEBOX_SCRIPTS_EXT}
		local -x TMPDIR=${T}

		[[ ${PV} == 9999* ]] && test=tests/${KONSOLEBOX_SCRIPTS_TEST}
		[[ -f ${test} ]] || die "Test file doesn't exist: ${test}"

		case ${KONSOLEBOX_SCRIPTS_TEST} in
		*.bash)
			call bash "${test}" "${subject}" || die "Bash test failed"
			;;
		*.rb)
			local _ruby_exec use target

			for use in ${IUSE}; do
				if [[ ${use} == ruby_single_target_* ]] && use "${use}"; then
					target=${use#ruby_single_target_}
					_konsolebox-scripts_get_ruby_exec "${target}"
					einfo "Running tests with ${_ruby_exec} (${target})"

					call "${_ruby_exec}" "${test}" "${subject}" "${_ruby_exec}" || \
						die "Ruby test failed for ${target}"

					break
				fi
			done

			[[ ${_ruby_exec} ]] || die "No Ruby implementation selected for testing"
			;;
		esac
	fi
}

# @FUNCTION: konsolebox-scripts_src_install
# @DESCRIPTION:
# Implements src_install
konsolebox-scripts_src_install() {
	dobin "${PN}"
}

_konsolebox-scripts_set_globals
EXPORT_FUNCTIONS src_unpack src_compile src_test src_install
