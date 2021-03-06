# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Task scheduling and blocked algorithms for parallel processing"
HOMEPAGE="http://dask.pydata.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="distributed test"

RDEPEND="
	>=dev-python/cloudpickle-0.2.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/numpy-python2-1.11[${PYTHON_USEDEP}]' -2)
	$(python_gen_cond_dep '>=dev-python/numpy-1.11[${PYTHON_USEDEP}]' -3)
	>=dev-python/pandas-0.23.4[${PYTHON_USEDEP}]
	>=dev-python/partd-0.3.8[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.7.3[${PYTHON_USEDEP}]
	distributed? (
		  >=dev-python/distributed-1.16[${PYTHON_USEDEP}]
		  >=dev-python/s3fs-0.0.8[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	test? (
	   ${RDEPEND}
	   dev-python/numexpr[${PYTHON_USEDEP}]
	   dev-python/pytest[${PYTHON_USEDEP}]
	   dev-python/pyyaml[${PYTHON_USEDEP}]
	   $(python_gen_cond_dep 'dev-python/scipy-python2[${PYTHON_USEDEP}]' -2)
	   $(python_gen_cond_dep 'dev-python/scipy[${PYTHON_USEDEP}]' -3)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.18.2-skip-broken-test.patch"
)

python_test() {
	pytest -v dask || die
}
