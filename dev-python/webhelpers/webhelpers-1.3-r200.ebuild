# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="WebHelpers"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Web Helpers"
HOMEPAGE="https://docs.pylonsproject.org/projects/webhelpers/en/latest/
	https://pypi.org/project/WebHelpers/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc test"

RDEPEND=">=dev-python/markupsafe-0.9.2:python2[${PYTHON_USEDEP}]
	dev-python/webob:python2[${PYTHON_USEDEP}]
	dev-python/routes:python2[${PYTHON_USEDEP}]
	!<dev-python/webhelpers-1.3-r200[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# https://bitbucket.org/bbangert/webhelpers/issue/67
	sed \
		-e '/import datetime/a import os' \
		-e 's:"/tmp/feed":os.environ.get("TMPDIR", "/tmp") + "/feed":' \
		-i tests/test_feedgenerator.py || die "sed failed"

	patch -p0 -i "${FILESDIR}"/mime9ad434b.patch

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake html -C docs
}

python_test() {
	nosetests || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	if use doc; then
		pushd docs/_build/html > /dev/null
		docinto html
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _static || die "Installation of documentation failed"
		popd > /dev/null
	fi
	distutils-r1_python_install_all
}
