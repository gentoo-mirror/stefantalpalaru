# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps toolchain-funcs

DESCRIPTION="Zen monitor is monitoring software for AMD Zen-based CPUs"
HOMEPAGE="https://git.exozy.me/a/zenmonitor3"
KEYWORDS="~amd64"
SRC_URI="https://git.exozy.me/a/zenmonitor3/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="cli +filecaps policykit"

S="${WORKDIR}/${PN}"

DEPEND="
	cli? ( sys-libs/ncurses )
	filecaps? ( sys-libs/libcap )
	x11-libs/gtk+:3
"
RDEPEND="
	${DEPEND}
	policykit? ( sys-auth/polkit )
	sys-kernel/zenpower3
"

PATCHES=( "${FILESDIR}/${PN}-makefile.patch" )

src_compile() {
	tc-export CC
	emake build
	use cli && emake build-cli
}

src_install() {
	dodoc README.md

	DESTDIR="${D}" emake install
	use cli && DESTDIR="${D}" emake install-cli
	if use policykit; then
		mkdir -p "${ED}/usr/share/polkit-1/actions" || die
		DESTDIR="${D}" emake install-polkit
	fi
}

pkg_postinst() {
	fcaps cap_sys_rawio,cap_dac_read_search usr/bin/zenmonitor
	use cli && fcaps cap_sys_rawio,cap_dac_read_search usr/bin/zenmonitor-cli
}
