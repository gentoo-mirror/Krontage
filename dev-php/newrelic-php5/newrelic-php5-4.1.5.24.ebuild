# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PHP_EXT_NAME='newrelic'
inherit rpm

DESCRIPTION="NewRelic PHP5 Agent"
HOMEPAGE="http://newrelic.com"
SRC_URI="https://yum.newrelic.com/pub/newrelic/el5/x86_64/${P}-1.x86_64.rpm
	x86? 	( https://yum.newrelic.com/pub/newrelic/el5/i386/${P}-1.i386.rpm )"

LICENSE="newrelic Apache-2.0 MIT ISC openssl GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/php"
RDEPEND="${DEPEND}"

S="${WORKDIR}/"

pkg_setup() {
	PHP_VERSION=$(php -v |grep 'PHP [0-9]'|sed -e 's:PHP \([^-]\+\)-\?.*:\1:')
	PHP_EXTENSION=$(php -i 2>/dev/null|grep 'PHP Extension => '|sed -e 's:PHP Extension => \(.\+\):\1:')
	PHP_ZEND_EXTENSION=$(php -i 2>/dev/null|grep 'Zend Extension => '|sed -e 's:Zend Extension => \(.\+\):\1:')
	PHP_EXTENSION_DIR=$(php -i 2>/dev/null|grep ^extension_dir|sed -e 's:extension_dir => \([/a-z0-9.-]\+\).*:\1:')
}

src_install() {
	[ -z "${PHP_VERSION}" ] && die "no php found"
	PHP_V=$(echo ${PHP_VERSION}|sed -e 's:\([0-9]\+\.[0-9]\+\).*:\1:')

	if [[ ${PHP_EXTENSION_DIR/no-zts/} == ${PHP_EXTENSTION_DIR} ]];then
		PHP_EXTENSION_SOURCE="${PHP_EXT_NAME}-${PHP_EXTENSION}-zts.so"
	else
		PHP_EXTENSION_SOURCE="${PHP_EXT_NAME}-${PHP_EXTENSION}.so"
	fi

	mkdir -p ${T}/${PHP_EXTENSION_DIR}
	mkdir -p ${D}/${PHP_EXTENSION_DIR}
	dolib "${S}/usr/lib/newrelic-php5/scripts/newrelic-iutil.x64"

	chmod 644 "${S}/usr/lib/newrelic-php5/agent/x64/${PHP_EXTENSION_SOURCE}"
	cp -a "${S}/usr/lib/newrelic-php5/agent/x64/${PHP_EXTENSION_SOURCE}" "${D}/${PHP_EXTENSION_DIR}/${PHP_EXT_NAME}.so"

	PHPINI=''
	for a in apache2 cli cgi fpm;do
		if [[ -f "/etc/php/${a}-php${PHP_V}/php.ini" ]];then
			PHPINI="${PHPINI} etc/php/${a}-php${PHP_V}/ext/${PHP_EXT_NAME}.ini"
			[[ -d "${D}/etc/php/${a}-php${PHP_V}/ext" ]] || mkdir -p "${D}/etc/php/${a}-php${PHP_V}/ext"
			echo "extension=${PHP_EXT_NAME}.so" > "${D}/etc/php/${a}-php${PHP_V}/ext/${PHP_EXT_NAME}.ini"
			echo "newrelic.appname='App1;App2'" >> "${D}/etc/php/${a}-php${PHP_V}/ext/${PHP_EXT_NAME}.ini"
			echo "newrelic.licensee=''" >> "${D}/etc/php/${a}-php${PHP_V}/ext/${PHP_EXT_NAME}.ini"
		fi
	done 
}

