# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Sphinx theme used by Guzzle"
HOMEPAGE="https://github.com/guzzle/guzzle_sphinx_theme"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/sphinx-1.2[${PYTHON_USEDEP}]
	!<dev-python/guzzle_sphinx_theme-0.7.11-r200[${PYTHON_USEDEP}]
"
