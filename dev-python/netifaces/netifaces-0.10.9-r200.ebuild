# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Portable network interface information"
HOMEPAGE="
	https://pypi.org/project/netifaces/
	https://alastairs-place.net/projects/netifaces/
	https://github.com/al45tair/netifaces
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="python2"
KEYWORDS="amd64 arm ~arm64 x86 ~amd64-linux ~x86-linux"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!<dev-python/netifaces-0.10.9-r200[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${PN}-0.10.4-remove-osx-fix.patch )
