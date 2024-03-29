# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A fast and thorough lazy object proxy"
HOMEPAGE="
	https://github.com/ionelmc/python-lazy-object-proxy
	https://pypi.org/project/lazy-object-proxy/
	https://python-lazy-object-proxy.readthedocs.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}]	)"
RDEPEND="
	!<dev-python/lazy-object-proxy-1.4.3-r200[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# No need to benchmark
	sed \
		-e '/benchmark/s:test_:_&:g' \
		-e '/pytest.mark.benchmark/d' \
		-i tests/test_lazy_object_proxy.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v -v --ignore=src || die "Fails for ${EPYTHON}"
}
