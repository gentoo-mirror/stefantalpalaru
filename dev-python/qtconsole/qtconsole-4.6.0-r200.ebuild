# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 virtualx

DESCRIPTION="Qt-based console for Jupyter with support for rich media output"
HOMEPAGE="http://jupyter.org
		https://github.com/jupyter/qtconsole"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc test"

RDEPEND="
	dev-python/ipykernel:python2[${PYTHON_USEDEP}]
	dev-python/ipython_genutils:python2[${PYTHON_USEDEP}]
	dev-python/jupyter_core:python2[${PYTHON_USEDEP}]
	>=dev-python/jupyter_client-4.1.1:python2[${PYTHON_USEDEP}]
	dev-python/traitlets:python2[${PYTHON_USEDEP}]
	!<dev-python/qtconsole-4.6.0-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? (
		>=dev-python/ipython-4.0.0-r2[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.3.1-r1[${PYTHON_USEDEP}]
	)
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' 'python2*')
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP},svg,testlib]
	)
	dev-python/PyQt5[${PYTHON_USEDEP},svg]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-13[${PYTHON_USEDEP}]
	"
PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	sed -i \
		-e 's/jupyter-qtconsole = qtconsole.qtconsoleapp:main/jupyter-qtconsole_py2 = qtconsole.qtconsoleapp:main/' \
		setup.py || die
	sed -i \
		-e 's/jupyter-qtconsole/jupyter-qtconsole_py2/g' \
		qtconsole/qtconsoleapp.py || die
	rm -rf scripts

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	# jupyter qtconsole --generate-config ... jupyter-qtconsole: cannot connect to X server
	# ERROR
	sed \
		-e 's:test_generate_config:_&:g' \
		-i qtconsole/tests/test_app.py || die
	virtx nosetests --verbosity=2 qtconsole
}
