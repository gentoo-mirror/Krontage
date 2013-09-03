# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PHP_EXT_NAME="pinba"
inherit git-2 php-ext-source-r2 eutils

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

my_conf='--enable-pinba=/usr/include/google'

php-ext-source-r2_src_unpack() {
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		cp -r "${orig_s}" "${WORKDIR}/${slot}" || die
		"Failed to copy source ${orig_s} to PHP target
		directory"
	done
##	phpize
##	aclocal
##	libtoolize --force
##	autoheader
##	autoconf
}

php-ext-source-r2_src_prepare() {
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		php-ext-source-r2_phpize

		eaclocal
		elibtoolize --force
		eautoheader
		eautoconf
	done
}
