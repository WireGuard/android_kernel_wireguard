#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2015-2017 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.

set -e
WIREGUARD_VERSION=79944b183795bb69e12d612bd802b54599b9eb99
LIBMNL_VERSION=1.0.4
USER_AGENT="WireGuard-AndroidROMBuild/0.1 ($(uname -a))"

fetch_wireguard() {
	[[ -d wireguard && -f wireguard/.version && $(< wireguard/.version) == "$WIREGUARD_VERSION" ]] && return 0
	rm -rf wireguard
	mkdir wireguard
	curl -A "$USER_AGENT" -LSs "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$WIREGUARD_VERSION.tar.xz" | tar -C "wireguard" --strip-components=1 -xJf -
	echo "$WIREGUARD_VERSION" > wireguard/.version
}

fetch_libmnl() {
	[[ -d libmnl && -f libmnl/.version && $(< libmnl/.version) == "$LIBMNL_VERSION" ]] && return 0
	rm -rf libmnl
	mkdir libmnl
	curl -A "$USER_AGENT" -LSs "https://www.netfilter.org/projects/libmnl/files/libmnl-$LIBMNL_VERSION.tar.bz2" | tar -C libmnl --strip-components=1 -xjf -
	echo "$LIBMNL_VERSION" > libmnl/.version
}

fetch_wireguard
fetch_libmnl
