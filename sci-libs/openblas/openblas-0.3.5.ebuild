# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NUMERIC_MODULE_NAME="openblas"

inherit alternatives-2 eutils multilib numeric numeric-int64-multibuild

DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="http://xianyi.github.com/OpenBLAS/"
SRC_URI="https://github.com/xianyi/OpenBLAS/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="dynamic openmp static-libs threads"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/openblas/openblas_config.h
)

get_openblas_flags() {
	local openblas_flags=( NO_LAPACK=1 NO_LAPACKE=1 )
	use dynamic && \
		openblas_flags+=( DYNAMIC_ARCH=1 NUM_THREADS=64 NO_AFFINITY=1 )
	$(numeric-int64_is_int64_build) && \
		openblas_flags+=( INTERFACE64=1 )
	# choose posix threads over openmp when the two are set
	# yet to see the need of having the two profiles simultaneously
	if use threads; then
		openblas_flags+=( USE_THREAD=1 USE_OPENMP=0 )
	elif use openmp; then
		openblas_flags+=( USE_OPENMP=1 )
	else
		openblas_flags+=( USE_THREAD=0 ) # single-threaded
	fi
	local profname=$(numeric-int64_get_module_name)
	local libname="${profname//-/_}"
	local underscoresuffix="${libname#${PN}}"
	if [[ "${underscoresuffix}" != "_" ]]; then
		local libnamesuffix="${underscoresuffix#_}"
		openblas_flags+=( LIBNAMESUFFIX=${libnamesuffix} )
	fi

	[[ "${ABI}" == "x86" ]] && openblas_flags+=( BINARY=32 )

	echo "${openblas_flags[@]}"
}

get_openblas_abi_cflags() {
	local openblas_abi_cflags=()
	if [[ "${ABI}" == "x86" ]]; then
		openblas_abi_cflags=( -DARCH_X86=1 -DOPENBLAS___32BIT__=1 )
	elif [[ "${ABI}" == "amd64" ]]; then
		openblas_abi_cflags=( -DARCH_X86_64=1 -DOPENBLAS___64BIT__=1 )
	elif [[ "${ABI}" == "ppc64" ]]; then
		openblas_abi_cflags=( -DARCH_POWER=1 -DOPENBLAS___64BIT__=1 )
	else
		die "unsupported abi: ${ABI}"
	fi
	$(numeric-int64_is_int64_build) && \
		openblas_abi_cflags+=( -DOPENBLAS_USE64BITINT )
	use openmp && openblas_abi_cflags+=( -fopenmp )
	echo "${openblas_abi_cflags[@]}"
}

src_unpack() {
	default
	find "${WORKDIR}" -maxdepth 1 -type d -name \*OpenBLAS\* && \
		mv "${WORKDIR}"/*OpenBLAS* "${S}" || die
}

src_prepare() {
	default

	numeric-int64-multibuild_copy_sources
}

src_configure() {
	blas_configure() {
		local openblas_abi_cflags="$(get_openblas_abi_cflags)"
		local internal_openblas_abi_cflags="${openblas_abi_cflags//OPENBLAS_}"
		sed \
			-e "s:^#\s*\(CC\)\s*=.*:\1=$(tc-getCC) $(get_abi_CFLAGS):" \
			-e "s:^#\s*\(FC\)\s*=.*:\1=$(tc-getFC) $(get_abi_CFLAGS):" \
			-e "s:^#\s*\(COMMON_OPT\)\s*=.*:\1=${CFLAGS} ${internal_openblas_abi_cflags}:" \
			-i Makefile.rule || die
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir blas_configure
}

src_compile() {
	# openblas already does multi-jobs
	MAKEOPTS+=" -j1"
	my_src_compile () {
		local openblas_flags=$(get_openblas_flags)
		# cflags already defined twice
		unset CFLAGS || die
		emake clean && emake libs shared NO_STATIC=1 ${openblas_flags}
		mkdir -p libs && mv libopenblas* libs/ || die
		# avoid pic when compiling static libraries, so re-compiling
		if use static-libs; then
			emake clean
			emake libs ${openblas_flags} NO_SHARED=1 NEED_PIC=
			mv libopenblas* libs/ || die
		fi

		mv libs/libopenblas* . || die
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir my_src_compile
}

src_test() {
	my_src_test () {
		local openblas_flags=$(get_openblas_flags)
		emake tests ${openblas_flags}
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir my_src_test
}

src_install() {
	my_src_install() {
		local openblas_flags=$(get_openblas_flags)
		local profname=$(numeric-int64_get_module_name)
		local pcfile
		# The file /usr/include/openblas/openblas_config.h is generated during the install.
		# The sed on config_last.h removes the #define's OPENBLAS_USE64BITINT
		# OPENBLASS__32BIT__ OPENBLASS__64BIT__ OPENBLAS__ARCH_X86 OPENBLAS__ARCH_X86_64
		# from /usr/include/openblas/openblas_config.h.  We then specify it in Cflags in
		# the /usr/lib64/pkg-config/openblas-int64-{threads,openmp}.pc file.
		sed -e '/#define USE64BITINT/d' \
			-e '/#define ARCH_X86/d' \
			-e '/#define __\(32\|64\)BIT__/d' \
			-i config_last.h \
			|| die "Could not ensure there is no definition of USE64BITINT in config_last.h"
		emake install \
			DESTDIR="${D}" PREFIX="${EPREFIX}" ${openblas_flags} \
			OPENBLAS_INCLUDE_DIR='$(PREFIX)'/usr/include/${PN} \
			OPENBLAS_LIBRARY_DIR='$(PREFIX)'/usr/$(get_libdir)
		if ! use static-libs; then
			rm "${ED}"usr/$(get_libdir)/lib*.a || die
		fi

		local openblas_abi_cflags=$(get_openblas_abi_cflags)
		local openblas_abi_fflags=$(numeric-int64_get_fortran_int64_abi_fflags)
		local libname="${profname//-/_}"

		create_pkgconfig \
			--name "${profname}" \
			--libs "-l${libname}" \
			--libs-private "-lm" \
			--cflags "-I\${includedir}/${PN} ${openblas_abi_cflags}" \
			${profname}

		if [[ ${CHOST} == *-darwin* ]] ; then
			cd "${ED}"/usr/$(get_libdir) || die
			local d
			for d in *.dylib; do
				ebegin "Correcting install_name of ${d}"
				install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/${d}" "${d}" || die
				eend $?
			done
		fi
		if [[ ${#MULTIBUILD_VARIANTS[@]} -gt 1 ]]; then
			multilib_prepare_wrappers
			multilib_check_headers
		fi
	}
	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir my_src_install

	printf "/usr/include/cblas.h ${PN}/cblas.h" > "${T}"/alternative-cblas-generic.sh || die
	numeric-int64-multibuild_install_alternative blas ${NUMERIC_MODULE_NAME}
	numeric-int64-multibuild_install_alternative cblas ${NUMERIC_MODULE_NAME}

	multilib_install_wrappers

	dodoc GotoBLAS_{01Readme,03FAQ,04FAQ,05LargePage,06WeirdPerformance}.txt *md Changelog.txt
}
