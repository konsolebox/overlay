# Copyright 2024 konsolebox
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: is-var-true.eclass
# @MAINTAINER:
# konsolebox <konsolebox@gmail.com>
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: Provides is_var_true()
# @DESCRIPTION:
# This eclass provides is_var_true().

# @FUNCTION: is_var_true
# @USAGE: <variable_name>
# @DESCRIPTION:
# Checks if specified variable is set to a "true" value
# @RETURN: OK status (0) if true, or FAIL status (1) otherwise
is_var_true() {
	[[ :yes:true:1: == *":${!1-}:"* ]]
}
