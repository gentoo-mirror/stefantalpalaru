# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Code specific for Read the Docs and Sphinx"
HOMEPAGE="https://github.com/readthedocs/readthedocs-sphinx-ext"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-python/jinja-2.9[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
PDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]"
