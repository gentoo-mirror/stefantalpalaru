# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A featureful, correct URL for Python"
HOMEPAGE="https://github.com/python-hyper/hyperlink
	https://pypi.org/project/hyperlink/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="python2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/idna[${PYTHON_USEDEP}]
	!<dev-python/hyperlink-20.0.1-r2[${PYTHON_USEDEP}]
"
