# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Task scheduling and blocked algorithms for parallel processing"
HOMEPAGE="http://dask.pydata.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="distributed test"

RDEPEND="
	>=dev-python/cloudpickle-0.2.1:python2[${PYTHON_USEDEP}]
	>=dev-python/numpy-python2-1.11[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.23.4:python2[${PYTHON_USEDEP}]
	>=dev-python/partd-0.3.8:python2[${PYTHON_USEDEP}]
	dev-python/psutil:python2[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.7.3:python2[${PYTHON_USEDEP}]
	distributed? (
		  >=dev-python/distributed-1.16[${PYTHON_USEDEP}]
		  >=dev-python/s3fs-0.0.8[${PYTHON_USEDEP}]
	)
	!<dev-python/dask-0.18.2-r6[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	test? (
	   ${RDEPEND}
	   dev-python/numexpr[${PYTHON_USEDEP}]
	   dev-python/pytest[${PYTHON_USEDEP}]
	   dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	   dev-python/scipy-python2[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.18.2-skip-broken-test.patch"
)

python_test() {
	pytest -v dask || die
}
