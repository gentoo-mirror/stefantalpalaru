# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="a tool to translate ANSI C code to Nim"
HOMEPAGE="https://github.com/nim-lang/c2nim"
EGIT_REPO_URI="https://github.com/nim-lang/c2nim"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND="
	>=dev-lang/nim-0.18.0
"
RDEPEND="${DEPEND}"

src_compile() {
	nim c -d:release -p:"\$lib/packages/compiler" --verbosity:2 ${PN}.nim || die "compile failed"
}

src_test() {
	nim c -d:release -p:"\$lib/packages/compiler" --verbosity:2 testsuite/tester.nim || die "tester.nim compile failed"
	PATH=".:${PATH}" ./testsuite/tester
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe ${PN}

	if use doc; then
		dodoc doc/c2nim.rst
	fi
}
