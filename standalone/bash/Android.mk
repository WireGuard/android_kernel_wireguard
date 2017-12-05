ifeq ($(IN_THE_RIGHT_PLACE),yes-yes-i-am)
THIS_DIR := $(call my-dir)

# AOSP build system things:
define all-c-files-under
$(call all-named-files-under,*.c,$(1))
endef
define all-named-files-under
$(call find-files-in-subdirs,$(LOCAL_PATH),"$(1)",$(2))
endef
define find-files-in-subdirs
$(sort $(patsubst ./%,%, \
  $(shell cd $(1) ; \
          find -L $(3) -name $(2) -and -not -name ".*") \
 ))
endef

$(shell cd $(THIS_DIR) && ./fetch.sh )
include $(THIS_DIR)/android_external_libncurses-cm-14.1/Android.mk
include $(THIS_DIR)/android_external_bash-cm-14.1/Android.mk
__ndk_modules.bash.CFLAGS += -D'getdtablesize()=sysconf(_SC_OPEN_MAX)'
__ndk_modules.builtins.CFLAGS += -D'getdtablesize()=sysconf(_SC_OPEN_MAX)'
endif
