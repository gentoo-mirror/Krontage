# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit	user

MY_PN="ArangoDB"
S=${S/${PV}/${MY_PN}}

DESCRIPTION="ArangoDB is a universal open-source database with flexible data
model for documents, graphs, and key-values."
HOMEPAGE="http://www.arangodb.org/"
SRC_URI="https://www.arangodb.org/repositories/stable/Source/${MY_PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/libev-4.04
	>=dev-lang/v8-3.12.19.15
	>=sys-libs/readline-6.2_p1
	>=dev-libs/openssl-1.0.0j
	>=dev-libs/icu-49.1.2"
RDEPEND="${DEPEND}"

pkg_setup() {
	ebegin "Creating arangodb user and group"
	enewgroup arangodb
	enewuser arangodb -1 -1 -1 arangodb
	eend $?
}

src_configure() {
	econf --localstatedir="${EPREFIX}"/var --disable-all-in-one-v8 --disable-all-in-one-libev --disable-all-in-one-icu
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/arangodb.initd arangodb

	fowners arangodb:arangodb /var/log/arangodb
	fowners arangodb:root     /var/lib/arangodb
}

