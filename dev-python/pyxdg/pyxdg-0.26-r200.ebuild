# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=${PN}-rel-${PV}
DESCRIPTION="A Python module to deal with freedesktop.org specifications"
HOMEPAGE="https://freedesktop.org/wiki/Software/pyxdg
		https://cgit.freedesktop.org/xdg/pyxdg/"
# official mirror of the git repo
SRC_URI="https://github.com/takluyver/pyxdg/archive/rel-${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		x11-themes/hicolor-icon-theme
	)"
RDEPEND="
	!<dev-python/pyxdg-0.26-r200[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}

python_test() {
	nosetests -v || die
}
