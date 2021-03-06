# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast Base64 encoding/decoding routines"
HOMEPAGE="http://libb64.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="CC-PD"
# static library, so always rebuild
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="app-arch/unzip"

src_compile() {
	# override -O3, -Werror non-sense
	emake -C src CFLAGS="${CFLAGS} -I../include"
}

src_install() {
	dolib src/libb64.a
	insinto /usr/include
	doins -r include/b64
	dodoc AUTHORS BENCHMARKS CHANGELOG README
}
