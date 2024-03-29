# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Backports of the linecache module"
HOMEPAGE="https://github.com/testing-cabal/linecache2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)"
RDEPEND="
	!<dev-python/linecache2-1.0.0-r200[${PYTHON_USEDEP}]
"

python_test() {
	"${PYTHON}" -m unittest2 discover || die "tests failed under ${EPYTHON}"
}
