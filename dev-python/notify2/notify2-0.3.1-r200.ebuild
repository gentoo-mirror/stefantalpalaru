# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Python interface to DBus notifications."
HOMEPAGE="https://bitbucket.org/takluyver/pynotify2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="examples"

RDEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]
	!<dev-python/notify2-0.3.1-r200[${PYTHON_USEDEP}]
"
BDEPEND="test? ( sys-apps/dbus[X] )"

python_test() {
	virtx ${EPYTHON} test_notify2.py
}

python_install_all() {
	if use examples; then
		rm examples/notify2.py || die
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
