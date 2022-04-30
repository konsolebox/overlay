# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"
RUBY_FAKEGEM_GEMSPEC=${PN}.gemspec

inherit ruby-fakegem

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pry/${PN}.git"
	EGIT_BRANCH=master
	EGIT_CHECKOUT_DIR=${WORKDIR}/all/${P}
	SRC_URI=
	KEYWORDS=
else
	SRC_URI="https://github.com/pry/pry/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

DESCRIPTION="Pry is a powerful alternative to the standard IRB shell for Ruby"
HOMEPAGE="https://github.com/pry/pry/wiki"
LICENSE="MIT"
IUSE=
SLOT=0

ruby_add_rdepend "
	>=dev-ruby/coderay-1.1.0 =dev-ruby/coderay-1.1*
	=dev-ruby/method_source-1* !dev-ruby/pry:ruby19"

ruby_add_bdepend "
	test? (
		>=dev-ruby/open4-1.3
		>=dev-ruby/rake-0.9
		>=dev-ruby/mocha-1.0
	)"

all_ruby_prepare() {
	# Avoid unneeded dependency on git.
	# Loosen coderay dependency.
	sed -e '/git ls-files/d' -i "${RUBY_FAKEGEM_GEMSPEC}" || die
	sed -e '/[Bb]undler/d' -i spec/spec_helper.rb || die

	# Skip integration tests because they depend to much on specifics of the environment.
	rm -f spec/integration/* || die
	sed -i -e '/loads files through repl and exits/askip "depends on parent directory"' spec/cli_spec.rb || die

	# Change version
	if [[ ${PV} == *9999* ]]; then
		sed -i "s|VERSION.*|VERSION = '${PV}'.freeze|" lib/pry/version.rb || die
	fi
}
