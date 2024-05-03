# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32 ruby33"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
IUSE="rubyexec rubyexec-autopick"

inherit ruby-fakegem rubyexec

DESCRIPTION="Potentially the best command line gister"
HOMEPAGE="https://github.com/defunkt/gist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	!dev-python/txgithub
	rubyexec? ( dev-ruby/rubyexec )
"
REQUIRED_USE="rubyexec-autopick? ( rubyexec )"

ruby_add_bdepend "test? ( dev-ruby/webmock )"

all_ruby_install() {
	if use rubyexec; then
		rubyexec-install_fakegem_binaries $(usex rubyexec-autopick --autopick)
		RUBY_FAKEGEM_BINWRAP=
	fi

	all_fakegem_install
}
