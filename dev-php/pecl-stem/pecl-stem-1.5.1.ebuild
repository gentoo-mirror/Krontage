# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PHP_EXT_NAME="stem"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r2

DESCRIPTION="This stem extension for PHP provides stemming capability for a
variety of languages using Dr. M.F. Porter's Snowball API, which can be found
at: http://snowball.tartarus.org"

LICENSE="PHP 3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/php[curl,hash,ssl]"
RDEPEND="${DEPEND}"
IUSE=""

