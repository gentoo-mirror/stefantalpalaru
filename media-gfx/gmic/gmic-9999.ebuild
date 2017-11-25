# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 cmake-utils git-r3 qmake-utils

MY_PV=${PV//./}

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="http://gmic.eu/ https://github.com/dtschump/gmic"
EGIT_REPO_URI="https://github.com/dtschump/gmic.git"
EGIT_REPO_URI_2="https://github.com/c-koi/gmic-qt.git"
EGIT_REPO_URI_3="https://github.com/dtschump/gmic-community.git"

KEYWORDS=""

LICENSE="CeCILL-2 GPL-3"
SLOT="0"
IUSE="bash-completion +cli ffmpeg fftw gimp gimp-gtk graphicsmagick gui jpeg krita opencv openexr openmp png static-libs tiff X zart"
REQUIRED_USE="
	gimp? ( png fftw X )
	gimp-gtk? ( png fftw X )
	gui? ( png fftw X )
	krita? ( png fftw X )
	zart? ( fftw opencv openmp )
"

QT_DEPS="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
ZART_DEPS="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
"
COMMON_DEPEND="
	fftw? ( sci-libs/fftw:3.0[threads] )
	gimp? (
		${QT_DEPS}
		>=media-gfx/gimp-2.8.0
	)
	gimp-gtk? (
		>=media-gfx/gimp-2.4.0
	)
	graphicsmagick? ( media-gfx/graphicsmagick )
	gui? ( ${QT_DEPS} )
	jpeg? ( virtual/jpeg:0 )
	krita? ( ${QT_DEPS} )
	net-misc/curl
	opencv? ( >=media-libs/opencv-2.3.1a-r1 )
	openexr? (
		media-libs/ilmbase
		media-libs/openexr
	)
	png? ( media-libs/libpng:0= )
	sys-libs/zlib
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	zart? ( ${ZART_DEPS} )
"
RDEPEND="${COMMON_DEPEND}
	ffmpeg? ( media-video/ffmpeg:0 )
"
DEPEND="${COMMON_DEPEND}
	gimp? ( dev-qt/linguist-tools:5 )
	gui? ( dev-qt/linguist-tools:5 )
	krita? ( dev-qt/linguist-tools:5 )
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-9999-dynamic-linking.patch
	"${FILESDIR}"/${PN}-1.7.9-flags.patch
	"${FILESDIR}"/${PN}-9999-man.patch
)

GMIC_QT_DIR="gmic-qt"
GMIC_COMMUNITY_DIR="gmic-community"
S="${WORKDIR}/${PN}"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi

	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_unpack() {
	EGIT_CHECKOUT_DIR="${S}"
	git-r3_src_unpack

	if use gimp || use gui || use krita; then
		EGIT_REPO_URI="${EGIT_REPO_URI_2}"
		EGIT_CHECKOUT_DIR="${WORKDIR}/${GMIC_QT_DIR}"
		git-r3_src_unpack
	fi

	if use zart; then
		EGIT_REPO_URI="${EGIT_REPO_URI_3}"
		EGIT_CHECKOUT_DIR="${WORKDIR}/${GMIC_COMMUNITY_DIR}"
		git-r3_src_unpack
	fi
}

src_prepare() {
	#cp -a resources/CMakeLists.txt .
	cmake-utils_src_prepare

	if use gimp || use gui || use krita; then
		sed -i \
			-e '/CMAKE_CXX_FLAGS_RELEASE/d' \
			../${GMIC_QT_DIR}/CMakeLists.txt
		local S="${WORKDIR}/${GMIC_QT_DIR}"
		local PATCHES=(
			"${FILESDIR}"/${PN}-2.1.5-dynamic-linking-qt.patch
		)
		cmake-utils_src_prepare
	fi

	if use zart; then
		cd "${WORKDIR}/${GMIC_COMMUNITY_DIR}"
		eapply "${FILESDIR}"/${PN}-2.1.5-dynamic-linking-zart.patch
		cd - >/dev/null
	fi
}

