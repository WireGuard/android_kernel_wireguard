# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2015-2017 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.

WIREGUARD_PATH := $(call my-dir)

TARGET_KERNEL_BINARIES: patch-wireguard
patch-wireguard:
	@$(WIREGUARD_PATH)/patch-kernel.sh "$(TARGET_KERNEL_SOURCE)"; \
	ret=$$?; [ $$ret -eq 0 ] && exit 0; [ $$ret -ne 77 ] && exit $$ret; \
	echo -e "" \
		"\e[1;37;41m=================================================\e[0m\n" \
		"\e[1;37;41m+            WARNING WARNING WARNING            +\e[0m\n" \
		"\e[1;37;41m+                                               +\e[0m\n" \
		"\e[1;37;41m+ You are trying to build WireGuard into a      +\e[0m\n" \
		"\e[1;37;41m+ kernel that is too old to run it. Please use  +\e[0m\n" \
		"\e[1;37;41m+ kernel >=3.10. This build will NOT have       +\e[0m\n" \
		"\e[1;37;41m+ WireGuard. You likely added this to your      +\e[0m\n" \
		"\e[1;37;41m+ local_manifest.xml without understanding this +\e[0m\n" \
		"\e[1;37;41m+ requirement. Sorry for the inconvenience.     +\e[0m\n" \
		"\e[1;37;41m=================================================\e[0m" >&2 \
	exit 0

.PHONY: patch-wireguard
