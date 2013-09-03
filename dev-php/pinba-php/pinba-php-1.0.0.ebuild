# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 php-ext-source-r2

DESCRIPTION="Pinba PHP Extension"
HOMEPAGE="http://pinba.org/"
EGIT_REPO_URI="https://github.com/tony2001/pinba_engine.git"

LICENSE="GNU GPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/php"
RDEPEND="${DEPEND}"

