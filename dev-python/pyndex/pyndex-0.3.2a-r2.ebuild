# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Pyndex"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple and fast Python full-text indexer using Metakit as its back-end"
HOMEPAGE="https://sourceforge.net/projects/pyndex/"
SRC_URI="mirror://sourceforge/pyndex/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="test"

RDEPEND=">=dev-db/metakit-2.4.9.2[python]"
DEPEND=""

S="${WORKDIR}/${MY_P}"
