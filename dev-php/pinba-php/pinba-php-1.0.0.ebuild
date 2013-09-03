# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PHP_EXT_NAME="pinba"
inherit git-2 php-ext-base-r1

DESCRIPTION="Pinba PHP Extension"
HOMEPAGE="http://pinba.org/"
EGIT_REPO_URI="https://github.com/tony2001/pinba_engine.git"

LICENSE="GNU GPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/php
dev-libs/protobuf"
RDEPEND="${DEPEND}"

pkg_setup() {
	# ugly mysql headers hack
	einfo "creating symlinks of mysql header files under /usr/include/mysql"
	for header in my_bitmap.h my_compare.h myisampack.h ft_global.h;do
	if [[ -e /usr/include/mysql/private/${header} ]] ;then
		ln -sv /usr/include/mysql/private/${header} /usr/include/mysql/${header}
	fi
	done
}

src_prepare() {
	./buildconf.sh
	phpize
}

src_prepare() {
	if [[ -x ${EGIT_SOURCEDIR}/buildconf.sh ]] ;then
		${EGIT_SOURCEDIR}/buildconf.sh
	fi
	epatch "${FILESDIR}"/configure.patch
	epatch "${FILESDIR}"/ha_pinba.cc.patch
}

src_configure() {
	econf --with-mysql=/usr/include/mysql --libdir=/usr/lib/mysql/plugin
}

