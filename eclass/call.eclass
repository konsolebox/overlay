# Copyright 2023 konsolebox
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: call.eclass
# @MAINTAINER:
# konsolebox@gmail.com
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: Provides call()
# @DESCRIPTION:
# This eclass proivides call(); a function that prints and calls external command.

# @FUNCTION: call
# @DESCRIPTION:
# Prints and calls external command.
call() {
	local x q m=

	for x do
		printf -v q %q "$x"

		if [[ $q == "$x" ]]; then
			m+=" $x"
		elif [[ $x == *\'* ]]; then
			m+=" $q"
		else
			m+=" '$x'"
		fi
	done

	printf '%s\n' "${m# }"
	command "$@"
}
