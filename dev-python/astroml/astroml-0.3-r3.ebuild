# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

MYPN=astroML
MYP=${MYPN}-${PV}

DESCRIPTION="Python Machine Learning library for astronomy"
HOMEPAGE="http://www.astroml.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]
	dev-python/numpy-python2[${PYTHON_USEDEP}]
	dev-python/scipy-python2[${PYTHON_USEDEP}]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYP}"

DOCS=( CHANGES.rst README.rst )

python_test() {
	virtx nosetests --verbose || die
}

python_install_all() {
	distutils-r1_python_install_all
	docinto /usr/share/doc/${PF}
	use examples && dodoc -r examples
}
