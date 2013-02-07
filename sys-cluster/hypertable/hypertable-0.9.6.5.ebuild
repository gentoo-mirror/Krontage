# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit rpm

DESCRIPTION="Hypertable is a high performance, open source, massively scalable database modeled after Bigtable, Google's proprietary, massively scalable database."
HOMEPAGE="http://hypertable.com"
SRC_URI="
	http://cdn.hypertable.com/packages/${PV}/${P}-linux-x86_64.rpm
	x86? ( http://cdn.hypertable.com/packages/${PV}/${P}-linux-i386.rpm )
	"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="x86"

DEPEND="sys-apps/keyutils"
RDEPEND="${DEPEND}"

S=${WORKDIR}/opt/${PN}/${PV}

src_install() {
	dodir /opt/${PN} || die
	dodir /etc/${PN} || die
	dodir /var/db/${PN} || die

	sed	-i "s:varhome=.*:varhome=/var/db/${PN}:" ${S}/bin/fhsize.sh || ewarn
	sed -i "s:etchome=.*:etchome=/etc/${PN}:" ${S}/bin/fhsize.sh || ewarn

	cp -a ${S}/ ${D}/opt/${PN} || die "install failed"

	dosym /opt/${PN}/${PV} /opt/${PN}/current || ewarn "symlink exists? you need to change it manually"
}

pkg_preinst() {
	enewgroup hypert
	enewuser hypert -1 -1 /opt/${PN} hypert || ewarn "unable to create user hypert"

	fowners	hypert. /opt/${PN} || ewarn
	fowners	hypert. /etc/${PN} || ewarn
	fowners	hypert. /var/db/${PN} || ewarn
}

pkg_postinst() {
	elog "firstly, before using, you may need to run fhsize.sh: sudo -u hypert /opt/${PN}/${PV}/bin/fhsize.sh"
	elog "all configs are placed to /etc/${PN}, database files are in /var/db/${PN}"
	elog "to run the server - edit /etc/${PN}/${PN}.conf and execute
	sudo -u hypert /opt/${PN}/current/bin/start-all-servers.sh"
	elog "full manual reference about installation can be found on the page:
	http://hypertable.com/documentation/installation/quick_start_standalone/"
}
