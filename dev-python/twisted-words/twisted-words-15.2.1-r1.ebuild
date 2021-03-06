# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="Twisted Words contains Instant Messaging implementations"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND="
	=dev-python/twisted-core-${TWISTED_RELEASE}*[${PYTHON_USEDEP}]
	=dev-python/twisted-web-${TWISTED_RELEASE}*[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!dev-python/twisted
"
