# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="irb.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"
IUSE="rubyexec test"

inherit ruby-fakegem rubyexec

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ruby/irb.git"
	EGIT_BRANCH=master
	EGIT_CHECKOUT_DIR=${WORKDIR}/all/${P}
	SRC_URI=
else
	SRC_URI="https://github.com/ruby/irb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Interactive Ruby command-line tool for REPL (Read Eval Print Loop)"
HOMEPAGE="https://github.com/ruby/irb"
LICENSE="BSD-2"
SLOT="0"

# Ensure a new enough eselect-ruby is present to avoid clobbering the
# irb bin and man page.
ruby_add_rdepend "
	>=dev-ruby/rdoc-4.0.0
	>=dev-ruby/reline-0.4.2
	!<app-eselect/eselect-ruby-20231008
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/debug
		dev-ruby/test-unit
		dev-ruby/test-unit-ruby-core
	)"

all_ruby_prepare() {
	sed -e 's:_relative ":"./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Skip test requiring specific character set
	sed -e '/test_raise_exception_with_different_encoding_containing_invalid_byte_sequence/aomit "charset"' \
		-i test/irb/test_raise_exception.rb || die

	# Skip tests that require the unpackaged tracer gem
	sed -e '/test_use_tracer_enabled_when_gem_is_available/aomit "Requires tracer gem"' \
		-i test/irb/test_tracer.rb || die

	# Skip tests confused by our test path
	sed -e '/test_backtrace_filtering/aomit "Fails due to unexpected paths"' \
		-i test/irb/test_irb.rb || die
}

each_ruby_test() {
	RUBYLIB=lib ${RUBY} -S rake test || die
}

all_ruby_install() {
	if use rubyexec; then
		rubyexec-install_fakegem_binaries
		RUBY_FAKEGEM_BINWRAP=
	fi

	all_fakegem_install
	doman man/irb.1
}
