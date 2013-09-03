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

	epatch "${FILESDIR}"/makefile.patch
}

src_configure() {
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
}

