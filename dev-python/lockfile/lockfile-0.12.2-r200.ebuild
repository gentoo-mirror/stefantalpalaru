# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Platform-independent file locking module"
HOMEPAGE="https://launchpad.net/pylockfile
		https://pypi.org/project/lockfile/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"

BDEPEND=">dev-python/pbr-1.8[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/lockfile-0.12.2-r200[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
distutils_enable_sphinx doc/source --no-autodoc
