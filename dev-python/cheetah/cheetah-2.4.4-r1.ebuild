# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Cheetah"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="Python-powered template engine and code generator"
HOMEPAGE="http://www.cheetahtemplate.org/
	https://rtyler.github.com/cheetah/
	https://pypi.org/project/Cheetah/
	https://github.com/cheetahtemplate/cheetah"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
SLOT="python2"

RDEPEND="dev-python/markdown:python2[${PYTHON_USEDEP}]
	!dev-python/cheetah3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES README.markdown TODO )
# Race in the test suite
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Disable broken tests.
	sed \
		-e "/Unicode/d" \
		-e "s/if not sys.platform.startswith('java'):/if False:/" \
		-e "/results =/a\\    sys.exit(not results.wasSuccessful())" \
		-i cheetah/Tests/Test.py || die "sed failed"

	for script in bin/*; do
		mv "${script}" "${script}_py2"
	done
	sed -i \
		-e "s%'bin/cheetah-compile'%'bin/cheetah-compile_py2'%" \
		-e "s%'bin/cheetah'%'bin/cheetah_py2'%" \
		-e "s%'bin/cheetah-analyze'%'bin/cheetah-analyze_py2'%" \
		SetupConfig.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" cheetah/Tests/Test.py || die "Testing failed with ${EPYTHON}"
}
