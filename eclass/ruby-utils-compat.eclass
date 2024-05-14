inherit ruby-utils

if declare -pf _ruby_implementation_depend &>/dev/null; then
	_ruby_implementation_depend() {
		local rubypn= rubyslot=

		case $1 in
		ruby1[89]|ruby2[0-7]|ruby3[0-3])
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
