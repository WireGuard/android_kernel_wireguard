WIREGUARD_PATH := $(call my-dir)

fetch-wireguard:
	cd "$(WIREGUARD_PATH)" && ./fetch-wireguard.sh

TARGET_KERNEL_BINARIES: patch-wireguard
patch-wireguard: fetch-wireguard
	ln -vsfT "$$(realpath --relative-to="$(TARGET_KERNEL_SOURCE)/net)" "$(WIREGUARD_PATH)/wireguard-src/src")" "$(TARGET_KERNEL_SOURCE)/net/wireguard"
	grep -q wireguard "$(TARGET_KERNEL_SOURCE)/net/Makefile" || sed -i "/^obj-\\\$$(CONFIG_NETFILTER).*+=/a obj-\$$(CONFIG_WIREGUARD) += wireguard/" "$(TARGET_KERNEL_SOURCE)/net/Makefile"
	grep -q wireguard "$(TARGET_KERNEL_SOURCE)/net/Kconfig" || sed -i "/^if INET\$$/a source \"net/wireguard/Kconfig\"" "$(TARGET_KERNEL_SOURCE)/net/Kconfig"

fetch-libmnl:
	rm -rf "$(WIREGUARD_PATH)/libmnl-src" && mkdir "$(WIREGUARD_PATH)/libmnl-src"
	curl -L "https://www.netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2" | tar -C "$(WIREGUARD_PATH)/libmnl-src" --strip-components=1 -xjf -

.PHONY: fetch-wireguard fetch-libmnl patch-wireguard

LOCAL_PATH := $(WIREGUARD_PATH)
include $(CLEAR_VARS)
MNL := libmnl-src/src
WG := wireguard-src/src/tools
WG_FILES := $(WG)/config.c $(WG)/curve25519.c $(WG)/encoding.c $(WG)/genkey.c $(WG)/ipc.c $(WG)/mnlg.c $(WG)/pubkey.c $(WG)/set.c $(WG)/setconf.c $(WG)/show.c $(WG)/showconf.c $(WG)/terminal.c $(WG)/wg.c
MNL_FILES := $(MNL)/attr.c $(MNL)/callback.c $(MNL)/nlmsg.c $(MNL)/socket.c
$(foreach F,$(WG_FILES) $(MNL_FILES),$(WIREGUARD_PATH)/$(F)): fetch-wireguard fetch-libmnl
LOCAL_SRC_FILES := $(WG_FILES) $(MNL_FILES)
LOCAL_C_INCLUDES := $(WIREGUARD_PATH)/$(MNL)/ $(WIREGUARD_PATH)/$(WG)/ $(WIREGUARD_PATH)/$(MNL)/../include/
LOCAL_CFLAGS := -O3 -std=gnu11 -D_GNU_SOURCE -DHAVE_VISIBILITY_HIDDEN -DRUNSTATEDIR="\"/data/local/run\"" -Wno-pointer-arith -Wno-unused-parameter
LOCAL_MODULE := wg
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_CLASS := EXECUTABLES
ALL_DEFAULT_INSTALLED_MODULES += wg
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := wg-quick
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_SRC_FILES := wg-quick.bash
LOCAL_REQUIRED_MODULES := bash wg
LOCAL_MODULE_CLASS := EXECUTABLES
ALL_DEFAULT_INSTALLED_MODULES += wg-quick
include $(BUILD_PREBUILT)
