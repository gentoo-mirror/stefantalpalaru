# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

PLOCALES="ca cs de el es fa fr gl he hr hu id it ja ko nl pl pt_BR ru sv uk zh_CN zh_TW"

inherit distutils-r1 l10n xdg-utils

DESCRIPTION="A fork of comix, a GTK image viewer for comic book archives"
HOMEPAGE="https://sourceforge.net/p/mcomix/wiki/Home/"
MY_P="mcomix-git-486f02eef164df451a72598ce5989a1b37b49c60"
SRC_URI="https://sourceforge.net/code-snapshots/git/m/mc/mcomix/git.git/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/pygtk-2.14[${PYTHON_USEDEP}]
	virtual/jpeg
	dev-python/pillow[${PYTHON_USEDEP}]
	x11-libs/gdk-pixbuf
	!media-gfx/comix"

DOCS=( ChangeLog README )
PATCHES=(
	"${FILESDIR}/mcomix-1.2.1-pixbuf-r1.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	local checklocales
	for l in $(find "${S}"/mcomix/messages/* -maxdepth 0 -type d);
		do checklocales+="$(basename $l) "
	done

	[[ ${PLOCALES} == ${checklocales% } ]] \
		|| eqawarn "Update to PLOCALES=\"${checklocales% }\""

	my_rm_loc() {
		rm -rf "${S}/mcomix/messages/${1}/LC_MESSAGES" || die
		rmdir "${S}/mcomix/messages/${1}" || die
	}

	l10n_for_each_disabled_locale_do my_rm_loc

	distutils-r1_src_prepare
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	echo
	elog "Additional packages are required to open the most common comic archives:"
	elog
	elog "    cbr: app-arch/unrar"
	elog "    cbz: app-arch/unzip"
	elog
	elog "You can also add support for 7z or LHA archives by installing"
	elog "app-arch/p7zip or app-arch/lha. Install app-text/mupdf for"
	elog "pdf support."
	echo
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}