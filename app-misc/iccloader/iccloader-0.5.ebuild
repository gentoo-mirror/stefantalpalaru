# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AUTOTOOLS_AUTORECONF=yes

EGIT_REPO_URI="https://github.com/stefantalpalaru/iccloader.git"
inherit autotools vala

DESCRIPTION="systray widget used to load ICC color profiles with different color temperatures"
HOMEPAGE="https://github.com/stefantalpalaru/iccloader"
SRC_URI="https://github.com/stefantalpalaru/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	media-gfx/argyllcms
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.50
	virtual/pkgconfig"

src_prepare() {
	vala_src_prepare
	eapply_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
	)
	econf
}
