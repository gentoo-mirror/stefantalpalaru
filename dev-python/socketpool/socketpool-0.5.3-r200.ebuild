# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A simple Python socket pool"
HOMEPAGE="https://github.com/benoitc/socketpool/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 s390 ~sparc x86"
IUSE="examples test"
LICENSE="|| ( MIT public-domain )"
SLOT="python2"

RDEPEND="
	dev-python/gevent[${PYTHON_USEDEP}]
	!<dev-python/socketpool-0.5.3-r200[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.5.2-locale.patch )

python_test() {
	cp -r examples tests "${BUILD_DIR}" || die

	pushd "${BUILD_DIR}" >/dev/null || die
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
	popd >/dev/null || die
}

python_install_all() {
	distutils-r1_python_install_all

	use examples && dodoc -r examples

	# package installs unneeded LICENSE files here
	rm -r "${ED}"/usr/socketpool || die
}
