# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY='ruby22 ruby23 ruby24 ruby25'

RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_DOC_SOURCES='ext/digest/xxhash/ext.c lib/digest/xxhash/version.rb'
RUBY_FAKEGEM_EXTRADOC='README.md'
RUBY_FAKEGEM_RECIPE_TEST=rake
RUBY_FAKEGEM_TASK_TEST=test

inherit ruby-fakegem

DESCRIPTION="An XXHash library that complies with Digest::Instance's functional design"

HOMEPAGE='https://github.com/konsolebox/digest-xxhash-ruby'
LICENSE=MIT

SLOT=0
KEYWORDS='~amd64 ~arm ~arm64 ~x86'

ruby_add_bdepend '>=dev-ruby/rake-compiler-1.0'
ruby_add_bdepend 'test? ( >=dev-ruby/minitest-5.8 )'

each_ruby_compile() {
	${RUBY} -S rake compile || die 'Failed to compile extension.'
	use doc && rdoc --quiet --ri --output=ri ${RUBY_FAKEGEM_DOC_SOURCES}
}

each_ruby_install() {
	each_fakegem_install

	if use doc; then
		insinto "$(ruby_fakegem_gemsdir)/doc/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}"
		doins -r ri
	fi
}
