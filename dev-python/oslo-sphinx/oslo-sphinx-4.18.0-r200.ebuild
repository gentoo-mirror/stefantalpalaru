# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="${PN//-/}"

DESCRIPTION="OpenStack Sphinx Extensions and Theme"
HOMEPAGE="https://www.openstack.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="python2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sparc x86"
IUSE=""
RESTRICT="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-1.6[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	!<dev-python/oslo-sphinx-4.18.0-r200[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
