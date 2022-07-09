# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WANT_LIBTOOL="none"

inherit autotools eutils flag-o-matic multilib pax-utils python-utils-r1 toolchain-funcs multiprocessing

DESCRIPTION="Python 2.7 fork with new syntax, builtins, and libraries backported from Python3"
HOMEPAGE="https://github.com/naftaliharris/tauthon"
SRC_URI="https://github.com/naftaliharris/tauthon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PSF-2"
SLOT="2.8"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="-berkdb bluetooth build doc examples gdbm hardened ipv6 +lto +ncurses +pgo +readline sqlite +ssl +threads tk +wide-unicode wininst +xml"

# Do not add a dependency on dev-lang/python to this ebuild.
# If you need to apply a patch which requires python for bootstrapping, please
# run the bootstrap code on your dev box and include the results in the
# patchset. See bug 447752.

RDEPEND="app-arch/bzip2:=
	dev-libs/libffi:=
	>=sys-libs/zlib-1.1.3:=
	virtual/libcrypt:=
	virtual/libintl
	berkdb? ( || (
		sys-libs/db:6.0
		sys-libs/db:5.3
		sys-libs/db:4.8
	) )
	gdbm? ( sys-libs/gdbm:=[berkdb] )
	ncurses? ( >=sys-libs/ncurses-5.2:= )
	readline? ( >=sys-libs/readline-4.1:= )
	sqlite? ( >=dev-db/sqlite-3.3.8:3= )
	ssl? ( dev-libs/openssl:= )
	tk? (
		>=dev-lang/tcl-8.0:=
		>=dev-lang/tk-8.0:=
		dev-tcltk/blt:=
		dev-tcltk/tix
	)
	xml? ( >=dev-libs/expat-2.1 )
	!!<sys-apps/portage-2.1.9"
# bluetooth requires headers from bluez
DEPEND="${RDEPEND}
	bluetooth? ( net-wireless/bluez )
	virtual/pkgconfig
	>=sys-devel/autoconf-2.65
	!sys-devel/gcc[libffi(-)]"
RDEPEND+=" !build? ( app-misc/mime-types )
		"
	#doc? ( dev-python/python-docs:${SLOT} )"
PDEPEND=">=app-eselect/eselect-python-20140125-r1"

pkg_setup() {
	if use berkdb; then
		ewarn "'bsddb' module is out-of-date and no longer maintained inside"
		ewarn "dev-lang/tauthon. 'bsddb' and 'dbhash' modules have been additionally"
		ewarn "removed in Python 3. A maintained alternative of 'bsddb3' module"
		ewarn "is provided by dev-python/bsddb3."
	else
		if has_version "=${CATEGORY}/${PN}-${PV%%.*}*[berkdb]"; then
			ewarn "You are migrating from =${CATEGORY}/${PN}-${PV%%.*}*[berkdb]"
			ewarn "to =${CATEGORY}/${PN}-${PV%%.*}*[-berkdb]."
			ewarn "You might need to migrate your databases."
		fi
	fi
}

src_prepare() {
	# Ensure that internal copies of expat, libffi and zlib are not used.
	rm -r Modules/expat || die
	rm -r Modules/_ctypes/libffi* || die
	rm -r Modules/zlib || die

	if tc-is-cross-compiler; then
		local EPATCH_EXCLUDE="*_regenerate_platform-specific_modules*.patch"
	fi

	local PATCHES=(
		"${FILESDIR}/patches"
		"${FILESDIR}/python-2.7.5-nonfatal-compileall.patch"
		"${FILESDIR}/python-2.7.9-ncurses-pkg-config.patch"
		"${FILESDIR}/python-2.7.10-cross-compile-warn-test.patch"
		"${FILESDIR}/python-2.7.10-system-libffi.patch"
	)

	default

	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" \
		Lib/distutils/command/install.py \
		Lib/distutils/sysconfig.py \
		Lib/site.py \
		Lib/sysconfig.py \
		Lib/test/test_site.py \
		Makefile.pre.in \
		Modules/Setup.dist \
		Modules/getpath.c \
		setup.py || die "sed failed to replace @@GENTOO_LIBDIR@@"

	eautoreconf
}

