# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Software library for solar physics based on Python"
HOMEPAGE="https://sunpy.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="jpeg2k test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/astropy-2[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4-python2[${PYTHON_USEDEP}]
	dev-python/matplotlib-python2[${PYTHON_USEDEP}]
	>=dev-python/numpy-python2-1.11[${PYTHON_USEDEP}]
	dev-python/pandas:python2[${PYTHON_USEDEP}]
	dev-python/requests:python2[${PYTHON_USEDEP}]
	dev-python/sqlalchemy:python2[${PYTHON_USEDEP}]
	dev-python/suds:python2[${PYTHON_USEDEP}]
	dev-python/scipy-python2[${PYTHON_USEDEP}]
	sci-libs/scikits_image[${PYTHON_USEDEP}]
	jpeg2k? ( dev-python/glymur[${PYTHON_USEDEP}] )
	!<dev-python/sunpy-0.9.10-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-mpl[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/sunpy-0.9.10-future.builtins.patch
)

python_prepare_all() {
	# use system astropy-helpers instead of bundled one
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m pytest sunpy -k "not figure and not online" || die
}
