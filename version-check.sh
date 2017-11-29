#!/bin/bash
set -e
[[ -n $1 && -f $1/Makefile ]]
[[ $(< "$1/Makefile") =~ VERSION[[:space:]]*=[[:space:]]*([0-9]+).*PATCHLEVEL[[:space:]]*=[[:space:]]*([0-9]+).*SUBLEVEL[[:space:]]*=[[:space:]]*([0-9]+) ]]
LINUX_VERSION_CODE=$(( (${BASH_REMATCH[1]} << 16) | (${BASH_REMATCH[2]} << 8) | ${BASH_REMATCH[3]} ))
(( LINUX_VERSION_CODE >= ((3 << 16) | (10 << 8) | 0) ))