src_configure() {
		# dbm module can be linked against berkdb or gdbm.
		# Defaults to gdbm when both are enabled, #204343.
		local disable
		use berkdb   || use gdbm || disable+=" dbm"
		use berkdb   || disable+=" _bsddb"
		# disable automagic bluetooth headers detection
		use bluetooth || export ac_cv_header_bluetooth_bluetooth_h=no
		use gdbm     || disable+=" gdbm"
		use ncurses  || disable+=" _curses _curses_panel"
		use readline || disable+=" readline"
		use sqlite   || disable+=" _sqlite3"
		use ssl      || export PYTHON_DISABLE_SSL="1"
		use tk       || disable+=" _tkinter"
		use xml      || disable+=" _elementtree pyexpat" # _elementtree uses pyexpat.
		export PYTHON_DISABLE_MODULES="${disable}"

		if ! use xml; then
			ewarn "You have configured Tauthon without XML support."
			ewarn "This is NOT a recommended configuration as you"
			ewarn "may face problems parsing any XML documents."
		fi

	if [[ -n "${PYTHON_DISABLE_MODULES}" ]]; then
		einfo "Disabled modules: ${PYTHON_DISABLE_MODULES}"
	fi

	if tc-is-gcc; then
		if [[ "$(gcc-major-version)" -ge 4 ]]; then
			append-flags -fwrapv
		fi

		# https://developers.redhat.com/blog/2020/06/25/red-hat-enterprise-linux-8-2-brings-faster-python-3-8-run-speeds
		if ver_test $(gcc-fullversion) -ge 5.3 ; then
			append-flags -fno-semantic-interposition
			append-ldflags -fno-semantic-interposition
		fi
	fi

	filter-flags -malign-double

	# https://bugs.gentoo.org/show_bug.cgi?id=50309
	if is-flagq -O3; then
		is-flagq -fstack-protector-all && replace-flags -O3 -O2
		use hardened && replace-flags -O3 -O2
	fi

	if tc-is-cross-compiler; then
		# Force some tests that try to poke fs paths.
		export ac_cv_file__dev_ptc=no
		export ac_cv_file__dev_ptmx=yes
	fi

	# Export CXX so it ends up in /usr/lib/python2.X/config/Makefile.
	tc-export CXX
	# The configure script fails to use pkg-config correctly.
	# http://bugs.python.org/issue15506
	export ac_cv_path_PKG_CONFIG=$(tc-getPKG_CONFIG)

	# Set LDFLAGS so we link modules with -ltauthon correctly.
	# Needed on FreeBSD unless Tauthon is already installed.
	# Please query BSD team before removing this!
	append-ldflags "-L."

	# LTO needs this
	if use lto; then
		append-ldflags "${CFLAGS}"
	fi

	local dbmliborder
	if use gdbm; then
		dbmliborder+="${dbmliborder:+:}gdbm"
	fi
	if use berkdb; then
		dbmliborder+="${dbmliborder:+:}bdb"
	fi

	BUILD_DIR="${WORKDIR}/${CHOST}"
	mkdir -p "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die

	local myeconfargs=(
		--with-fpectl
		--enable-shared
		$(use_enable ipv6)
		$(use_with threads)
		$(use wide-unicode && echo "--enable-unicode=ucs4" || echo "--enable-unicode=ucs2")
		$(use_enable pgo optimizations)
		$(use_with lto)
		--infodir='${prefix}/share/info'
		--mandir='${prefix}/share/man'
		--with-computed-gotos
		--with-dbmliborder="${dbmliborder}"
		--with-libc=""
		--enable-loadable-sqlite-extensions
		--with-system-expat
		--with-system-ffi
		--without-ensurepip
	)
	ECONF_SOURCE="${S}" OPT="" econf "${myeconfargs[@]}"

	if use threads && grep -q "#define POSIX_SEMAPHORES_NOT_ENABLED 1" pyconfig.h; then
		eerror "configure has detected that the sem_open function is broken."
		eerror "Please ensure that /dev/shm is mounted as a tmpfs with mode 1777."
		die "Broken sem_open function (bug 496328)"
	fi
}

