# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Test utilities for code working with files and commands"
HOMEPAGE="https://github.com/jupyter/testpath
		https://testpath.readthedocs.io/en/latest/"
SRC_URI="https://github.com/jupyter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
RESTRICT="test"

RDEPEND="
	!<dev-python/testpath-0.4.4-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.2-setup.py.patch"
)

distutils_enable_sphinx doc

python_prepare_all() {
	# Prevent un-needed download during build
	sed -e "/^    'sphinx.ext.intersphinx',/d" -i doc/conf.py || die

	distutils-r1_python_prepare_all
}
