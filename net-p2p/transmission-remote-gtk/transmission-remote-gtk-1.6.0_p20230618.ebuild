# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

MY_COMMIT="3cb7977c7287f22185d94114d5ce0441ca29e327"

DESCRIPTION="GTK+ client for management of the Transmission BitTorrent client, over HTTP RPC"
HOMEPAGE="https://github.com/transmission-remote-gtk/transmission-remote-gtk"
SRC_URI="https://github.com/transmission-remote-gtk/transmission-remote-gtk/archive/${MY_COMMIT}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="appindicator debug geoip"

# RESTRICT="test"

RDEPEND="
	>=dev-libs/glib-2.56:2
	>=dev-libs/json-glib-1.2.8
	net-libs/libsoup:3.0
	>=x11-libs/gtk+-3.22:3
	appindicator? ( dev-libs/libayatana-appindicator )
	geoip? ( dev-libs/geoip )
"
DEPEND="${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

src_configure() {
	local emesonargs=(
		$(meson_feature geoip)
		$(meson_feature appindicator libappindicator)
	)
	meson_src_configure
}
