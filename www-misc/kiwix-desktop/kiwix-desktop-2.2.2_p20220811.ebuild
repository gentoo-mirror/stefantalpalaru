# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_COMMIT="7d8b26368d28955235dafe0bf23c6243f6ea4ae8"

DESCRIPTION="cross-platform viewer/manager for ZIM archives"
HOMEPAGE="https://kiwix.org/"
#SRC_URI="https://github.com/kiwix/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/kiwix/kiwix-desktop/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtimageformats:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5
	www-misc/kiwix-lib
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/kiwix-desktop-${MY_COMMIT}"

src_compile()
{
	eqmake5 PREFIX=/usr .
	emake
}

src_install()
{
	emake install INSTALL_ROOT="${ED}"
}
