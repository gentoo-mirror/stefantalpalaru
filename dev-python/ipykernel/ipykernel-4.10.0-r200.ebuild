# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="https://github.com/ipython/ipykernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	<dev-python/ipython-6[${PYTHON_USEDEP}]
	dev-python/jupyter_client:python2[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.1.0:python2[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.0:python2[${PYTHON_USEDEP}]
	!<dev-python/ipykernel-4.10.0-r3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose_warnings_filters[${PYTHON_USEDEP}]
	)
"

python_install() {
	distutils-r1_python_install

	# bug 628222, specify python 2 or 3.
	sed -e "/language/!s:python:${EPYTHON%.*}:" \
		-i "${ED}"/usr/share/jupyter/kernels/${EPYTHON%.*}/kernel.json || die
}

python_test() {
	nosetests --verbose ipykernel || die
}
