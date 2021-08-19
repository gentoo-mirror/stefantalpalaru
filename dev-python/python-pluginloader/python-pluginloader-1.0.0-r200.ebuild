# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Library to manage python plugins/extensions"
HOMEPAGE="https://github.com/magmax/python-pluginloader"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/python-pluginloader-1.0.0-r200[${PYTHON_USEDEP}]
"