src_compile() {
	# Ensure sed works as expected
	# https://bugs.gentoo.org/594768
	local -x LC_ALL=C

	# Prevent using distutils bundled by setuptools.
	# https://bugs.gentoo.org/823728
	export SETUPTOOLS_USE_DISTUTILS=stdlib
	export PYTHONSTRICTEXTENSIONBUILD=1

	# Save PYTHONDONTWRITEBYTECODE so that 'has_version' doesn't
	# end up writing bytecode & violating sandbox.
	# bug #831897
	local -x _PYTHONDONTWRITEBYTECODE=${PYTHONDONTWRITEBYTECODE}

	if use pgo; then
		# disable distcc and ccache
		export DISTCC_HOSTS=""
		export CCACHE_DISABLE=1

		# bug 660358
		local -x COLUMNS=80
		local -x PYTHONDONTWRITEBYTECODE=

		addpredict /usr/lib/tauthon2.8/site-packages
	fi

	# Avoid invoking pgen for cross-compiles.
	touch Include/graminit.h Python/graminit.c

	cd "${BUILD_DIR}" || die

	# extract the number of parallel jobs in MAKEOPTS
	echo ${MAKEOPTS} | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' > /dev/null
	if [ $? -eq 0 ]; then
		par_arg="-j$(echo ${MAKEOPTS} | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' | tail -n1 | egrep -o '[[:digit:]]+')"
	else
		par_arg=""
	fi
	export par_arg

	emake EXTRATESTOPTS="${par_arg} -uall,-audio -x test_distutils -x test_bdb -x test_runpy -x test_test_support"

	# Restore saved value from above.
	local -x PYTHONDONTWRITEBYTECODE=${_PYTHONDONTWRITEBYTECODE}

	# Work around bug 329499. See also bug 413751 and 457194.
	if has_version dev-libs/libffi[pax-kernel]; then
		pax-mark E tauthon
	else
		pax-mark m tauthon
	fi
}

src_test() {
	# Tests will not work when cross compiling.
	if tc-is-cross-compiler; then
		elog "Disabling tests due to crosscompiling."
		return
	fi

	cd "${BUILD_DIR}" || die

	# Skip failing tests.
	local skipped_tests="distutils gdb curses xpickle bdb runpy minidom xml_etree xml_etree_c"

	for test in ${skipped_tests}; do
		mv "${S}"/Lib/test/test_${test}.py "${T}"
	done

	# bug 660358
	local -x COLUMNS=80

	# Daylight saving time problem
	# https://bugs.python.org/issue22067
	# https://bugs.gentoo.org/610628
	local -x TZ=UTC

	# Rerun failed tests in verbose mode (regrtest -w).
	emake test TESTOPTS="-w -uall,-audio -x test_test_support ${par_arg}" < /dev/tty
	local result="$?"

	for test in ${skipped_tests}; do
		mv "${T}/test_${test}.py" "${S}"/Lib/test
	done

	elog "The following tests have been skipped:"
	for test in ${skipped_tests}; do
		elog "test_${test}.py"
	done

	elog "If you would like to run them, you may:"
	elog "cd '${EPREFIX}/usr/$(get_libdir)/tauthon${SLOT}/test'"
	elog "and run the tests separately."

	if [[ "${result}" -ne 0 ]]; then
		die "emake test failed"
	fi
}

