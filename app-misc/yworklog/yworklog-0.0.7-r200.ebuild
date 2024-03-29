# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE=sqlite

inherit distutils-r1

DESCRIPTION="Stack based utility with CLI interface helping to monitor time spent on tasks"
HOMEPAGE="https://github.com/yaccz/worklog"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/sqlalchemy
	dev-python/cement[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/alembic[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	!<app-misc/yworklog-0.0.7-r200[${PYTHON_USEDEP}]
"
