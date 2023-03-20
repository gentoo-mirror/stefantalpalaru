# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="DOSBox Game Launcher"
HOMEPAGE="https://dbgl.org/"
MY_PN=${PN%-bin}
SRC_URI="https://dbgl.org/download/dbgl${PV/./}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
DEPEND=""
RDEPEND=">=virtual/jre-1.7
	games-emulation/dosbox"

S="${WORKDIR}"

src_install() {
	java-pkg_dojar "${MY_PN}.jar"
	java-pkg_jarinto "/usr/share/${PN}/lib/lib"
	java-pkg_dojar lib/*.jar
	cat > header.txt <<-EOF
export SWT_GTK3=0
EOF
	java-pkg_dolauncher "${MY_PN}" --jar "${MY_PN}.jar" --java_args "-Ddbgl.data.userhome=true" --pwd "/usr/share/${PN}/lib" -pre header.txt
	insinto "/usr/share/${PN}"
	doins -r templates xsl
}
