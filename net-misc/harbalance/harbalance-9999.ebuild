# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2

DESCRIPTION="Ruby writen and EventMachine based Haproxy weight balancer"
HOMEPAGE="https://github.com/undying/harbalance"
SRC_URI=""
EGIT_REPO_URI="https://github.com/undying/harbalance"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
${DEPEND}
dev-ruby/eventmachine
dev-ruby/oj
"

src_install() {
	mkdir -p ${D}/etc/harb

	newbin ${S}/harb.rb harb
	newbin ${S}/harbd.rb harbd

	newconfd ${S}/harb.confd harb
	newconfd ${S}/harbd.confd harbd

	newinitd ${S}/harb.initd harb
	newinitd ${S}/harbd.initd harbd

	cp ${S}/harb.conf.sample ${D}/etc/harb/harb.conf
	cp ${S}/harbd.conf.sample ${D}/etc/harb/harbd.conf
}

