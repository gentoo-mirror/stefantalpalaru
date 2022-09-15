# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1 xdg

MY_PN="DisplayCAL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Display calibration and characterization powered by Argyll CMS - Python3 fork"
HOMEPAGE="https://github.com/eoyilmaz/displaycal-py3"
SRC_URI="https://github.com/eoyilmaz/displaycal-py3/releases/download/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

DEPEND="
	media-gfx/argyllcms
	dev-python/build[${PYTHON_USEDEP}]
	dev-python/certifi:0[${PYTHON_USEDEP}]
	dev-python/distro:0[${PYTHON_USEDEP}]
	dev-python/pillow:0[${PYTHON_USEDEP}]
	dev-python/pychromecast[${PYTHON_USEDEP}]
	dev-python/send2trash:0[${PYTHON_USEDEP}]
	>=dev-python/wxpython-4.1.1[${PYTHON_USEDEP}]
	dev-python/zeroconf[${PYTHON_USEDEP}]
	>=x11-libs/libX11-1.3.3
	>=x11-apps/xrandr-1.3.2
	>=x11-libs/libXxf86vm-1.1.0
	>=x11-libs/libXinerama-1.1
	!!media-gfx/displaycal
"
RDEPEND="${DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
"

# Just in case someone renames the ebuild
S="${WORKDIR}/${MY_P}"

src_prepare() {
	# A "[bdist_wininst]" setting affects us, for some reason
	sed -i \
		-e '/^install_script/d' \
		setup.cfg || die

	# Don't install RPM and Debian scripts
	sed -i \
		-e 's/buildservice = True/pass/' \
		setup.py || die

	# Do not generate udev/hotplug files
	sed -e '/if os.path.isdir/s#/etc/udev/rules.d\|/etc/hotplug#\0-non-existant#' \
		-i DisplayCAL/setup.py || die

	# Prohibit setup from running xdg-* programs, resulting to sandbox violation
	sed -e '/if which/s#xdg-icon-resource#\0-non-existant#' \
		-e '/if which/s#xdg-desktop-menu#\0-non-existant#' \
		-i DisplayCAL/postinstall.py || die

	# Remove deprecated Encoding key from .desktop file
	sed -e '/Encoding=UTF-8/d' -i misc/*.desktop  || die

	# Remove x-world Media Type
	sed -e 's/x\-world\/x\-vrml\;//g' \
		-i misc/displaycal-vrml-to-x3d-converter.desktop || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	mv "${ED}/usr/share/doc/${MY_P}" "${ED}/usr/share/doc/${P}" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
