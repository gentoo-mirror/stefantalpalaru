# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Easily displaying tabular data in a visually appealing ASCII table format"
HOMEPAGE="https://code.google.com/p/prettytable/"
SRC_URI="mirror://pypi/P/PrettyTable/${P}.tar.bz2"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm64 hppa ~ia64 ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-python/prettytable-0.7.2-r200[${PYTHON_USEDEP}]
"

python_test() {
	"${PYTHON}" prettytable_test.py || die "tests failed under ${EPYTHON}"
}
