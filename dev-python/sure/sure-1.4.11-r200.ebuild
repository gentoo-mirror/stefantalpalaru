# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="idiomatic assertion toolkit with human-friendly failure messages"
HOMEPAGE="https://github.com/gabrielfalcao/sure"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="python2"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/mock[${PYTHON_USEDEP}]
	>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/sure-1.4.11-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( ${RDEPEND} )
"

python_test() {
	nosetests -v tests || die "Tests failed under ${EPYTHON}"
}
