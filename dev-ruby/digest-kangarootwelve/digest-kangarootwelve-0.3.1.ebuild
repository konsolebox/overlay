# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY='ruby22 ruby23 ruby24 ruby25'

RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_DOC_SOURCES='ext/digest/kangarootwelve/ext.c lib/digest/kangarootwelve/version.rb'
RUBY_FAKEGEM_EXTRADOC='README.md'
RUBY_FAKEGEM_RECIPE_TEST=rake
RUBY_FAKEGEM_TASK_TEST=test

inherit ruby-fakegem

DESCRIPTION='KangarooTwelve for Ruby'
HOMEPAGE='https://github.com/konsolebox/digest-kangarootwelve-ruby'
LICENSE=MIT

TARGET_FLAGS='target_armv6m target_armv7a target_armv7m target_armv8a target_asmx86-64 target_asmx86-64shld target_avr8 target_bulldozer target_compact target_generic32 target_generic32lc target_generic64 target_generic64lc target_haswell target_nehalem target_reference target_reference32bits target_sandybridge'
IUSE+=" ${TARGET_FLAGS/target_compact/+target_compact}"
REQUIRED_USE+=" || ( ${TARGET_FLAGS} )"

SLOT=0
KEYWORDS='~amd64 ~arm ~arm64 ~x86'

ruby_add_bdepend '>=dev-ruby/rake-compiler-1.0'
ruby_add_bdepend 'test? ( >=dev-ruby/minitest-5.8 )'

get_active_target() {
	local t

	for t in ${TARGET_FLAGS}; do
		use "$t" && __=${t#target_} && return 0
	done

	__=
	return 1
}

each_ruby_compile() {
	get_active_target && ${RUBY} -S rake compile -- --with-target="$__" || die 'Failed to compile extension.'
	use doc && rdoc --quiet --ri --output=ri ${RUBY_FAKEGEM_DOC_SOURCES}
}

each_ruby_install() {
	each_fakegem_install

	if use doc; then
		insinto "$(ruby_fakegem_gemsdir)/doc/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}"
		doins -r ri
	fi
}
