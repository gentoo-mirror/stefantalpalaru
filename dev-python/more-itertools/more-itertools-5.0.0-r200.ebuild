# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="More routines for operating on iterables, beyond itertools"
HOMEPAGE="https://pypi.org/project/more-itertools/
		https://github.com/more-itertools/more-itertools"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
RESTRICT="test"

RDEPEND="<dev-python/six-2.0[${PYTHON_USEDEP}]
	!<dev-python/more-itertools-5.0.0-r200[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme
