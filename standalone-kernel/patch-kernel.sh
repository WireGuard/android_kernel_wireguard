#!/bin/bash

cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
K="$1"

if [[ ! -e $K/net/Kconfig ]]; then
        echo "You must specify the location of kernel sources as the first argument." >&2
        exit 1
fi

[[ $(< "$K/net/Makefile") == *wireguard* ]] || sed -i "/^obj-\\\$(CONFIG_NETFILTER).*+=/a obj-\$(CONFIG_WIREGUARD) += wireguard/" "$K/net/Makefile"
[[ $(< "$K/net/Kconfig") == *wireguard* ]] ||  sed -i "/^if INET\$/a source \"net/wireguard/Kconfig\"" "$K/net/Kconfig"
[[ $(< "$K/.gitignore") == *wireguard* ]] || echo "net/wireguard/" >> "$K/.gitignore"

cp fetch.sh "$K/scripts/fetch-latest-wireguard.sh"
chmod +x "$K/scripts/fetch-latest-wireguard.sh"

[[ $(< "$K/scripts/Kbuild.include") == *fetch-latest-wireguard.sh* ]] || echo '$(shell cd "$(srctree)" && ./scripts/fetch-latest-wireguard.sh)' >> "$K/scripts/Kbuild.include"
