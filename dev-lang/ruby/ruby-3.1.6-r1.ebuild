# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multiprocessing

MY_P="${PN}-$(ver_cut 1-3)"
S=${WORKDIR}/${MY_P}

SLOT=$(ver_cut 1-2)
MY_SUFFIX=$(ver_rs 1 '' ${SLOT})
RUBYVERSION=${SLOT}.0

DESCRIPTION="An object-oriented scripting language"
HOMEPAGE="https://www.ruby-lang.org/"
SRC_URI="https://cache.ruby-lang.org/pub/ruby/${SLOT}/${MY_P}.tar.xz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="berkdb debug doc examples gdbm ipv6 jemalloc jit socks5 +ssl static-libs systemtap tk valgrind xemacs"

RDEPEND="
	berkdb? ( sys-libs/db:= )
	gdbm? ( sys-libs/gdbm:= )
	jemalloc? ( dev-libs/jemalloc:= )
	jit? ( || ( sys-devel/gcc:* llvm-core/clang:* ) )
	ssl? (
		dev-libs/openssl:0=
	)
	socks5? ( >=net-proxy/dante-1.1.13 )
	systemtap? ( dev-debug/systemtap )
	tk? (
		dev-lang/tcl:0=[threads]
		dev-lang/tk:0=[threads]
	)
	dev-libs/libyaml
	dev-libs/libffi:=
	sys-libs/readline:0=
	sys-libs/zlib
	virtual/libcrypt:=
	>=app-eselect/eselect-ruby-20231008
"

DEPEND="
	${RDEPEND}
	valgrind? ( dev-debug/valgrind )
"

BUNDLED_GEMS="
	>=dev-ruby/irb-1.4.1[ruby_targets_ruby31(-)]
	>=dev-ruby/minitest-5.15.0[ruby_targets_ruby31(-)]
	>=dev-ruby/power_assert-2.0.1[ruby_targets_ruby31(-)]
	>=dev-ruby/rake-13.0.6-r2[ruby_targets_ruby31(-)]
	>=dev-ruby/rbs-2.1.0[ruby_targets_ruby31(-)]
	>=dev-ruby/rexml-3.2.5[ruby_targets_ruby31(-)]
	>=dev-ruby/rss-0.2.9[ruby_targets_ruby31(-)]
	>=dev-ruby/test-unit-3.5.3[ruby_targets_ruby31(-)]
	>=dev-ruby/typeprof-0.12.2[ruby_targets_ruby31(-)]
"

PDEPEND="
	${BUNDLED_GEMS}
	virtual/rubygems[ruby_targets_ruby31(-)]
	>=dev-ruby/bundler-2.3.3[ruby_targets_ruby31(-)]
	>=dev-ruby/did_you_mean-1.6.1[ruby_targets_ruby31(-)]
	>=dev-ruby/json-2.6.1[ruby_targets_ruby31(-)]
	>=dev-ruby/rdoc-6.3.3[ruby_targets_ruby31(-)]
	xemacs? ( app-xemacs/ruby-modes )
"

