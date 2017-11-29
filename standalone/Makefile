ARCHS := arm64-v8a armeabi armeabi-v7a mips mips64 x86 x86_64

all: $(foreach ARCH,$(ARCHS),wg-tools-$(ARCH).tar.gz)

clean:
	rm -rf wg-build $(foreach ARCH,$(ARCHS),wg-tools-$(ARCH).tar.gz)

wg:
	rm -rf wg-build
	mkdir -p wg-build
	ndk-build NDK_PROJECT_PATH=$(PWD)/wg-build APP_BUILD_SCRIPT=$(PWD)/../Android.mk APP_PLATFORM=24

define arch_rule
wg-build/libs/$(1)/wg: wg
wg-tools-$(1).tar.gz: wg-build/libs/$(1)/wg install.sh ../wg-quick.bash addonsd.sh
	rm -f $$@
	mkdir -p wg-build/libs/$(1)/wg-tools
	ln -frst wg-build/libs/$(1)/wg-tools/ $$^
	tar -chzf $$@ -C wg-build/libs/$(1) wg-tools
endef
$(foreach ARCH,$(ARCHS),$(eval $(call arch_rule,$(ARCH))))

.PHONY: clean all
.SECONDARY:
