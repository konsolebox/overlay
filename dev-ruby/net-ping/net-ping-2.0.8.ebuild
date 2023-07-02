# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25 ruby26 ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_DOC_SOURCES=lib
RUBY_FAKEGEM_EXTRADOC="README.md doc/ping.txt"

# One of its dependencies, "fakeweb" fails with its own tests so we
# don't add tests here as well until it's resolved.  This package will
# also be masked because of it.
RUBY_FAKEGEM_RECIPE_TEST=
RUBY_FAKEGEM_TASK_TEST=

inherit ruby-fakegem-compat

DESCRIPTION="A collection of classes that provide different ways to ping computers"
HOMEPAGE="https://github.com/eitoball/net-ping"
LICENSE=Artistic-2
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

each_ruby_install() {
	each_fakegem_install

	if use doc; then
		insinto "$(ruby_fakegem_gemsdir)/doc/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}"
		doins -r ri
	fi
}
