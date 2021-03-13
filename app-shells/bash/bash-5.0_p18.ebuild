# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs multilib prefix
[[ ${PV} == *9999* ]] && inherit git-r3

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"
LICENSE="GPL-3"

IUSE="afs bashlogger bundled-readline examples mem-scramble +net nls plugins +readline vanilla"
SLOT=0

MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}
MY_P=${PN}-${MY_PV}

get_patches() {
	local opt=$1 prefix=${PN}${MY_PV/\.} patches=() i v s p

	for (( i = 1; i <= PLEVEL; ++i )); do
		v=${i}
		[[ i -le 999 ]] && v=00${v} v=${v:(-3)}
		patches[i]=${prefix}-${v}
	done

	if [[ ${opt} == -s ]]; then
		__A0=("${patches[@]/#/${DISTDIR}/}")
	else
		__A0=() i=0

		for s in "ftp://ftp.cwru.edu/pub/bash" "mirror://gnu/${PN}"; do
			for p in "${patches[@]}"; do
				__A0[i++]=${s}/${PN}-${MY_PV}-patches/${p}
			done
		done
	fi

	[[ ${#__A0[@]} -gt 0 ]]
}

PLEVEL=0

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/bash.git"
	[[ ${PV} == 99999 ]] && EGIT_BRANCH=devel
	REQUIRED_USE="readline? ( bundled-readline )"
elif [[ ${PV} == *_alpha* || ${PV} == *_beta* || ${PV} == *_rc* ]]; then
	SRC_URI="ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz"
	REQUIRED_USE="readline? ( bundled-readline )"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	READLINE_VER="8.0" # The version of readline this version of bash normally ships with.

	SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz"
	[[ ${PV} == *_p* ]] && PLEVEL=${PV##*_p}
	[[ PLEVEL -gt 0 ]] && get_patches && SRC_URI+=" ${__A0[*]}"

	PATCHES=(
		# Patches from Chet sent to bashbug ml
		"${FILESDIR}/${PN}-5.0-history-append.patch"
		"${FILESDIR}/${PN}-5.0-syslog-history-extern.patch"
	)
fi

DEPEND="
	>=sys-libs/ncurses-5.9-r3:0=
	readline? ( !bundled-readline? ( >=sys-libs/readline-${READLINE_VER:-0}:0= ) )
	nls? ( virtual/libintl )
"

RDEPEND="
	${DEPEND}
	!<sys-apps/portage-2.1.6.7_p1
"

# We only need yacc when the .y files get patched (bash42-005)
# DEPEND+=" virtual/yacc"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use bashlogger; then
		ewarn "The logging patch should ONLY be used in restricted (i.e. honeypot) envs."
		ewarn "This will log ALL output you enter into the shell, you have been warned."
	fi
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		unpack "${MY_P}.tar.gz"
	fi
}

src_prepare() {
	# Include official patches
	[[ PLEVEL -gt 0 ]] && get_patches -s && eapply -p0 "${__A0[@]}"

	# Clean out local libs so we know we use system ones when bundled-readline is disabled.
	if ! use bundled-readline; then
		rm -rf lib/{readline,termcap}/*
		touch lib/{readline,termcap}/Makefile.in # for config.status
		sed -ri -e 's:\$[(](RL|HIST)_LIBSRC[)]/[[:alpha:]]*.h::g' Makefile.in || die
	fi

	# Prefixify hardcoded path names.  No-op for non-prefix.
	hprefixify pathnames.h.in

	# Avoid regenerating docs after patches #407985
	sed -i -r '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in || die
	touch -r . doc/*

	[[ ${#PATCHES[@]} -gt 0 ]] && ! use vanilla && eapply -p0 "${PATCHES[@]}"
	eapply_user
}

src_configure() {
	local myconf=(
		--disable-profiling
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
		-DDEFAULT_PATH_VALUE="'\"${EPREFIX}/usr/local/sbin:${EPREFIX}/usr/local/bin:${EPREFIX}/usr/sbin:${EPREFIX}/usr/bin:${EPREFIX}/sbin:${EPREFIX}/bin\"'" \
		-DSTANDARD_UTILS_PATH="'\"${EPREFIX}/bin:${EPREFIX}/usr/bin:${EPREFIX}/sbin:${EPREFIX}/usr/sbin\"'" \
		-DSYS_BASHRC="'\"${EPREFIX}/etc/bash/bashrc\"'" \
		-DSYS_BASH_LOGOUT="'\"${EPREFIX}/etc/bash/bash_logout\"'" \
		-DNON_INTERACTIVE_LOGIN_SHELLS \
		-DSSH_SOURCE_BASHRC \
		$(use bashlogger && echo -DSYSLOG_HISTORY)

	# Don't even think about building this statically without
	# reading Bug 7714 first.  If you still build it statically,
	# don't come crying to us with bugs ;).
	#
	# use static && export LDFLAGS="${LDFLAGS} -static"

	use nls || myconf+=(--disable-nls)

	# Use system readline unless bundled-readline is set.
	#
	# Historically, we always used the builtin readline, but since
	# our handling of SONAME upgrades has gotten much more stable
	# in the PM (and the readline ebuild itself preserves the old
	# libs during upgrades), linking against the system copy should
	# be safe.
	if ! use bundled-readline; then
		myconf+=(--with-installed-readline=.)

		# Exact cached version here doesn't really matter as long as it
		# is at least what's in the DEPEND up above.
		export ac_cv_rl_version=${READLINE_VER%%_*}
	fi

	if use plugins; then
		append-ldflags "-Wl,-rpath,/usr/$(get_libdir)/bash"
	else
		# Disable the plugins logic by hand since bash doesn't
		# provide a way of doing it.
		export ac_cv_func_dl{close,open,sym}=no ac_cv_lib_dl_dlopen=no ac_cv_header_dlfcn_h=no
		sed -i -e '/LOCAL_LDFLAGS=/s:-rdynamic::' configure || die
	fi

	tc-export AR #444070
	econf "${myconf[@]}"
}

src_compile() {
	emake
	use plugins && emake -C examples/loadables all others
}

src_install() {
	default

	dodir /bin
	mv "${ED%/}"/usr/bin/bash "${ED%/}"/bin/ || die
	dosym bash /bin/rbash

	insinto /etc/bash
	doins "${FILESDIR}"/bash_logout
	doins "$(prefixify_ro "${FILESDIR}"/bashrc)"
	keepdir /etc/bash/bashrc.d

	local f d
	insinto /etc/skel

	for f in bash{_logout,_profile,rc}; do
		newins "${FILESDIR}/dot-${f}" ".${f}"
	done

	local sed_args=(-e "s:#${USERLAND}#@::" -e '/#@/d')

	if ! use readline; then
		#432338
		sed_args+=(-e '/^shopt -s histappend/s:^:#:' -e 's:use_color=true:use_color=false:')
	fi

	sed -i "${sed_args[@]}" "${ED%/}"/etc/skel/.bashrc "${ED%/}"/etc/bash/bashrc || die

	if use plugins; then
		exeinto /usr/$(get_libdir)/bash
		local loadables=(examples/loadables/*.o)
		[[ ${#loadables[@]} -gt 0 ]] && doexe "${loadables[@]%.o}"
		insinto /usr/include/bash-plugins
		doins *.h builtins/*.h include/*.h lib/{glob/glob.h,tilde/tilde.h}
	fi

	if use examples; then
		for d in examples/{functions,misc,scripts,startup-files}; do
			exeinto "/usr/share/doc/${PF}/${d}"
			insinto "/usr/share/doc/${PF}/${d}"

			for f in "${d}"/*; do
				if [[ ${f##*/} != PERMISSION && ${f##*/} != *README ]]; then
					doexe "${f}"
				else
					doins "${f}"
				fi
			done
		done
	fi

	doman doc/*.1
	newdoc CWRU/changelog ChangeLog
	dosym bash.info /usr/share/info/bashref.info
}

pkg_preinst() {
	if [[ -e ${EROOT}/etc/bashrc && ! -d ${EROOT}/etc/bash ]]; then
		mkdir -p "${EROOT}"/etc/bash
		mv -f "${EROOT}"/etc/bashrc "${EROOT}"/etc/bash/
	fi

	if [[ -L ${EROOT}/bin/sh ]] ; then
		# Rewrite the symlink to ensure that its mtime changes.  Having /bin/sh
		# missing even temporarily causes a fatal error with paludis.
		local target=$(readlink "${EROOT}"/bin/sh)
		ln -sf "${target}" "${T}"/sh
		mv -f "${T}"/sh "${EROOT}"/bin/sh
	fi
}

pkg_postinst() {
	# If /bin/sh does not exist, provide it.
	[[ -e ${EROOT}/bin/sh ]] || ln -sf bash "${EROOT}"/bin/sh
}
