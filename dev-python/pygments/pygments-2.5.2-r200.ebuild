# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 bash-completion-r1

MY_PN="Pygments"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pygments is a syntax highlighting package written in Python"
HOMEPAGE="https://pygments.org/ https://pypi.org/project/Pygments/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		virtual/ttf-fonts
	)"
RDEPEND="
	!<dev-python/pygments-2.5.2-r200[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc

python_prepare_all() {
	sed -i \
		-e "s#pygmentize = pygments.cmdline:main#pygmentize_py2 = pygments.cmdline:main#" \
		setup.py || die
	sed -i \
		-e 's/pygmentize/pygmentize_py2/g' \
		external/pygments.bashcomp || die
	distutils-r1_python_prepare_all
}

python_test() {
	cp -r -l tests "${BUILD_DIR}"/ || die
	pytest -vv "${BUILD_DIR}"/tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	newbashcomp external/pygments.bashcomp pygmentize_py2
}
