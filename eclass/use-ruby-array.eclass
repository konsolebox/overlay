# Copyright 2026 konsolebox
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: use-ruby-array.eclass
# @MAINTAINER: konsolebox <konsolebox@gmail.com>
# @AUTHOR: konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @DESCRIPTION:
# Allows USE_RUBY to be specified as an array in ebuilds that inherit
# ruby-ng.eclass.  Must be inherited before ruby-ng.eclass.

inherit is-array

if is_indexed_array USE_RUBY; then
	printf -v temp '%s ' "${USE_RUBY[@]}"
	unset -v USE_RUBY
	USE_RUBY=${temp% }
	unset -v temp
fi
