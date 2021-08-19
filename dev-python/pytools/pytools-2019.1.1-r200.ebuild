# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite'

inherit distutils-r1

DESCRIPTION="Collection of tools missing from the Python standard library"
HOMEPAGE="https://mathema.tician.de/software/pytools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/appdirs-1.4.0:python2[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.2.0:python2[${PYTHON_USEDEP}]
	>=dev-python/numpy-python2-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.8.0:python2[${PYTHON_USEDEP}]
	!<dev-python/pytools-2019.1.1-r200[${PYTHON_USEDEP}]
"
DEPEND="
	>=dev-python/setuptools-0.7.2[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}
