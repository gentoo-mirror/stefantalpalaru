# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Smart replacement for plain tuple used in __version__"
HOMEPAGE="https://pypi.org/project/versiontools/ https://launchpad.net/versiontools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="amd64 x86"
IUSE=""

LICENSE="GPL-2"
SLOT="python2"

RDEPEND="
	!<dev-python/versiontools-1.9.1-r200[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Expexted failure
	sed -e s':test_cant_import:_&:' -i versiontools/tests.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
