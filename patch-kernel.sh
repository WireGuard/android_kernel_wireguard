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

if ! [[ $(< Makefile) =~ VERSION[[:space:]]*=[[:space:]]*([0-9]+).*PATCHLEVEL[[:space:]]*=[[:space:]]*([0-9]+).*SUBLEVEL[[:space:]]*=[[:space:]]*([0-9]+) ]]; then
	echo "Unable to parse kernel Makefile." >&2
	exit 1
fi
if (( ((${BASH_REMATCH[1]} * 65536) + (${BASH_REMATCH[2]} * 256) + ${BASH_REMATCH[3]}) < ((3 * 65536) + (10 * 256) + 0) )); then
	echo "WireGuard requires kernels >= 3.10. This is kernel ${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}."
	exit 77
fi

[[ $(< net/Makefile) == *wireguard* ]] || sed -i "/^obj-\\\$(CONFIG_NETFILTER).*+=/a obj-\$(CONFIG_WIREGUARD) += wireguard/" net/Makefile
[[ $(< net/Kconfig) == *wireguard* ]] ||  sed -i "/^if INET\$/a source \"net/wireguard/Kconfig\"" net/Kconfig
[[ -f net/.gitignore && $(< net/.gitignore) == *wireguard* ]] || echo "wireguard/" >> net/.gitignore

cp "$FETCH_SCRIPT" scripts/fetch-latest-wireguard.sh
chmod +x scripts/fetch-latest-wireguard.sh

[[ $(< scripts/Kbuild.include) == *fetch-latest-wireguard.sh* ]] || echo '$(shell cd "$(srctree)" && ./scripts/fetch-latest-wireguard.sh)' >> scripts/Kbuild.include

MODIFIED_FILES=( scripts/Kbuild.include scripts/fetch-latest-wireguard.sh net/.gitignore net/Kconfig net/Makefile )
if [[ -d .git && -n $(git status --porcelain "${MODIFIED_FILES[@]}") ]]; then
	git add "${MODIFIED_FILES[@]}"
	git commit -s -m "net/wireguard: add wireguard importer" "${MODIFIED_FILES[@]}"
fi
