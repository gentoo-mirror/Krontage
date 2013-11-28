# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 eutils flag-o-matic versionator

DESCRIPTION="Pinba (PHP Is Not A Bottleneck Anymore) is a statistics server
using MySQL as an interface."
HOMEPAGE="http://pinba.org/"
EGIT_REPO_URI="https://github.com/tony2001/pinba_engine.git"

LICENSE="GNU GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( >=dev-db/mariadb-5.1 >=dev-db/mysql-5.1 )
<=dev-libs/protobuf-2.4.1
dev-libs/judy
>=dev-libs/libevent-1.4.1
"
RDEPEND="${DEPEND}"

MY_PLUG_DIR='/usr/lib/mysql/plugin'

pkg_setup() {
	for dir in `find /usr/include/mysql -type d`;do
		append-flags "-I${dir}"
	done
}

src_prepare() {
	if [[ -f ./build.mk ]];then
		emake -f build.mk
	fi
	epatch "${FILESDIR}"/configure.patch
	epatch "${FILESDIR}"/ha_pinba.cc.patch
}

src_configure() {
	if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
		econf --with-mysql=/usr/include/mysql --libdir=${D}${MY_PLUG_DIR}
	fi
}

src_install() {
	for doc in COPYING NEWS README TODO default_tables.sql;do
		dodoc ${doc}
	done

	insinto ${MY_PLUG_DIR};	doins ${S}/src/.libs/libpinba_engine.a
	insinto ${MY_PLUG_DIR};	doins ${S}/src/.libs/libpinba_engine.la
	insinto ${MY_PLUG_DIR};	doins ${S}/src/.libs/libpinba_engine.so.0.0.0

	for sym in libpinba_engine.so libpinba_engine.so.0;do
		dosym ${MY_PLUG_DIR}/libpinba_engine.so.0.0.0 ${MY_PLUG_DIR}/${sym}
	done
}

