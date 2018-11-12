# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils unpacker

DESCRIPTION="https://www.support.xerox.com"
HOMEPAGE=""
SRC_URI="http://download.support.xerox.com/pub/drivers/CQ8580/drivers/linux/pt_BR/Xeroxv5Pkg-Linuxx86_64-${PV}.deb -> ${P}.deb
x86? ( http://download.support.xerox.com/pub/drivers/CQ8580/drivers/linux/pt_BR/Xeroxv5Pkg-Linuxi686-${PV}.deb )"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack(){
	unpack_deb ${A}
	mkdir -p ${S}

	for f in ${WORKDIR}/usr/share/man/man1/*.gz;do
		gunzip ${f}
	done

	mv ${WORKDIR}/opt ${WORKDIR}/usr ${S}/
}

src_install(){
	default

	cp -R ${S}/opt ${S}/usr ${D} || die "Source Install Failed"

	insinto /usr/libexec/cups/filter
	doins ${S}/opt/Xerox/prtsys/XeroxQScript
	doins ${S}/opt/Xerox/prtsys/XeroxXSF
}

