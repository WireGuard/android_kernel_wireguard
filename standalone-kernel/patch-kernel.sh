#!/bin/bash

FETCH_SCRIPT="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/fetch.sh"
if ! cd "$1"; then
	echo "$1 does not exist." >&2
	exit 1
fi

if [[ ! -e net/Kconfig ]]; then
        echo "You must specify the location of kernel sources as the first argument." >&2
        exit 1
fi

[[ $(< net/Makefile) == *wireguard* ]] || sed -i "/^obj-\\\$(CONFIG_NETFILTER).*+=/a obj-\$(CONFIG_WIREGUARD) += wireguard/" net/Makefile
[[ $(< net/Kconfig) == *wireguard* ]] ||  sed -i "/^if INET\$/a source \"net/wireguard/Kconfig\"" net/Kconfig
[[ -f net/.gitignore && $(< net/.gitignore) == *wireguard* ]] || echo "wireguard/" >> net/.gitignore

cp "$FETCH_SCRIPT" scripts/fetch-latest-wireguard.sh
chmod +x scripts/fetch-latest-wireguard.sh

[[ $(< scripts/Kbuild.include) == *fetch-latest-wireguard.sh* ]] || echo '$(shell cd "$(srctree)" && ./scripts/fetch-latest-wireguard.sh)' >> scripts/Kbuild.include

if [[ -d .git ]]; then
	git add scripts/Kbuild.include scripts/fetch-latest-wireguard.sh net/.gitignore net/Kconfig net/Makefile
	git commit -s -m "net/wireguard: add wireguard importer" scripts/Kbuild.include scripts/fetch-latest-wireguard.sh net/.gitignore net/Kconfig net/Makefile
fi
