# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Sphinx themes for Pallets and related projects"
HOMEPAGE="https://github.com/pallets/pallets-sphinx-themes"
SRC_URI="https://github.com/pallets/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="python2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86"

RDEPEND="dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	!<dev-python/pallets-sphinx-themes-1.2.3[${PYTHON_USEDEP}]
"
