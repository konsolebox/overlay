# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby22 ruby23 ruby24 ruby25 ruby26 ruby27 ruby30 ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_RECIPE_TEST=rake
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem-compat toolchain-funcs

DESCRIPTION="KangarooTwelve for Ruby"
HOMEPAGE="https://github.com/konsolebox/digest-kangarootwelve-ruby"
LICENSE=MIT

TARGET_FLAGS="target_armv6 target_armv6m target_armv7a target_armv7m target_armv8a target_avr8 target_avx target_avx2 target_avx2noasm target_avx512 target_avx512noasm target_compact target_generic32 target_generic32lc target_generic64 target_generic64lc target_ssse3 target_xop"
IUSE="${IUSE-} ${TARGET_FLAGS/target_compact/+target_compact}"
REQUIRED_USE="${REQUIRED_USE-} ^^ ( ${TARGET_FLAGS} ) !target_compact? ( test )"

SLOT=0
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.8 )"

each_ruby_prepare() {
	sed -i '/spec\.files.*\"ext\".*/d' digest-kangarootwelve.gemspec || \
		die "Failed to exclude ext files from spec.files."
}

each_ruby_configure() {
	local selected_target t

	for t in ${TARGET_FLAGS}; do
		use "$t" && selected_target=${t#target_} && break
	done

	[[ ${selected_target} ]] || die "Failed to get selected target."

	${RUBY} -C ext/digest/kangarootwelve extconf.rb \
			--with-target="${selected_target}" --with-cflags="${CFLAGS} -Wa,--noexecstack" \
			--with-ldflags="${LDFLAGS} -Wl,-znoexecstack" --enable-verbose-mode || die
}

each_ruby_compile() {
	emake CC="$(tc-getCC)" V=1 -C ext/digest/kangarootwelve
	mkdir -p lib/digest/kangarootwelve || die
	cp ext/digest/kangarootwelve/kangarootwelve.so lib/digest/ || die

	if use doc; then
		rdoc --quiet --ri --output=ri ext/digest/kangarootwelve/ext.c \
				lib/digest/kangarootwelve/version.rb || die
	fi
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_extensions_installed

	if use doc; then
		insinto "$(ruby_fakegem_gemsdir)/doc/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}"
		doins -r ri
	fi
}

each_ruby_test() {
	${RUBY} -S rake -f "${FILESDIR}/Rakefile.test" test || die "Test failed."
}
