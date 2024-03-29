# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Simplifies the usage of decorators for the average programmer"
HOMEPAGE="https://github.com/micheles/decorator
		https://pypi.org/project/decorator/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	!<dev-python/decorator-4.4.2-r3[${PYTHON_USEDEP}]
"

DOCS=( CHANGES.md )

distutils_enable_tests setup.py
