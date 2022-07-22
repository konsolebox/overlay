# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25 ruby26 ruby27 ruby30 ruby31"
MY_PV=${PV%_p*}

RUBY_FAKEGEM_DOC_SOURCES="
	lib/nori.rb
	lib/nori/core_ext/object.rb
	lib/nori/core_ext/hash.rb
	lib/nori/core_ext/string.rb
	lib/nori/parser/nokogiri.rb
	lib/nori/parser/rexml.rb
	lib/nori/version.rb
	lib/nori/xml_utility_node.rb
	lib/nori/string_io_file.rb
	lib/nori/string_with_attributes.rb
	lib/nori/core_ext.rb
"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_RECIPE_TEST=none
RUBY_FAKEGEM_VERSION=${MY_PV}

inherit ruby-fakegem

DESCRIPTION="XML to Hash translator"
HOMEPAGE="https://github.com/savonrb/nori"
LICENSE=MIT

SLOT=0
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SRC_URI="https://github.com/savonrb/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
PATCHES=("${FILESDIR}/nori-2.6.0-p20211008.patch")
RUBY_S=${PN}-${MY_PV}
