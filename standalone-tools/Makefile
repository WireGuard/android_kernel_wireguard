# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2015-2017 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.

ARCHS := $(shell ndk-build NDK_PROJECT_PATH=$(PWD)/build APP_BUILD_SCRIPT=$(PWD)/../Android.mk APP_PLATFORM=21 DUMP_NDK_KNOWN_DEVICE_ABIS 2>/dev/null)

all: wireguard-tools.zip

clean:
	rm -rf build wireguard-tools.zip

wg-build: ../wg-quick.c
	ndk-build NDK_PROJECT_PATH=$(PWD)/build APP_BUILD_SCRIPT=$(PWD)/../Android.mk APP_PLATFORM=21

$(foreach ARCH,$(ARCHS),build/libs/$(ARCH)/wg build/libs/$(ARCH)/wg-quick): wg-build

wireguard-tools.zip: $(foreach ARCH,$(ARCHS),build/libs/$(ARCH)/wg-quick build/libs/$(ARCH)/wg) installer.sh addonsd.sh
	rm -rf $@ build/zip build/*.zip
	mkdir -p build/zip build/zip/addon.d build/zip/META-INF/com/google/android
	ln -frs build/libs build/zip/arch
	ln -frs addonsd.sh build/zip/addon.d/40-wireguard.sh
	ln -frs installer.sh build/zip/META-INF/com/google/android/update-binary
	touch build/zip/META-INF/com/google/android/updater-script
	cd build/zip && zip -0Xr ../unaligned-$@ .
	openssl req -x509 -nodes -newkey rsa:2048 -keyout build/key.pem -out build/cert.pem -days 3650 -subj /CN=$$(hostname)/
	openssl pkcs8 -topk8 -inform PEM -outform DER -in build/key.pem -out build/key.pk8 -nocrypt
	$(ANDROID_HOME)/build-tools/27.0.1/zipalign -v -p 4 build/unaligned-$@ build/aligned-$@
	$(ANDROID_HOME)/build-tools/27.0.1/apksigner sign --key build/key.pk8 --cert build/cert.pem --min-sdk-version 21 --out $@ build/aligned-$@

.PHONY: clean all
.SECONDARY:
