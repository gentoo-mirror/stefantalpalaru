# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python Performance Benchmark Suite"
HOMEPAGE="https://github.com/python/performance"
SRC_URI="https://github.com/python/performance/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/virtualenv[${PYTHON_USEDEP}]' python2_7 )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/performance-0.6.1-empty-pip-command.patch
)

src_prepare() {
	default
	sed -i -e '/install_requires/d' setup.py
}