src_configure() {
	local CMAKE_BUILD_TYPE="Release"

	local mycmakeargs=(
		-DBUILD_LIB=ON
		-DBUILD_LIB_STATIC=$(usex static-libs ON OFF)
		-DBUILD_CLI=$(usex cli ON OFF)
		-DBUILD_MAN=$(usex cli ON OFF)
		-DBUILD_BASH_COMPLETION=$(usex cli $(usex bash-completion ON OFF) OFF)
		-DBUILD_PLUGIN=$(usex gimp-gtk ON OFF)
		-DENABLE_X=$(usex X ON OFF)
		-DENABLE_FFMPEG=$(usex ffmpeg ON OFF)
		-DENABLE_FFTW=$(usex fftw ON OFF)
		-DENABLE_GRAPHICSMAGICK=$(usex graphicsmagick ON OFF)
		-DENABLE_JPEG=$(usex jpeg ON OFF)
		-DENABLE_OPENCV=$(usex opencv ON OFF)
		-DENABLE_OPENEXR=$(usex openexr ON OFF)
		-DENABLE_OPENMP=$(usex openmp ON OFF)
		-DENABLE_PNG=$(usex png ON OFF)
		-DENABLE_TIFF=$(usex tiff ON OFF)
		-DENABLE_ZLIB=ON
		-DENABLE_DYNAMIC_LINKING=ON
	)

	CMAKE_USE_DIR=${S}
	cmake-utils_src_configure

	# gmic-qt
	local CMAKE_USE_DIR="${WORKDIR}/${GMIC_QT_DIR}"
	local mycmakeargs=(
		-DENABLE_DYNAMIC_LINKING=ON
		-DGMIC_LIB_PATH="../${P}_build"
	)
	if use gimp; then
		local BUILD_DIR=${WORKDIR}/gimp_build
		mycmakeargs+=( -DGMIC_QT_HOST=gimp )
		cmake-utils_src_configure
	fi
	if use gui; then
		local BUILD_DIR=${WORKDIR}/gui_build
		mycmakeargs+=( -DGMIC_QT_HOST=none )
		cmake-utils_src_configure
	fi
	if use krita; then
		local BUILD_DIR=${WORKDIR}/krita_build
		mycmakeargs+=( -DGMIC_QT_HOST=krita )
		cmake-utils_src_configure
	fi

	# ZArt
	if use zart; then
		cd "${WORKDIR}/${GMIC_COMMUNITY_DIR}/zart"
		eqmake5 CONFIG+=enable_dynamic_linking GMIC_LIB_PATH="../../${P}_build" zart.pro
		cd -
	fi
}

src_compile() {
	cmake-utils_src_compile

	# gmic-qt
	local S="${WORKDIR}/${GMIC_QT_DIR}"
	if use gimp; then
		local BUILD_DIR="${WORKDIR}/gimp_build"
		cmake-utils_src_compile
	fi
	if use gui; then
		local BUILD_DIR="${WORKDIR}/gui_build"
		cmake-utils_src_compile
	fi
	if use krita; then
		local BUILD_DIR="${WORKDIR}/krita_build"
		cmake-utils_src_compile
	fi

	# ZArt
	if use zart; then
		cd "${WORKDIR}/${GMIC_COMMUNITY_DIR}/zart"
		emake
		cd -
	fi
}

src_install() {
	dodoc README

	# - the Gimp plugin dir is also searched by non-Gimp tools, and it's
	#   hardcoded in gmic_stdlib.gmic
	# - using the GMIC_SYSTEM_PATH env var to specify another system dir here
	#   might mean that this big file will be automatically downloaded in
	#   ~/.config/gmic/ when the user runs a tool before updating and sourcing
	#   the new environment
	local PLUGIN_DIR="/usr/lib/gimp/2.0/plug-ins/"
	insinto "${PLUGIN_DIR}"
	doins "resources/gmic_film_cluts.gmz"

	cmake-utils_src_install
	use cli && use bash-completion && newbashcomp "resources/${PN}_bashcompletion.sh" ${PN}

	# gmic-qt
	if use gimp; then
		exeinto "${PLUGIN_DIR}"
		doexe "${WORKDIR}/gimp_build/gmic_gimp_qt"
	fi
	if use gui; then
		dobin "${WORKDIR}/gui_build/gmic_qt"
	fi
	if use krita; then
		dobin "${WORKDIR}/krita_build/gmic_krita_qt"
	fi

	# ZArt
	if use zart; then
		dobin "${WORKDIR}/${GMIC_COMMUNITY_DIR}/zart/zart"
	fi
}
