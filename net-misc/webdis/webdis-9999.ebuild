# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit	git-2 user

DESCRIPTION="A fast HTTP interface for Redis"
HOMEPAGE="http://webd.is/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/nicolasff/webdis.git"

LICENSE="AS IS"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/libevent"
RDEPEND="${DEPEND}"

pkg_preinst()
{
	enewgroup webdis
	enewuser webdis

	newinitd ${FILESDIR}/webdis.initd webdis
}
