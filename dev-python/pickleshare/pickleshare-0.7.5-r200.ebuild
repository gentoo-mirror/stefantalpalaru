# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A small 'shelve' like datastore with concurrency support"
HOMEPAGE="https://github.com/pickleshare/pickleshare"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 x86"
IUSE="test"

RDEPEND="
	dev-python/pathlib2:python2[${PYTHON_USEDEP}]
	>=dev-python/path-py-6.2:python2[${PYTHON_USEDEP}]
	!<dev-python/pickleshare-0.7.5-r200[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

RESTRICT="test"

python_test() {
	py.test || die
}
