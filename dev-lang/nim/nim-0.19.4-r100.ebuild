# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 multiprocessing

DESCRIPTION="compiled, garbage-collected systems programming language"
HOMEPAGE="https://nim-lang.org/"
SRC_URI="https://nim-lang.org/download/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="bash-completion boehm-gc doc +readline test"

DEPEND="
	readline? ( sys-libs/readline:= )
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
	boehm-gc? ( dev-libs/boehm-gc )
"
BDEPEND="
	test? ( net-libs/nodejs )
"

nim_use_enable() {
	[[ -z $2 ]] && die "usage: nim_use_enable <USE flag> <compiler flag>"
	use $1 && echo "-d:$2"
}

src_compile() {
	sed -i \
		-e "s/^COMP_FLAGS =.*$/COMP_FLAGS = ${CFLAGS} -fno-strict-aliasing/" \
		-e "s/^LINK_FLAGS =.*$/LINK_FLAGS = ${LDFLAGS}/" \
		makefile
	emake CC=gcc LD=gcc
	sed -i \
		-e "s/^gcc\.options\.speed.*$/gcc.options.speed = \"${CFLAGS} -fno-strict-aliasing\"/" \
		-e "s/^gcc\.cpp\.options\.speed.*$/gcc.cpp.options.speed = \"${CFLAGS} -fno-strict-aliasing\"/" \
		-e "s/\"-ldl\"/\"-ldl ${LDFLAGS}\"/g" \
		config/nim.cfg
	cat <<EOF >> config/nim.cfg

# Gentoo additions
path="\$lib/packages"
EOF
	./bin/nim c -d:release --verbosity:2 --parallelBuild:$(makeopts_jobs) koch || die "csources nim failed"
	./koch boot -d:release --verbosity:2 --parallelBuild:$(makeopts_jobs) $(nim_use_enable readline useGnuReadline) || die "koch boot failed"
	#echo -e "\npath:\"\$projectPath/../..\"" >> compiler/nimfix/nimfix.nim.cfg
	#PATH="./bin:${PATH}" nim c -d:release compiler/nimfix/nimfix.nim || die "nimfix.nim compilation failed"
	PATH="./bin:${PATH}" nim c --noNimblePath -p:compiler -d:release --verbosity:2 --parallelBuild:$(makeopts_jobs) -o:bin/nimsuggest nimsuggest/nimsuggest.nim || die "nimsuggest compilation failed"
	PATH="./bin:${PATH}" nim c -d:release --verbosity:2 --parallelBuild:$(makeopts_jobs) -o:bin/nimgrep tools/nimgrep.nim || die "nimgrep compilation failed"
	PATH="./bin:${PATH}" nim c -d:release --verbosity:2 --parallelBuild:$(makeopts_jobs) -o:bin/nimpretty nimpretty/nimpretty.nim || die "nimpretty compilation failed"

	if use doc; then
		PATH="./bin:${PATH}" ./koch docs || die "koch docs failed"
	fi
}

src_test() {
	PATH="./bin:${PATH}" ./koch tests
}

src_install() {
	./koch install "${D}/usr/share" || die "koch install failed"
	# config files
	mkdir -p "${D}/etc/nim"
	mv "${D}"/usr/share/nim/config/* "${D}/etc/nim/"
	rm -r "${D}/usr/share/nim/config"
	# "compiler" package
	mkdir -p "${D}"/usr/share/nim/lib/packages/compiler
	mv "${D}"/usr/share/nim/{compiler,compiler.nimble} "${D}"/usr/share/nim/lib/packages/compiler/
	# binaries
	dodir /usr/bin
	dosym ../share/nim/bin/nim /usr/bin/nim
	exeinto /usr/bin
	doexe tools/niminst/niminst
	doexe bin/nimsuggest
	doexe bin/nimgrep
	doexe bin/nimpretty
	# modules ignored by `koch install`
	rm -rf doc/nimcache
	insinto /usr/share/nim/lib
	doins -r doc
	insinto /usr/share/nim/lib/wrappers
	doins -r lib/wrappers/linenoise

	if use doc; then
		HTML_DOCS=doc/html/*.html
		einstalldocs
	fi

	if use bash-completion; then
		newbashcomp tools/nim.bash-completion ${PN}
	fi
}
