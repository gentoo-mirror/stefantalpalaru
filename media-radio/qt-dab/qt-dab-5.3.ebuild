# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PV="4.6-${PV}"

inherit cmake desktop xdg

DESCRIPTION="software DAB decoder for use with a dabstick, airspy or sdrplay for RPI and PC"
HOMEPAGE="http://www.sdr-j.tk/
	https://github.com/JvanKatwijk/qt-dab"
SRC_URI="https://github.com/JvanKatwijk/qt-dab/archive/refs/tags/qt-dab-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/faad2
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/portaudio
	media-video/ffmpeg
	net-wireless/rtl-sdr
	sci-libs/fftw:3.0
	sys-libs/zlib
	virtual/libusb:1
	x11-libs/qwt:6"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PN}-${MY_PV}/qt-dab-s${SLOT}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DRTLSDR_LINUX=ON
		-DRTL_TCP=ON
		-DFDK_AAC=ON
	)
	if use cpu_flags_x86_sse; then
		mycmakeargs+=(
			-DVITERBI_SSE=ON
		)
	fi
	cmake_src_configure
}

src_install() {
	doicon qt-dab-${SLOT}.png
	domenu qt-dab-${SLOT}.desktop

	cd "${BUILD_DIR}"
	exeinto "/usr/bin"
	newexe "${P}" "${PN}-${SLOT}"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