src_prepare() {
	eapply "${FILESDIR}"/"${SLOT}"/011*.patch
	eapply "${FILESDIR}"/"${SLOT}"/012*.patch
	eapply "${FILESDIR}"/"${SLOT}"/013*.patch
	eapply "${FILESDIR}"/"${SLOT}"/020*.patch
	eapply "${FILESDIR}"/"${SLOT}"/902*.patch

	if use elibc_musl ; then
		eapply "${FILESDIR}"/3.1/901-musl-*.patch
	fi

	einfo "Unbundling gems..."
	cd "$S"
	# Remove bundled gems that we will install via PDEPEND, bug
	# 539700.
	rm -fr gems/* || die
	touch gems/bundled_gems || die
	# Don't install CLI tools since they will clash with the gem
	rm -f bin/{racc,racc2y,y2racc} || die
	sed -i -e '/executables/ s:^:#:' lib/racc/racc.gemspec || die

	# Remove all irb-related files.
	rm -fr benchmark/irb_color.yml benchmark/irb_exec.yml doc/irb* libexec/irb lib/irb* man/irb.1 \
		spec/ruby/core/binding/fixtures/irb* spec/ruby/core/binding/irb_spec.rb test/irb || die

	einfo "Removing bundled libraries..."
	rm -fr ext/fiddle/libffi-3.2.1 || die

	# Remove webrick tests because setting LD_LIBRARY_PATH does not work for them.
	rm -rf tool/test/webrick || die

	# Remove tests that are known to fail or require a network connection
	rm -f test/ruby/test_process.rb test/rubygems/test_gem{,_path_support}.rb || die
	rm -f test/rinda/test_rinda.rb test/socket/test_tcp.rb test/fiber/test_address_resolve.rb test/resolv/test_addr.rb \
	   spec/ruby/library/socket/tcpsocket/{initialize,open}_spec.rb|| die
	sed -i -e '/def test_test/askip "Depends on system setup"' test/ruby/test_file_exhaustive.rb || die

	# MJIT is broken and removed in later ruby versions.
	rm -f test/ruby/test_jit.rb || die

	# This test calls out to the system ruby which is not being tested
	# and may not be the same version.
	sed -e '/test_without_tty/aomit "Calls system ruby"' \
		-i test/readline/test_readline.rb || die

	if use prefix ; then
		# Fix hardcoded SHELL var in mkmf library
		sed -i -e "s#\(SHELL = \).*#\1${EPREFIX}/bin/sh#" lib/mkmf.rb || die
	fi

	eapply_user

	eautoreconf
}

src_configure() {
	local modules="win32,win32ole" myconf=

	# Ruby's build system does interesting things with MAKEOPTS and doesn't
	# handle MAKEOPTS="-Oline" or similar well. Just filter it all out
	# and use -j/-l parsed out from the original MAKEOPTS, then use that.
	# Newer Portage sets this option by default in GNUMAKEFLAGS if nothing
	# is set by the user in MAKEOPTS. See bug #900929 and bug #728424.
	local makeopts_tmp="-j$(makeopts_jobs) -l$(makeopts_loadavg)"
	unset MAKEOPTS MAKEFLAGS GNUMAKEFLAGS
	export MAKEOPTS="${makeopts_tmp}"

	# Avoid a hardcoded path to mkdir to avoid issues with mixed
	# usr-merge and normal binary packages, bug #932386.
	export ac_cv_path_mkdir=mkdir

	# -fomit-frame-pointer makes ruby segfault, see bug #150413.
	filter-flags -fomit-frame-pointer
	append-flags -fno-omit-frame-pointer
	# In many places aliasing rules are broken; play it safe
	# as it's risky with newer compilers to leave it as it is.
	append-flags -fno-strict-aliasing

	# Ruby 3.1 does not compile against the gnu23 standard, bug
	# #943767. Given that Ruby 3.1 is EOL in March 2025 just opt to use
	# the older standard.
	append-flags -std=gnu17

	# Workaround for bug #938302
	if use systemtap && has_version "dev-debug/systemtap[-dtrace-symlink(+)]" ; then
		export DTRACE="${BROOT}"/usr/bin/stap-dtrace
	fi

	# Socks support via dante
	if use socks5 ; then
		# Socks support can't be disabled as long as SOCKS_SERVER is
		# set and socks library is present, so need to unset
		# SOCKS_SERVER in that case.
		unset SOCKS_SERVER
	fi

	# Increase GC_MALLOC_LIMIT if set (default is 8000000)
	if [ -n "${RUBY_GC_MALLOC_LIMIT}" ] ; then
		append-flags "-DGC_MALLOC_LIMIT=${RUBY_GC_MALLOC_LIMIT}"
	fi

	# ipv6 hack, bug 168939. Needs --enable-ipv6.
	use ipv6 || myconf="${myconf} --with-lookup-order-hack=INET"

	# Determine which modules *not* to build depending in the USE flags.
	if ! use berkdb ; then
		modules="${modules},dbm"
	fi
	if ! use gdbm ; then
		modules="${modules},gdbm"
	fi
	if ! use ssl ; then
		modules="${modules},openssl"
	fi
	if ! use tk ; then
		modules="${modules},tk"
	fi

	# Provide an empty LIBPATHENV because we disable rpath but we do not
	# need LD_LIBRARY_PATH by default since that breaks USE=multitarget
	# #564272
	# except on Darwin, where we really need LIBPATHENV to set the right
	# DYLD_ stuff during the invocation of miniruby for it to work
	#
	# --with-setjmp-type=setjmp for bug #949016
	[[ ${CHOST} == *-darwin* ]] || export LIBPATHENV=""
	INSTALL="${EPREFIX}/usr/bin/install -c" econf \
		--program-suffix=${MY_SUFFIX} \
		--with-soname=ruby${MY_SUFFIX} \
		--with-readline-dir="${EPREFIX}"/usr \
		--enable-shared \
		--enable-pthread \
		--disable-rpath \
		--without-baseruby \
		--with-compress-debug-sections=no \
		--with-setjmp-type=setjmp \
		--enable-mkmf-verbose \
		--with-out-ext="${modules}" \
		$(use_with jemalloc jemalloc) \
		$(use_enable jit jit-support ) \
		$(use_enable socks5 socks) \
		$(use_enable systemtap dtrace) \
		$(use_enable doc install-doc) \
		--enable-ipv6 \
		$(use_enable static-libs static) \
		$(use_enable static-libs install-static-library) \
		$(use_with static-libs static-linked-ext) \
		$(use_enable debug) \
		$(use_with valgrind) \
		${myconf} \
		--enable-option-checking=no

	# Makefile is broken because it lacks -ldl
	rm -rf ext/-test-/popen_deadlock || die
}

src_compile() {
	local -x LD_LIBRARY_PATH="${S}${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
	emake V=1 EXTLDFLAGS="${LDFLAGS}" MJIT_CFLAGS="${CFLAGS}" MJIT_OPTFLAGS="" MJIT_DEBUGFLAGS=""
}

src_test() {
	local -x LD_LIBRARY_PATH="${S}${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"
	emake V=1 check
}

src_install() {
	# Remove the remaining bundled gems. We do this late in the process
	# since they are used during the build to e.g. create the
	# documentation.
	einfo "Removing default gems before installation"
	rm -rf lib/bundler* lib/rdoc/rdoc.gemspec || die

	# Ruby is involved in the install process, we don't want interference here.
	unset RUBYOPT

	local MINIRUBY=$(echo -e 'include Makefile\ngetminiruby:\n\t@echo $(MINIRUBY)'|make -f - getminiruby)

	local -x LD_LIBRARY_PATH="${S}:${ED}/usr/$(get_libdir)${LD_LIBRARY_PATH+:}${LD_LIBRARY_PATH}"

	local -x RUBYLIB="${S}:${ED}/usr/$(get_libdir)/ruby/${RUBYVERSION}"
	for d in $(find "${S}/ext" -type d) ; do
		RUBYLIB="${RUBYLIB}:$d"
	done

	# Create directory for the default gems
	local gem_home="${EPREFIX}/usr/$(get_libdir)/ruby/gems/${RUBYVERSION}"
	mkdir -p "${D}/${gem_home}" || die "mkdir gem home failed"

	emake V=1 DESTDIR="${D}" GEM_DESTDIR=${gem_home} install

	# Remove installed rubygems and rdoc copy
	rm -rf "${ED}/usr/$(get_libdir)/ruby/${RUBYVERSION}/rubygems" || die "rm rubygems failed"
	rm -rf "${ED}/usr/bin/"gem"${MY_SUFFIX}" || die "rm rdoc bins failed"
	rm -rf "${ED}/usr/$(get_libdir)/ruby/${RUBYVERSION}"/rdoc* || die "rm rdoc failed"
	rm -rf "${ED}/usr/bin/"{bundle,bundler,ri,rdoc}"${MY_SUFFIX}" || die "rm rdoc bins failed"

	if use doc; then
		emake DESTDIR="${D}" GEM_DESTDIR=${gem_home} install-doc
	fi

	if use examples; then
		dodoc -r sample
	fi

	dodoc ChangeLog NEWS.md doc/NEWS* README*
}

pkg_postinst() {
	if [[ ! -n $(readlink "${EROOT}"/usr/bin/ruby) ]] ; then
		eselect ruby set ruby${MY_SUFFIX}
	fi

	elog
	elog "To switch between available Ruby profiles, execute as root:"
	elog "\teselect ruby set ruby(30|31|...)"
	elog
}

pkg_postrm() {
	eselect ruby cleanup
}
