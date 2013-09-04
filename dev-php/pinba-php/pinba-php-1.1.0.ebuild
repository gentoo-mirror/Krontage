# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PHP_EXT_NAME="pinba"
inherit git-2 eutils

DESCRIPTION="Pinba PHP Extension"
HOMEPAGE="http://pinba.org/"
EGIT_REPO_URI="https://github.com/tony2001/pinba_extension.git"

LICENSE="GNU GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/php
dev-libs/protobuf"
RDEPEND="${DEPEND}"

PHP_V=$(realpath `which php`)
PHP_V=${PHP_V#/usr/lib[2346]*/}
PHP_V=${PHP_V%/bin/php}

src_prepare() {
	phpize
	aclocal
	libtoolize --force
	autoheader
	autoconf
}

src_configure() {
	epatch "${FILESDIR}"/configure.patch
	econf --enable-pinba=/usr/include/google --prefix="${D}"
}

src_test() {
	emake test
}

src_install() {
	emake DESTDIR="${D}" install

	local d
	for d in CREDITS NEWS README; do
		[[ -s "${d}" ]]	&& dodoc "${d}"
	done

	PHPINI=''
	for a in apache2 cli cgi fpm;do
		if [[ -f "/etc/php/${a}-${PHP_V}/php.ini" ]];then
			PHPINI="${PHPINI} etc/php/${a}-${PHP_V}/ext/${PHP_EXT_NAME}.ini"
			[[ -d "${D}/etc/php/${a}-${PHP_V}/ext" ]] || mkdir -p "${D}/etc/php/${a}-${PHP_V}/ext"
			echo "extension=${PHP_EXT_NAME}.so" >> "${D}/etc/php/${a}-${PHP_V}/ext/${PHP_EXT_NAME}.ini"
			echo "pinba.enabled=1" >> "${D}/etc/php/${a}-${PHP_V}/ext/${PHP_EXT_NAME}.ini"
			echo "pinba.server=127.0.0.1:30002" >> "${D}/etc/php/${a}-${PHP_V}/ext/${PHP_EXT_NAME}.ini"
		fi
	done

	for ini in ${PHPINI};do
		INITARGET=${ini/ext/ext-active}
		dosym /${ini} /${INITARGET}
	done
}