src_install() {
	local libdir=${ED}/usr/$(get_libdir)/tauthon${SLOT}

	cd "${BUILD_DIR}" || die
	emake DESTDIR="${D}" altinstall

	# symlinks for autotools
	ln -s tauthon${SLOT} "${ED}/usr/$(get_libdir)/python${SLOT}"
	ln -s libtauthon${SLOT}.a "${ED}/usr/$(get_libdir)/libpython${SLOT}.a"
	ln -s libtauthon${SLOT}.so "${ED}/usr/$(get_libdir)/libpython${SLOT}.so"
	ln -s python${SLOT}-config "${ED}/usr/bin/tauthon${SLOT}-config"

	sed -e "s/\(LDFLAGS=\).*/\1/" -i "${libdir}/config/Makefile" || die "sed failed"

	# Fix collisions between different slots of Python.
	mv "${ED}/usr/bin/2to3" "${ED}/usr/bin/2to3-${SLOT}"
	mv "${ED}/usr/bin/pydoc" "${ED}/usr/bin/pydoc${SLOT}"
	mv "${ED}/usr/bin/idle" "${ED}/usr/bin/idle${SLOT}"
	rm -f "${ED}/usr/bin/smtpd.py"

	use berkdb || rm -r "${libdir}/"{bsddb,dbhash.py*,test/test_bsddb*} || die
	use sqlite || rm -r "${libdir}/"{sqlite3,test/test_sqlite*} || die
	use tk || rm -r "${ED}/usr/bin/idle${SLOT}" "${libdir}/"{idlelib,lib-tk} || die

	use threads || rm -r "${libdir}/multiprocessing" || die
	use wininst || rm -r "${libdir}/distutils/command/"wininst-*.exe || die

	dodoc "${S}"/Misc/{ACKS,HISTORY}

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/Tools
	fi
	insinto /usr/share/gdb/auto-load/usr/$(get_libdir) #443510
	local libname=$(printf 'e:\n\t@echo $(INSTSONAME)\ninclude Makefile\n' | \
		emake --no-print-directory -s -f - 2>/dev/null)
	newins "${S}"/Tools/gdb/libpython.py "${libname}"-gdb.py

	newconfd "${FILESDIR}/pydoc.conf" pydoc-${SLOT}
	newinitd "${FILESDIR}/pydoc.init" pydoc-${SLOT}
	sed \
		-e "s:@PYDOC_PORT_VARIABLE@:PYDOC${SLOT/./_}_PORT:" \
		-e "s:@PYDOC@:pydoc${SLOT}:" \
		-i "${ED}/etc/conf.d/pydoc-${SLOT}" "${ED}/etc/init.d/pydoc-${SLOT}" || die "sed failed"

	local -x EPYTHON=tauthon${SLOT}
	# if not using a cross-compiler, use the fresh binary
	if ! tc-is-cross-compiler; then
		cat > tauthon.wrap <<-EOF || die
			#!/bin/sh
			export LD_LIBRARY_PATH=\${PWD}\${LD_LIBRARY_PATH+:\${LD_LIBRARY_PATH}}
			exec ./tauthon "\${@}"
		EOF
		chmod +x tauthon.wrap || die
		local -x PYTHON=./tauthon.wrap
	else
		local -x PYTHON=${EPREFIX}/usr/bin/${EPYTHON}
	fi

	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_domodule epython.py

	# python-exec wrapping support
	local pymajor=${SLOT%.*}
	local scriptdir=${D}$(python_get_scriptdir)
	mkdir -p "${scriptdir}" || die
	# python and pythonX
	ln -s "../../../bin/tauthon${SLOT}" \
		"${scriptdir}/python${pymajor}" || die
	ln -s "python${pymajor}" \
		"${scriptdir}/python" || die
	# python-config and pythonX-config
	ln -s "../../../bin/python${SLOT}-config" \
		"${scriptdir}/python${pymajor}-config" || die
	ln -s "python${pymajor}-config" \
		"${scriptdir}/python-config" || die
	# 2to3, pydoc, pyvenv
	ln -s "../../../bin/2to3-${SLOT}" \
		"${scriptdir}/2to3" || die
	ln -s "../../../bin/pydoc${SLOT}" \
		"${scriptdir}/pydoc" || die
	# idle
	if use tk; then
		ln -s "../../../bin/idle${SLOT}" \
			"${scriptdir}/idle" || die
	fi
}

eselect_python_update() {
	if [[ -z "$(eselect python show)" || ! -f "${EROOT}usr/bin/$(eselect python show)" ]]; then
		eselect python update
	fi

	if [[ -z "$(eselect python show --python${PV%%.*})" || ! -f "${EROOT}usr/bin/$(eselect python show --python${PV%%.*})" ]]; then
		eselect python update --python${PV%%.*}
	fi
}

pkg_postinst() {
	eselect_python_update
}

pkg_postrm() {
	eselect_python_update
}
