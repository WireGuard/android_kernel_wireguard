#!/bin/bash
set -e
WIREGUARD_VERSION=210845cb0716ec46ace66cde4f33e64a29b4e497
LIBMNL_VERSION=1.0.4
USER_AGENT="WireGuard-AndroidROMBuild/0.1 ($(uname -a))"

fetch_wireguard() {
	[[ -d wireguard && -f wireguard/.version && $(< wireguard/.version) == "$WIREGUARD_VERSION" ]] && return 0
	rm -rf wireguard
	mkdir wireguard
	curl -A "$USER_AGENT" -L "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$WIREGUARD_VERSION.tar.xz" | tar -C "wireguard" --strip-components=1 -xJf -
	echo "$WIREGUARD_VERSION" > wireguard/.version
}

fetch_libmnl() {
	[[ -d libmnl && -f libmnl/.version && $(< libmnl/.version) == "$LIBMNL_VERSION" ]] && return 0
	rm -rf libmnl
	mkdir libmnl
	curl -A "$USER_AGENT" -L "https://www.netfilter.org/projects/libmnl/files/libmnl-$LIBMNL_VERSION.tar.bz2" | tar -C libmnl --strip-components=1 -xjf -
	echo "$LIBMNL_VERSION" > libmnl/.version
}

fetch_wireguard
fetch_libmnl
