# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Thrift is an interface definition language that is used to define
and create services for numerous languages."
HOMEPAGE="https://thrift.apache.org"
SRC_URI="https://dist.apache.org/repos/dist/release/thrift/${PV}/thrift-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+pic gnu-ld +cpp +boost +libevent +zlib qt4 +c_glib csharp java erlang python
perl php php_extension ruby haskell go d"

DEPEND="java? (
		|| (
			virtual/java
			dev-java/ant
			)
		)
		boost? ( dev-libs/boost )
		libevent? ( dev-libs/libevent )
		zlib? ( sys-libs/zlib )
		csharp? ( dev-lang/mono )
		erlang? ( dev-lang/erlang )
		python? ( >=dev-lang/python-2.6 <=dev-lang/python-2.7 )
		perl? ( dev-perl/Bit-Vector dev-perl/Class-Accessor )
		php? ( dev-lang/php )
		ruby? ( dev-lang/ruby )
		go? ( dev-lang/go )"
RDEPEND="${DEPEND}"

src_unpack() {
	if [ "${A}" != "" ]; then
		unpack ${A}
		mv -b ${WORKDIR}/thrift-${PV} ${S}
	fi
}

src_configure() {
	if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
		econf \
			$(use_with pic) \
			$(use_with gnu-ld) \
			$(use_with cpp) \
			$(use_with boost) \
			$(use_with libevent) \
			$(use_with zlib) \
			$(use_with qt4) \
			$(use_with c_glib) \
			$(use_with csharp) \
			$(use_with java) \
			$(use_with erlang) \
			$(use_with python) \
			$(use_with perl) \
			$(use_with php) \
			$(use_with php_extension) \
			$(use_with ruby) \
			$(use_with haskell) \
			$(use_with go) \
			$(use_with d)
	fi
}

src_compile() {
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		export LANG=C LC_ALL=C
		make || die "make failed"
	fi
}
