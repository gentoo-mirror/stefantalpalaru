# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Persistent/Functional/Immutable data structures"
HOMEPAGE="https://github.com/tobgu/pyrsistent/
		https://pypi.org/project/pyrsistent/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	!<dev-python/pyrsistent-0.16.1-r200[${PYTHON_USEDEP}]
"
