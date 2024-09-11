# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby22 ruby23 ruby24 ruby25 ruby26 ruby27 ruby30 ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_RECIPE_TEST=rake
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem-compat toolchain-funcs

DESCRIPTION="xxhash for Ruby"
HOMEPAGE="https://github.com/konsolebox/digest-xxhash-ruby"
LICENSE=MIT

SLOT=0
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.8 )"

each_ruby_prepare() {
	sed -i '/spec\.files.*\"ext\".*/d' digest-xxhash.gemspec || \
		die "Failed to exclude ext files from spec.files."
}

each_ruby_configure() {
	${RUBY} -C ext/digest/xxhash extconf.rb --with-cflags="${CFLAGS}" \
			--with-ldflags="${LDFLAGS}" --enable-verbose-mode || die
}

each_ruby_compile() {
	emake CC="$(tc-getCC)" V=1 -C ext/digest/xxhash
	mkdir -p lib/digest/xxhash || die
	cp ext/digest/xxhash/xxhash.so lib/digest/ || die

	if use doc; then
		rdoc --quiet --ri --output=ri ext/digest/xxhash/ext.c \
				lib/digest/xxhash/version.rb || die
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
