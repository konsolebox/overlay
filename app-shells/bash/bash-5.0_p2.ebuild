# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs multilib prefix

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-4.4-patches/
MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}
MY_P=${PN}-${MY_PV}
IS_RELEASE=false
[[ ${PV} != *_alpha* && ${PV} != *_beta* && ${PV} != *_rc* && ${PV} != *9999* ]] && IS_RELEASE=true
PLEVEL=${PV##*_p}
[[ ${PV} != *_p* ]] && PLEVEL=0

get_patches() {
	local opt=$1 plevel=${2:-${PLEVEL}} pn=${3:-${PN}} pv=${4:-${MY_PV}}
	local prefix=${pn}${pv/\.} patches=() i p s v

	for (( i = 1; i <= plevel; ++i )); do
		v=${i}
		[[ i -le 999 ]] && v=00${v} v=${v:(-3)}
		patches[i]=${prefix}-${v}
	done

	if [[ ${opt} == -s ]] ; then
		__A0=("${patches[@]/#/${DISTDIR}/}")
	else
		__A0=() i=0

		for s in "ftp://ftp.cwru.edu/pub/bash" "mirror://gnu/${pn}"; do
			for p in "${patches[@]}"; do
				__A0[i++]=${s}/${pn}-${pv}-patches/${p}
			done
		done
	fi
}

# The version of readline this bash normally ships with.
READLINE_VER="8.0"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"

if [[ ${IS_RELEASE} == true ]]; then
	get_patches
	SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz ${__A0[*]}"
else
	SRC_URI="ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="afs bashlogger bundled-readline examples mem-scramble +net nls plugins +readline"

DEPEND="
	>=sys-libs/ncurses-5.9-r3:0=
	readline? ( !bundled-readline? ( >=sys-libs/readline-${READLINE_VER}:0= ) )
	nls? ( virtual/libintl )
"
RDEPEND="
	${DEPEND}
	!<sys-apps/portage-2.1.6.7_p1
"
# we only need yacc when the .y files get patched (bash42-005)
#DEPEND+=" virtual/yacc"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use bashlogger ; then
		ewarn "The logging patch should ONLY be used in restricted (i.e. honeypot) envs."
		ewarn "This will log ALL output you enter into the shell, you have been warned."
	fi
}

src_unpack() {
	unpack ${MY_P}.tar.gz
}

