# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24 ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_DOC_SOURCES="ext/digest/kangarootwelve/ext.c lib/digest/kangarootwelve/version.rb"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST=rake
RUBY_FAKEGEM_TASK_TEST=test
RUBY_FAKEGEM_EXTENSIONS=("ext/digest/kangarootwelve/extconf.rb")

inherit ruby-fakegem

DESCRIPTION="KangarooTwelve for Ruby"
HOMEPAGE="https://github.com/konsolebox/digest-kangarootwelve-ruby"
LICENSE=MIT

TARGET_FLAGS="target_armv6m target_armv7a target_armv7m target_armv8a target_asmx86-64 target_asmx86-64shld target_avr8 target_bulldozer target_compact target_generic32 target_generic32lc target_generic64 target_generic64lc target_haswell target_nehalem target_reference target_reference32bits target_sandybridge"
IUSE="${IUSE} ${TARGET_FLAGS/target_compact/+target_compact}"
REQUIRED_USE="${REQUIRED_USE} || ( ${TARGET_FLAGS} ) !target_compact? ( test )"

SLOT=0
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

ruby_add_bdepend ">=dev-ruby/rake-compiler-1.0 || ( <dev-ruby/rake-compiler-1.1.3 >dev-ruby/rake-compiler-1.1.5 )"
ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.8 )"

each_ruby_prepare() {
	# Strip ext files from spec.files to reduce cp noise.  We don't install them anyway.
	sed -i '/  ext\//d' digest-kangarootwelve.gemspec || \
		die "Failed to strip ext files from spec.files."
}

_digest_kangarootwelve_get_active_target() {
	local t

	for t in ${TARGET_FLAGS}; do
		use "$t" && __=${t#target_} && return
	done

	die "Failed to get current target."
}

each_ruby_compile() {
	_digest_kangarootwelve_get_active_target
	${RUBY} -S rake compile -- --with-target="$__" || die "Failed to compile extension."
	use doc && rdoc --quiet --ri --output=ri ${RUBY_FAKEGEM_DOC_SOURCES}
}

each_ruby_install() {
	each_fakegem_install

	if use doc; then
		insinto "$(ruby_fakegem_gemsdir)/doc/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}"
		doins -r ri
	fi
}
