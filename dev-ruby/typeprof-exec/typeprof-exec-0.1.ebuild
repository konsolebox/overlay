# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Named it typeprof-exec instead of typeprof-binwrapper because
# if there were more than one binary in this package,
# typeprof-binwrappers would be more consistent and that enduces OCD
# if different packages use singular form and others use plural.

EAPI=8

inherit rubyexec-r1

DESCRIPTION="Installs a binwrapper for dev-ruby/typeprof"
HOMEPAGE="https://github.com/konsolebox/overlay"

S=${WORKDIR}
LICENSE="MIT" # Just follow dev-ruby/typeprof's license
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-ruby/rubyexec
	!dev-ruby/typeprof:0
"

src_install() {
	rubyexec-r1_install_fakegem_binwrapper typeprof ruby{31..34} --autopick --autoversion \
			--gem-name=typeprof
}
