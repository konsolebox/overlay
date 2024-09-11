# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31 ruby32 ruby33"

RUBY_FAKEGEM_DOC_SOURCES="
	lib/nori.rb
	lib/nori/core_ext.rb
	lib/nori/core_ext/hash.rb
	lib/nori/core_ext/string.rb
	lib/nori/parser/nokogiri.rb
	lib/nori/parser/rexml.rb
	lib/nori/string_io_file.rb
	lib/nori/string_with_attributes.rb
	lib/nori/version.rb
	lib/nori/xml_utility_node.rb
"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_RECIPE_TEST=none # Test requires strict rake and rspec versions, and .git
RUBY_FAKEGEM_VERSION=${PV%_p*}

inherit ruby-fakegem-compat

DESCRIPTION="XML to Hash translator"
HOMEPAGE="https://github.com/savonrb/nori"

COMMIT=5eec90c52b0baf56b4b0491c5b2799dd22e32db4
SRC_URI="https://github.com/savonrb/nori/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"
RUBY_S=${PN}-${COMMIT}

LICENSE=MIT
SLOT=0
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RESTRICT="
	mirror
	!test? ( test )
"
