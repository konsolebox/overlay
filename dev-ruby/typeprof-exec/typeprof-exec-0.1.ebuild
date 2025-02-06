# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

inherit ruby-ng rubyexec-r1

DESCRIPTION="Installs a binwrapper for dev-ruby/typeprof"
HOMEPAGE="https://github.com/konsolebox/overlay"

S=${WORKDIR}
LICENSE="MIT" # Just follow dev-ruby/typeprof's license
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND+="
	dev-ruby/rubyexec
	!dev-ruby/typeprof:0
"

src_prepare() {
	default
}

src_install() {
	rubyexec_install_fakegem_binwrapper typeprof --autopick --autoversion --gem-name=typeprof
}
