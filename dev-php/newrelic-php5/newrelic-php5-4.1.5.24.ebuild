# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PHP_EXT_NAME='newrelic'
inherit eutils

DESCRIPTION="NewRelic PHP5 Agent"
HOMEPAGE="http://newrelic.com"
SRC_URI="https://download.newrelic.com/php_agent/release/${P}-linux.tar.gz"

LICENSE="newrelic Apache-2.0 MIT ISC openssl GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/php"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-linux"

pkg_setup() {
	PHP_VERSION=$(php -v |grep 'PHP [0-9]'|sed -e 's:PHP \([^-]\+\)-\?.*:\1:')
	PHP_EXTENSION=$(php -i 2>/dev/null|grep 'PHP Extension => '|sed -e 's:PHP Extension => \(.\+\):\1:')
	PHP_ZEND_EXTENSION=$(php -i 2>/dev/null|grep 'Zend Extension => '|sed -e 's:Zend Extension => \(.\+\):\1:')
	PHP_EXTENSION_DIR=$(php -i 2>/dev/null|grep ^extension_dir|sed -e 's:extension_dir => \([/a-z0-9.-]\+\).*:\1:')
	PHP_ZTS=$(php -i 2>/dev/null|grep 'Thread Safety => '|sed -e 's:Thread Safety => \(.\+\):\1:')
}

src_install() {
	[ -z "${PHP_VERSION}" ] && die "no php found"
	PHP_V=$(echo ${PHP_VERSION}|sed -e 's:\([0-9]\+\.[0-9]\+\).*:\1:')

	if [ "${PHP_ZTS}" == "enabled" ];then
		PHP_EXTENSION_SOURCE="${PHP_EXT_NAME}-${PHP_EXTENSION}-zts.so"
	else
		PHP_EXTENSION_SOURCE="${PHP_EXT_NAME}-${PHP_EXTENSION}.so"
	fi

	mkdir -p ${D}/${PHP_EXTENSION_DIR} ${D}/etc/newrelic ${T}/${PHP_EXTENSION_DIR}
	newbin "${S}/scripts/newrelic-iutil.x64" "newrelic-iutil"
	newbin "${S}/daemon/newrelic-daemon.x64" "newrelic-daemon"
	newinitd "${FILESDIR}/newrelic-daemon.initd" "newrelic-daemon"

	insinto "/etc/newrelic"
	newins "${S}/scripts/newrelic.cfg.template" "newrelic.cfg"
	insinto

	chmod 644 "${S}/agent/x64/${PHP_EXTENSION_SOURCE}"
	cp -a "${S}/agent/x64/${PHP_EXTENSION_SOURCE}" "${D}/${PHP_EXTENSION_DIR}/${PHP_EXT_NAME}.so"

	PHPINI=''
	for a in apache2 cli cgi fpm;do
		if [[ -f "/etc/php/${a}-php${PHP_V}/php.ini" ]];then
			PHPINI="${PHPINI} etc/php/${a}-php${PHP_V}/ext/${PHP_EXT_NAME}.ini"
			[[ -d "${D}/etc/php/${a}-php${PHP_V}/ext" ]] || mkdir -p "${D}/etc/php/${a}-php${PHP_V}/ext"
			echo "extension=${PHP_EXT_NAME}.so" > "${D}/etc/php/${a}-php${PHP_V}/ext/${PHP_EXT_NAME}.ini"
			echo "newrelic.license=\"\"" >> "${D}/etc/php/${a}-php${PHP_V}/ext/${PHP_EXT_NAME}.ini"
		fi
	done 
}

pkg_preinst() {
	enewgroup newrelic
	enewuser newrelic -1 -1 -1 newrelic
}

