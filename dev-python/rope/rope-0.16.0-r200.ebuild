# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python refactoring library"
HOMEPAGE="https://github.com/python-rope/rope"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc"

# Dependency for docbuild documentation which is not noted in
# setup.py, using standard docutils builds docs successfully.
DEPEND="doc? ( dev-python/docutils[${PYTHON_USEDEP}] )"
RDEPEND="
	!<dev-python/rope-0.16.0-r200[${PYTHON_USEDEP}]
"

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib:." ${EPYTHON} ropetest/__init__.py
}

python_compile_all() {
	if use doc; then
		pushd docs > /dev/null || die
		mkdir build || die
		local i
		for i in ./*.rst; do
			rst2html.py $i > ./build/${i/rst/html} || die
		done
	   	popd > /dev/null || die
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/. )
	distutils-r1_python_install_all
}
