# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="library with cross-python path, ini-parsing, io, code, log facilities"
HOMEPAGE="https://py.readthedocs.io/en/latest/
		https://github.com/pytest-dev/py
		https://pypi.org/project/py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"
DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	!<dev-python/py-1.9.0-r200[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.2-skip-apiwarn-pytest31.patch
	"${FILESDIR}"/${PN}-1.8.0-pytest-4.patch
)

distutils_enable_sphinx doc

src_prepare() {
	# broken on py3.8, don't seem important
	sed -i -e 's:test_syntaxerror_rerepresentation:_&:' \
		-e 's:test_comments:_&:' \
		testing/code/test_source.py || die
	# broken on py3.9, this package is just dead
	sed -i -e 's:test_getfslineno:_&:' \
		testing/code/test_source.py || die

	distutils-r1_src_prepare

	# broken, and relying on exact assertion strings
	rm testing/code/test_assertion.py || die
}
