# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ruby-utils-compat.eclass
# @MAINTAINER:
# konsolebox <konsolebox@gmail.com>
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @PROVIDES: ruby-utils
# @BLURB: Modifies _ruby_implementation_depend so it allows old Rubies

inherit ruby-utils

if declare -pf _ruby_implementation_depend &>/dev/null; then
	_ruby_implementation_depend() {
		local rubypn= rubyslot=

		case $1 in
		ruby1[89]|ruby2[0-7]|ruby3[0-4])
			rubypn="dev-lang/ruby"
			rubyslot=":${1:4:1}.${1:5}"
			;;
		ree18)
			rubypn="dev-lang/ruby-enterprise"
			rubyslot=":1.8"
			;;
		jruby)
			rubypn="dev-java/jruby"
			rubyslot=""
			;;
		rbx)
			rubypn="dev-lang/rubinius"
			rubyslot=""
			;;
		*)
			die "Unknown Ruby implementation: $1"
			;;
		esac

		echo "$2${rubypn}$3${rubyslot}"
	}
else
	ewarn "_ruby_implementation_depend is no longer defined."
fi
