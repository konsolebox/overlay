# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: bash-build.eclass
# @MAINTAINER:
# konsolebox@gmail.com
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# Authors of app-shells/bash::gentoo
# @SUPPORTED_EAPIS: 7
# @BLURB: Eclass for building bash
# @DESCRIPTION:
# This eclass contains unified code for building bash.

# @ECLASS_VARIABLE: _BASH_BUILD_INSTALL_TYPE
# @DESCRIPTION:
# Indicates whether the installation type is 'system' or 'supplemental'
# @REQUIRED

# @ECLASS_VARIABLE: _BASH_BUILD_READLINE_VER
# @DESCRIPTION:
# Declares the required version of Readline.
# This doesn't have to be specified in *9999* ebuilds.

# @ECLASS_VARIABLE: _BASH_BUILD_PATCHES
# @DESCRIPTION:
# Specifies the patches

# @ECLASS_VARIABLE: _BASH_BUILD_PATCH_OPTIONS
# @DESCRIPTION:
# Specifies the options for epatch

# @ECLASS_VARIABLE: _BASH_BUILD_USE_ARCHIVED_PATCHES
# @DESCRIPTION:
# Whether to use patches from github.com/konsolebox/gentoo-bash-patches

[[ ${EAPI} == 7 ]] || die "EAPI needs to be 7."

inherit flag-o-matic toolchain-funcs multilib prefix
[[ ${PV} == *9999* ]] && inherit autotools git-r3

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"

if [[ ${PV%%.*} -ge 4 ]]; then
	LICENSE="GPL-3"
else
	LICENSE="GPL-2"
fi

MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}
MY_PV_PARTS=(${MY_PV//[.-]/ })

IUSE="afs bundled-readline mem-scramble +net nls +readline static vanilla"

if [[ ${_BASH_BUILD_INSTALL_TYPE} == system ]]; then
	SLOT=0
	IUSE+=" bashlogger examples plugins"

	if [[ MY_PV_PARTS -lt 4 || (MY_PV_PARTS -eq 4 && MY_PV_PARTS[1] -lt 3) ]]; then
		die "System bash must at least be version 4.3."
	fi
elif [[ ${_BASH_BUILD_INSTALL_TYPE} == supplemental ]]; then
	SLOT=${PV/_p/.} SLOT=${SLOT//_/-}
else
	die "Invalid install type: ${_BASH_BUILD_INSTALL_TYPE}"
fi

# @FUNCTION: _bash-build_get_patches
# @USAGE: [-s]
# @RETURN
# OK status (0) if there are patches, or FAIL status (1) otherwise.
# List of patches are stored in the __A0 variable.
# @INTERNAL
# @DESCRIPTION:
# Gets a list of official patches based on PLEVEL.
# Specifying '-s' returns the location of the files in the filesystem.
# Not specifying '-s' returns their remote URI.
_bash-build_get_patches() {
	local opt=$1 prefix=bash${MY_PV/\.} patches=() i s p

	for (( i = 1; i <= PLEVEL; ++i )); do
		printf -v 'patches[i]' "${prefix}-%03d" "${i}"
	done

	if [[ ${opt} == -s ]]; then
		__A0=("${patches[@]/#/${DISTDIR}/}")
	else
		__A0=()

		for s in "mirror://gnu/bash" "ftp://ftp.cwru.edu/pub/bash"; do
			__A0+=("${patches[@]/#/${s}/bash-${MY_PV}-patches/}")
		done
	fi

	[[ ${#__A0[@]} -gt 0 ]]
}

PLEVEL=0
MAY_USE_SYSTEM_READLINE=false
PATCH_COMMIT=693bbda26e14280fa11cfdbe8930f63355c00cc3

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/bash.git"

	if [[ ${PV} == 9999 ]]; then
		EGIT_BRANCH=master
	elif [[ ${PV} == 99999 ]]; then
		EGIT_BRANCH=devel
	else
		die "Invalid *9999* version"
	fi
elif [[ ${PV} == *_alpha* || ${PV} == *_beta* || ${PV} == *_rc* ]]; then
	SRC_URI="mirror://gnu/bash/bash-${MY_PV}.tar.gz ftp://ftp.cwru.edu/pub/bash/bash-${MY_PV}.tar.gz"
	S=${WORKDIR}/bash-${MY_PV}
else
	[[ ${SLOT} == 0 ]] && MAY_USE_SYSTEM_READLINE=true
	SRC_URI="mirror://gnu/bash/bash-${MY_PV}.tar.gz"
	[[ ${PV} == *_p* ]] && PLEVEL=${PV##*_p}
	[[ PLEVEL -gt 0 ]] && _bash-build_get_patches && SRC_URI+=" ${__A0[*]}"
	S=${WORKDIR}/bash-${MY_PV}
fi

[[ ${#_BASH_BUILD_PATCHES[@]} -gt 0 && ${_BASH_BUILD_USE_ARCHIVED_PATCHES} == true ]] && \
	SRC_URI+=" https://github.com/konsolebox/gentoo-bash-patches/archive/${PATCH_COMMIT}.tar.gz -> gentoo-bash-patches-${PATCH_COMMIT}.tar.gz"

if [[ ${MAY_USE_SYSTEM_READLINE} == true ]]; then
	[[ -z ${_BASH_BUILD_READLINE_VER-} ]] && die "Readline version needs to be provided."
	NON_STATIC_READLINE_DEP="readline? ( !bundled-readline? ( >=sys-libs/readline-${_BASH_BUILD_READLINE_VER}:0= ) )"
	STATIC_READLINE_DEP="readline? ( !bundled-readline? ( >=sys-libs/readline-${_BASH_BUILD_READLINE_VER}[static-libs(+)] ) )"
else
	NON_STATIC_READLINE_DEP=
	STATIC_READLINE_DEP=
	REQUIRED_USE="readline? ( bundled-readline )"
fi

RDEPEND="
	!static? (
		>=sys-libs/ncurses-5.9-r3:0=
		${NON_STATIC_READLINE_DEP}
	)
"

DEPEND="
	${RDEPEND}
	static? (
		>=sys-libs/ncurses-5.9-r3[static-libs(+)]
		${STATIC_READLINE_DEP}
	)
	nls? ( virtual/libintl )
	!<sys-apps/portage-2.1.6.7_p1
	!sys-libs/libtermcap-compat
"

BDEPEND="|| ( app-alternatives/yacc virtual/yacc )"

[[ ${SLOT} != 0 && ${PN} != bash ]] && RDEPEND+="!app-shells/bash:${SLOT}"

# @FUNCTION: bash-build_pkg_setup
# @DESCRIPTION:
# Implements pkg_setup
bash-build_pkg_setup() {
	if is-flag -malign-double ; then #7332
		eerror "Detected bad CFLAGS '-malign-double'.  Do not use this"
		eerror "as it breaks LFS (struct stat64) on x86."
		die "remove -malign-double from your CFLAGS mr ricer"
	fi

	if [[ ${SLOT} == 0 ]] && use bashlogger; then
		ewarn "The logging patch should ONLY be used in restricted (i.e. honeypot) envs."
		ewarn "This will log ALL output you enter into the shell, you have been warned."
	fi
}

# @FUNCTION: bash-build_src_unpack
# @DESCRIPTION:
# Implements src_unpack
bash-build_src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		unpack "bash-${MY_PV}.tar.gz"
	fi

	[[ ${#_BASH_BUILD_PATCHES[@]} -gt 0 && ${_BASH_BUILD_USE_ARCHIVED_PATCHES} == true ]] && \
		! use vanilla && \
			unpack "gentoo-bash-patches-${PATCH_COMMIT}.tar.gz"
}

# @FUNCTION: bash-build_src_prepare
# @DESCRIPTION:
# Implements src_prepare
bash-build_src_prepare() {
	# Include official patches
	[[ PLEVEL -gt 0 ]] && _bash-build_get_patches -s && eapply -p0 "${__A0[@]}"

	if ! use bundled-readline; then
		# Clean out local libs so we know we use system ones
		rm -rf lib/{readline,termcap}/* || die
		touch lib/{readline,termcap}/Makefile.in || die # for config.status
		sed -ri -e 's:\$[{(](RL|HIST)_LIBSRC[)}]/[[:alpha:]_-]*\.h::g' Makefile.in || die
	fi

	# Prefixify hardcoded path names. No-op for non-prefix.
	[[ -e pathnames.h.in ]] && hprefixify pathnames.h.in

	# Avoid regenerating docs after patches #407985
	sed -i -r '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in || die
	touch -r . doc/*

	if [[ ${#_BASH_BUILD_PATCHES[@]} -gt 0 ]] && ! use vanilla; then
		local prefix=${FILESDIR%/}/
		[[ ${_BASH_BUILD_USE_ARCHIVED_PATCHES} == true ]] && \
			prefix=${WORKDIR}/gentoo-bash-patches-${PATCH_COMMIT}/patches/
		eapply "${_BASH_BUILD_PATCH_OPTIONS[@]}" "${_BASH_BUILD_PATCHES[@]/#/${prefix}}"
	fi

	eapply_user
	[[ ${PV} == *9999* ]] && eautoreconf
}

# @FUNCTION: bash-build_src_configure
# @USAGE: [additional-econf-options]
# @DESCRIPTION:
# Implements src_configure
bash-build_src_configure() {
	local conf=(
		--with-curses
		$(use_with afs)
		$(use_enable net net-redirections)
		--disable-profiling
		$(use_enable mem-scramble)
		$(use_with mem-scramble bash-malloc)
		$(use_enable readline)
		$(use_enable readline history)
		$(use_enable readline bang-history)
		"$@"
	)

	if [[ MY_PV_PARTS -lt 4 ]]; then
		# Force pgrp synchronization
		# https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=81653
		export bash_cv_pgrp_pipe=yes
	fi

	# For descriptions of these, see config-top.h
	# bashrc/#26952 bash_logout/#90488 ssh/#24762
	append-cppflags \
		-DDEFAULT_PATH_VALUE=\'\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"\' \
		-DSTANDARD_UTILS_PATH=\'\"/bin:/usr/bin:/sbin:/usr/sbin\"\' \
		-DSYS_BASHRC=\'\"/etc/bash/bashrc\"\' \
		-DSYS_BASH_LOGOUT=\'\"/etc/bash/bash_logout\"\' \
		-DNON_INTERACTIVE_LOGIN_SHELLS \
		-DSSH_SOURCE_BASHRC

	if [[ MY_PV_PARTS -le 3 || (MY_PV_PARTS -eq 4 && MY_PV_PARTS[1] -le 3) ]]; then
		append-cppflags -DUSE_MKTEMP -DUSE_MKSTEMP # mktemp/#574426
	fi

	if [[ ${SLOT} == 0 ]]; then
		use bashlogger && append-cppflags -DSYSLOG_HISTORY

		if use plugins; then
			append-ldflags "-Wl,-rpath,${EPREFIX}/usr/$(get_libdir)/bash"
		else
			# Disable the plugins logic by hand since bash doesn't
			# provide a way of doing it.
			export ac_cv_func_dl{close,open,sym}=no ac_cv_lib_dl_dlopen=no ac_cv_header_dlfcn_h=no
			sed -i -e '/LOCAL_LDFLAGS=/s:-rdynamic::' configure || die
		fi
	fi

	use static && append-ldflags -static
	use nls || conf+=( --disable-nls )

	if ! use bundled-readline; then
		conf+=( --with-installed-readline=. )
		export ac_cv_rl_version=${_BASH_BUILD_READLINE_VER%%_*}
	fi

	tc-export AR #444070
	econf "${conf[@]}"
}

# @FUNCTION: bash-build_src_compile
# @DESCRIPTION:
# Implements src_compile
bash-build_src_compile() {
	emake || die "emake failed"
	[[ ${SLOT} == 0 ]] && use plugins && emake -C examples/loadables all others
}

# @FUNCTION: bash-build_src_install
# @DESCRIPTION:
# Implements src_install
bash-build_src_install() {
	if [[ ${SLOT} == 0 ]]; then
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
		use readline || sed_args+=(-e '/^shopt -s histappend/s:^:#:'
				-e 's:use_color=true:use_color=false:') #432338
		sed -i "${sed_args[@]}" "${ED%/}"/etc/skel/.bashrc "${ED%/}"/etc/bash/bashrc || die

		if use plugins; then
			exeinto "/usr/$(get_libdir)/bash"
			local loadables=(examples/loadables/*.o)
			[[ ${#loadables[@]} -gt 0 && -e ${loadables} ]] && doexe "${loadables[@]%.o}"
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
	else
		into /
		newbin bash "bash-${SLOT}"
		newman doc/bash.1 "bash-${SLOT}.1"
		newman doc/builtins.1 "builtins-${SLOT}.1"
		insinto /usr/share/info
		newins doc/bashref.info "bash-${SLOT}.info"
		dosym "bash-${SLOT}.info" "/usr/share/info/bashref-${SLOT}.info"
		dodoc README NEWS AUTHORS CHANGES COMPAT Y2K doc/FAQ doc/INTRO
	fi
}

# @FUNCTION: bash-build_pkg_preinst
# @DESCRIPTION:
# Implements pkg_preinst
bash-build_pkg_preinst() {
	if [[ ${SLOT} == 0 ]]; then
		if [[ -e ${EROOT}/etc/bashrc && ! -d ${EROOT}/etc/bash ]]; then
			mkdir -p "${EROOT}"/etc/bash
			mv -f "${EROOT}"/etc/bashrc "${EROOT}"/etc/bash/
		fi
	fi
}

# @FUNCTION: bash-build_pkg_postinst
# @DESCRIPTION:
# Implements pkg_postinst
bash-build_pkg_postinst() {
	if [[ ${SLOT} == 0 ]]; then
		# If /bin/sh does not exist, provide it.
		[[ -e ${EROOT}/bin/sh ]] || ln -sf bash "${EROOT}"/bin/sh
	fi
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install \
		pkg_preinst pkg_postinst
