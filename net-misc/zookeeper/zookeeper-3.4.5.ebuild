# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4


DESCRIPTION="ZooKeeper is a distributed, open-source coordination service for distributed applications."
HOMEPAGE="http://zookeeper.apache.org"
SRC_URI="http://apache.softded.ru/zookeeper/current/${PF}.tar.gz -> ${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="!dev-php/libzookeeper virtual/jre"
RDEPEND="${DEPEND}"

inherit eutils

src_install() {
    dodoc README.txt CHANGES.txt || die
	mkdir -p ${D}/var/www/${PN} || die
	cp -a ${WORKDIR}/$PF/* ${D}/var/www/${PN} || die
	sed -i "s:version=.*:version=${PVR}:g" ${FILESDIR}/zookeeper.confd
	newconfd ${FILESDIR}/zookeeper.confd ${PN}|| die
	newinitd ${FILESDIR}/zookeeper.initd ${PN} || die
	cp -a ${FILESDIR}/zookeeper.cfg ${D}/etc/ || die
}

pkg_preinst() {
    enewgroup zookeeper
    enewuser zookeeper -1 /bin/sh /var/www/${PN} zookeeper -r
}

