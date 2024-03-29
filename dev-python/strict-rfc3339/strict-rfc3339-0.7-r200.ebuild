# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="${PN}-version"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Strict, simple, lightweight RFC3339 functions"
HOMEPAGE="https://pypi.org/project/strict-rfc3339/
		https://github.com/danielrichman/strict-rfc3339"
SRC_URI="https://github.com/danielrichman/${PN}/archive/version-${PV}.tar.gz -> ${MY_P}.tar.gz"

SLOT="python2"
LICENSE="GPL-3+"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="test"

RDEPEND="
	!<dev-python/strict-rfc3339-0.7-r200[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"
