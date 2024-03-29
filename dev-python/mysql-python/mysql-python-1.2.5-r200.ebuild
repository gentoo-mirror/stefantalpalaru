# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MY_PN="MySQL-python"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python interface to MySQL"
HOMEPAGE="https://sourceforge.net/projects/mysql-python/
		https://pypi.python.org/pypi/MySQL-python"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="python2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"
RESTRICT="test"

RDEPEND="virtual/mysql
	!<dev-python/mysql-python-1.2.5-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

DOCS=( HISTORY README.md doc/{FAQ,MySQLdb}.rst )

PATCHES=(
	"${FILESDIR}"/mariadb.patch
	"${FILESDIR}"/include.patch
)

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_compile_all() {
	use doc && sphinx-build -b html doc doc/_build/
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/. )
	distutils-r1_python_install_all
}
