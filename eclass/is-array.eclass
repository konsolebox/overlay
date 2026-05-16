# Copyright 2026 konsolebox
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: is-array.eclass
# @MAINTAINER:
# konsolebox <konsolebox@gmail.com>
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: Provides is_array(), is_indexed_array() and is_assoc_array()
# @DESCRIPTION:
# This eclass provides functions that check if a variable is of an array type.

# @FUNCTION: is_array
# @USAGE: <variable_name>
# @DESCRIPTION:
# Checks if the specified variable is an indexed or associative array.
# @RETURN: OK status (0) if true, or FAIL status (1) otherwise

# @FUNCTION: is_indexed_array
# @USAGE: <variable_name>
# @DESCRIPTION:
# Checks if the specified variable is an indexed array.
# @RETURN: OK status (0) if true, or FAIL status (1) otherwise

# @FUNCTION: is_assoc_array
# @USAGE: <variable_name>
# @DESCRIPTION:
# Checks if the specified variable is an associative array.
# @RETURN: OK status (0) if true, or FAIL status (1) otherwise

if [[ BASH_VERSINFO[0] -gt 4 || BASH_VERSINFO[0] -eq 4 && BASH_VERSINFO[1] -ge 4 ]]; then
	eval '
		is_array() { [[ ${!1@a} == *[aA]* ]]; }
		is_indexed_array() { [[ ${!1@a} == *a* ]]; }
		is_assoc_array() { [[ ${!1@a} == *A* ]]; }
	'
else
	is_array() { [[ $(declare -p "$1" 2>/dev/null) == "declare -"[aA]* ]]; }
	is_indexed_array() { [[ $(declare -p "$1" 2>/dev/null) == "declare -a"* ]]; }
	is_assoc_array() { [[ $(declare -p "$1" 2>/dev/null) == "declare -A"* ]]; }
fi
