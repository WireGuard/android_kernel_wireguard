WIREGUARD_PATH := $(call my-dir)

fetch:
	cd $(WIREGUARD_PATH) && ./fetch.sh

TARGET_KERNEL_BINARIES: patch-wireguard
patch-wireguard: fetch
	ln -vsfT "$$(realpath --relative-to="$(TARGET_KERNEL_SOURCE)/net)" "$(WIREGUARD_PATH)/wireguard/src" || readlink -f "$(WIREGUARD_PATH)/wireguard/src")" "$(TARGET_KERNEL_SOURCE)/net/wireguard"
	grep -q wireguard "$(TARGET_KERNEL_SOURCE)/net/Makefile" || sed -i "/^obj-\\\$$(CONFIG_NETFILTER).*+=/a obj-\$$(CONFIG_WIREGUARD) += wireguard/" "$(TARGET_KERNEL_SOURCE)/net/Makefile"
	grep -q wireguard "$(TARGET_KERNEL_SOURCE)/net/Kconfig" || sed -i "/^if INET\$$/a source \"net/wireguard/Kconfig\"" "$(TARGET_KERNEL_SOURCE)/net/Kconfig"

.PHONY: patch-wireguard fetch

LOCAL_PATH := $(WIREGUARD_PATH)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(shell cd $(WIREGUARD_PATH) && ./generate-tools-filelist.sh)
$(foreach F,$(LOCAL_SRC_FILES),$(WIREGUARD_PATH)/$(F)): fetch
LOCAL_C_INCLUDES := $(WIREGUARD_PATH)/libmnl/src/ $(WIREGUARD_PATH)/libmnl/include/ $(WIREGUARD_PATH)/wireguard/src/tools/
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