src_prepare() {
	# Include official patches
	if [[ ${PLEVEL} -gt 0 ]]; then
		get_patches -s
		eapply -p0 "${__A0[@]}"
	fi

	# Clean out local libs so we know we use system ones w/releases.
	if ! use bundled-readline; then
		rm -rf lib/{readline,termcap}/*
		touch lib/{readline,termcap}/Makefile.in # for config.status
		sed -ri -e 's:\$[(](RL|HIST)_LIBSRC[)]/[[:alpha:]]*.h::g' Makefile.in || die
	fi

	# Prefixify hardcoded path names. No-op for non-prefix.
	hprefixify pathnames.h.in

	# Avoid regenerating docs after patches #407985
	sed -i -r '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in || die
	touch -r . doc/*

	eapply_user
}

src_configure() {
	local myconf=(
		--disable-profiling
		--docdir='$(datarootdir)'/doc/${PF}
		--htmldir='$(docdir)/html'
		--with-curses
		$(use_enable mem-scramble)
		$(use_enable net net-redirections)
		$(use_enable readline)
		$(use_enable readline bang-history)
		$(use_enable readline history)
		$(use_with afs)
		$(use_with mem-scramble bash-malloc)
	)

	# For descriptions of these, see config-top.h
	# bashrc/#26952 bash_logout/#90488 ssh/#24762 mktemp/#574426
	append-cppflags \
		-DDEFAULT_PATH_VALUE=\'\"${EPREFIX}/usr/local/sbin:${EPREFIX}/usr/local/bin:${EPREFIX}/usr/sbin:${EPREFIX}/usr/bin:${EPREFIX}/sbin:${EPREFIX}/bin\"\' \
		-DSTANDARD_UTILS_PATH=\'\"${EPREFIX}/bin:${EPREFIX}/usr/bin:${EPREFIX}/sbin:${EPREFIX}/usr/sbin\"\' \
		-DSYS_BASHRC=\'\"${EPREFIX}/etc/bash/bashrc\"\' \
		-DSYS_BASH_LOGOUT=\'\"${EPREFIX}/etc/bash/bash_logout\"\' \
		-DNON_INTERACTIVE_LOGIN_SHELLS \
		-DSSH_SOURCE_BASHRC \
		$(use bashlogger && echo -DSYSLOG_HISTORY)

	# Don't even think about building this statically without
	# reading Bug 7714 first.  If you still build it statically,
	# don't come crying to us with bugs ;).
	#use static && export LDFLAGS="${LDFLAGS} -static"
	use nls || myconf+=( --disable-nls )

	# Historically, we always used the builtin readline, but since
	# our handling of SONAME upgrades has gotten much more stable
	# in the PM (and the readline ebuild itself preserves the old
	# libs during upgrades), linking against the system copy should
	# be safe.
	# Exact cached version here doesn't really matter as long as it
	# is at least what's in the DEPEND up above.
	export ac_cv_rl_version=${READLINE_VER%%_*}

	# Use system readline unless bundled-readline is set.
	use bundled-readline || myconf+=( --with-installed-readline=. )

	if use plugins; then
		append-ldflags -Wl,-rpath,/usr/$(get_libdir)/bash
	else
		# Disable the plugins logic by hand since bash doesn't
		# provide a way of doing it.
		export ac_cv_func_dl{close,open,sym}=no \
			ac_cv_lib_dl_dlopen=no ac_cv_header_dlfcn_h=no
		sed -i \
			-e '/LOCAL_LDFLAGS=/s:-rdynamic::' \
			configure || die
	fi
	tc-export AR #444070
	econf "${myconf[@]}"
}

src_compile() {
	emake

	if use plugins ; then
		emake -C examples/loadables all others
	fi
}

src_install() {
	local d f

	default

	dodir /bin
	mv "${ED%/}"/usr/bin/bash "${ED%/}"/bin/ || die
	dosym bash /bin/rbash

	insinto /etc/bash
	doins "${FILESDIR}"/bash_logout
	doins "$(prefixify_ro "${FILESDIR}"/bashrc)"
	keepdir /etc/bash/bashrc.d
	insinto /etc/skel
	for f in bash{_logout,_profile,rc} ; do
		newins "${FILESDIR}"/dot-${f} .${f}
	done

	local sed_args=(
		-e "s:#${USERLAND}#@::"
		-e '/#@/d'
	)
	if ! use readline ; then
		sed_args+=( #432338
			-e '/^shopt -s histappend/s:^:#:'
			-e 's:use_color=true:use_color=false:'
		)
	fi
	sed -i \
		"${sed_args[@]}" \
		"${ED%/}"/etc/skel/.bashrc \
		"${ED%/}"/etc/bash/bashrc || die

	if use plugins ; then
		exeinto /usr/$(get_libdir)/bash
		doexe $(echo examples/loadables/*.o | sed 's:\.o::g')
		insinto /usr/include/bash-plugins
		doins *.h builtins/*.h include/*.h lib/{glob/glob.h,tilde/tilde.h}
	fi

	if use examples ; then
		for d in examples/{functions,misc,scripts,startup-files} ; do
			exeinto /usr/share/doc/${PF}/${d}
			insinto /usr/share/doc/${PF}/${d}
			for f in ${d}/* ; do
				if [[ ${f##*/} != PERMISSION ]] && [[ ${f##*/} != *README ]] ; then
					doexe ${f}
				else
					doins ${f}
				fi
			done
		done
	fi

	doman doc/*.1
	newdoc CWRU/changelog ChangeLog
	dosym bash.info /usr/share/info/bashref.info
}

pkg_preinst() {
	if [[ -e ${EROOT}/etc/bashrc ]] && [[ ! -d ${EROOT}/etc/bash ]] ; then
		mkdir -p "${EROOT}"/etc/bash
		mv -f "${EROOT}"/etc/bashrc "${EROOT}"/etc/bash/
	fi

	if [[ -L ${EROOT}/bin/sh ]] ; then
		# rewrite the symlink to ensure that its mtime changes. having /bin/sh
		# missing even temporarily causes a fatal error with paludis.
		local target=$(readlink "${EROOT}"/bin/sh)
		local tmp=$(emktemp "${EROOT}"/bin)
		ln -sf "${target}" "${tmp}"
		mv -f "${tmp}" "${EROOT}"/bin/sh
	fi
}

pkg_postinst() {
	# If /bin/sh does not exist, provide it
	if [[ ! -e ${EROOT}/bin/sh ]] ; then
		ln -sf bash "${EROOT}"/bin/sh
	fi
}
