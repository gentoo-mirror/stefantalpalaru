# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python client library for accessing the disqus.com API"
HOMEPAGE="https://github.com/disqus/disqus-python"
SRC_URI="mirror://pypi/d/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-python/nose[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)"
RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" "${S}/disqusapi/tests.py" || die
}
