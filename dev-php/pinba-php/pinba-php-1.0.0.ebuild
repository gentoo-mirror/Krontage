# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PHP_EXT_NAME="pinba"
inherit git-2 depend.php

DESCRIPTION="Pinba PHP Extension"
HOMEPAGE="http://pinba.org/"
EGIT_REPO_URI="https://github.com/tony2001/pinba_extension.git"

LICENSE="GNU GPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/php
dev-libs/protobuf"
RDEPEND="${DEPEND}"

src_prepare() {
	phpize
	aclocal
	libtoolize --force
	autoheader
	autoconf
}

src_configure() {
	econf --enable-pinba=/usr/include/google --prefix="${D}"
	epatch "${FILESDIR}"/makefile.patch
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

	has_php
	if [[ -z "${PHPSAPILIST}" ]] ; then
		PHPSAPILIST="apache2 cli cgi fpm"
	fi
	PHPINIFILELIST=""
	for x in ${PHPSAPILIST} ; do
		if [[ -f "/etc/php/${x}-php${PHP_VERSION}/php.ini" ]] ; then
			PHPINIFILELIST="${PHPINIFILELIST} etc/php/${x}-php${PHP_VERSION}/ext/${PHP_EXT_NAME}.ini"
		fi
	done

	for f in ${PHPINIFILELIST};do
		if [[ ! -d $(dirname ${f}) ]];then
			mkdir -p $(dirname ${f})
		fi
		echo "extension=${PHP_EXT_NAME}.so" >> ${f}
		insinto /$(dirname ${f})
		doins "${f}"
	done

	for inifile in ${PHPINIFILELIST} ; do
		inidir="${inifile/${PHP_EXT_NAME}.ini/}"
		inidir="${inidir/ext/ext-active}"
		dodir "/${inidir}"
		dosym "/${inifile}" "/${inifile/ext/ext-active}"
	done

}

