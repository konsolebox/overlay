# Copyright 2023 konsolebox
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: use-ruby-mask.eclass
# @MAINTAINER:
# konsolebox <konsolebox@gmail.com>
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: Applies USE_RUBY_MASK
# @DESCRIPTION:
# This eclass takes values from USE_RUBY_MASK and filters out values
# of USE_RUBY that match them.

# @ECLASS_VARIABLE: USE_RUBY_MASK
# @DESCRIPTION:
# Specifies values to exclude from USE_RUBY

if [[ ${USE_RUBY_MASK-} && ${USE_RUBY-} ]]; then
	USE_RUBY=$(
		set -f
		IFS=$' \t\n'
		set -- ${USE_RUBY_MASK}
		USE_RUBY_MASK=" $* "
		new_use_ruby=()
		for i in ${USE_RUBY}; do
			[[ ${USE_RUBY_MASK} != *" ${i} "* ]] && new_use_ruby+=("$i")
		done
		printf %s "${new_use_ruby[*]}"
	)
fi
