# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 eutils flag-o-matic

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

pkg_setup() {
	for dir in `find /usr/include/mysql -type d`;do
		append-flags "-I${dir}"
	done
	for h in my_bitmap.h;do
		header=`find /usr/include -iname ${h}`
		header=${header#/usr/include/}
		einfo "header: ${header}"
		sed -i "s:mysql/private/${h}:${header}:" ${FILESDIR}/ha_pinba.cc.patch
	done
}

src_prepare() {
	if [[ -x ${EGIT_SOURCEDIR}/buildconf.sh ]] ;then
		${EGIT_SOURCEDIR}/buildconf.sh
	fi
	epatch "${FILESDIR}"/configure.patch
	epatch "${FILESDIR}"/ha_pinba.cc.patch
}

src_configure() {
	if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
		econf --with-mysql=/usr/include/mysql --libdir=${D}/usr/lib/mysql/plugin
	fi
}

src_install() {
	emake install prefix=${D}
	for doc in COPYING NEWS README TODO default_tables.sql;do
		dodoc ${doc}
	done
}

