# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32 ruby33 ruby34"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
IUSE="rubyexec rubyexec-autopick"

inherit ruby-fakegem rubyexec-r1

DESCRIPTION="Potentially the best command line gister"
HOMEPAGE="https://github.com/defunkt/gist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	!dev-python/txgithub
	rubyexec? ( >=dev-ruby/rubyexec-0_p20260508 )
"
REQUIRED_USE="rubyexec-autopick? ( rubyexec )"

ruby_add_bdepend "test? ( dev-ruby/webmock )"

all_ruby_install() {
	if use rubyexec; then
		rubyexec_install_fakegem_binwrapper $(usex rubyexec-autopick --autopick)
		RUBY_FAKEGEM_BINWRAP=
	fi

	all_fakegem_install
}
