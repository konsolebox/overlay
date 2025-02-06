# Copyright 2025 konsolebox
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: get-opt-and-optarg.eclass
# @MAINTAINER:
# konsolebox@gmail.com
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: Provides get_opt_and_optarg()
# @DESCRIPTION:
# This eclass proivides get_opt_and_optarg(); a function that helps parse command-line options.

# @FUNCTION: get_opt_and_optarg
# @USAGE: get_opt_and_optarg
# @RETURN: Option through OPT, argument through OPTARG; shift argument through OPTSHIFT
# @DESCRIPTION:
# Extracts an option and an argument from a string or a pair of strings.
# Optional arguments may be specified separately from the option.
get_opt_and_optarg() {
	local optional=false

	if [[ $1 == @optional ]]; then
		optional=true
		shift
	fi

	OPT=$1 OPTARG= OPTSHIFT=0

	if [[ $1 == -[!-]?* ]]; then
		OPT=${1:0:2} OPTARG=${1:2}
	elif [[ $1 == --*=* ]]; then
		OPT=${1%%=*} OPTARG=${1#*=}
	elif [[ ${2+.} && (${optional} == false || $2 != -?*) ]]; then
		OPTARG=$2 OPTSHIFT=1
	elif [[ ${optional} == true ]]; then
		return 1
	else
		die "No argument specified for '$1'." 2
	fi

	return 0
}
