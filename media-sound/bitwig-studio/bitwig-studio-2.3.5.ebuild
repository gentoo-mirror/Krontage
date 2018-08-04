# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils unpacker

DESCRIPTION=""
HOMEPAGE="https://www.bitwig.com/en/download.html"
SRC_URI="https://downloads-eu.bitwig.com/stable/${PV}/${P}.deb"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack(){
  unpack_deb ${A}
  mkdir -p ${S}
  mv ${WORKDIR}/opt ${WORKDIR}/usr ${S}/
}

src_install(){
  default

  cp -R ${S}/opt ${S}/usr ${D} || die "Install Failed"
}

