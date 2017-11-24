#!/bin/bash
set -e

[[ $(( $(date +%s) - $(stat -c %Y .last-wireguard-fetch 2>/dev/null || echo 0) )) -gt 21600 ]] || exit 0

[[ $(curl -L https://git.zx2c4.com/WireGuard/refs/) =~ snapshot/(WireGuard-[0-9.]+\.tar\.xz) ]]
rm -rf wireguard-src
mkdir wireguard-src
curl -L "https://git.zx2c4.com/WireGuard/snapshot/${BASH_REMATCH[1]}" | tar -C "wireguard-src" --strip-components=1 -xJf -
touch .last-wireguard-fetch
