# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="Add flag to ignore unicode literal prefixes in doctests"
HOMEPAGE="https://pypi.org/project/doctest-ignore-unicode/ https://github.com/gnublade/doctest-ignore-unicode"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="python2"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ~arm64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/nose:python2[${PYTHON_USEDEP}]
	!<dev-python/doctest-ignore-unicode-0.1.2-r1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
