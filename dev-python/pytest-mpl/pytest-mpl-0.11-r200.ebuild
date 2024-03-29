# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DOCS=( README.rst CHANGES.md )

DESCRIPTION="pytest plugin to faciliate image comparison for matplotlib figures"
HOMEPAGE="https://github.com/matplotlib/pytest-mpl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]
	dev-python/nose:python2[${PYTHON_USEDEP}]
	dev-python/pytest:python2[${PYTHON_USEDEP}]
	!<dev-python/pytest-mpl-0.11-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	echo "backend : Agg" > "${T}"/matplotlibrc || die
	MPLCONFIGDIR="${T}" virtx py.test -v
}
