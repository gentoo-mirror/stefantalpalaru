# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="${PN//retty-}"
DESCRIPTION="PyYAML-based module to produce pretty and readable YAML-serialized data"
HOMEPAGE="https://github.com/mk-fg/pretty-yaml"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="WTFPL-2"
SLOT="python2"
KEYWORDS="amd64 arm x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyyaml:python2[${PYTHON_USEDEP}]
	!<dev-python/pretty-yaml-19.12.0-r3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/unidecode[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	"${PYTHON}" pyaml/tests/dump.py || die "tests failed under ${EPYTHON}"
}
