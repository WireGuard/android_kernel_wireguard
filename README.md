# [WireGuard](https://www.wireguard.com/) for Android ROMs and Kernels

This repository contains various ways of integrating [WireGuard](https://www.wireguard.com/) into Android systems. The result may be used with [the WireGuard Android GUI app](https://play.google.com/apps/testing/com.wireguard.android). This is currently tested on Android 7 and kernels ≥3.10.

## Integrating into ROMs Directly

This is the preferred approach. It is embedded into your ROM via a simple `local_manifest.xml`, so that WireGuard is built into the kernel and userland of an Android ROM.

To use, add the following local manifest to your project, or include the `<remote>` and `<project>` lines in an existing manifest:

```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="zx2c4" fetch="https://git.zx2c4.com/" />
  <project remote="zx2c4" name="android_kernel_wireguard" path="kernel/wireguard" revision="master" sync-s="true" />
</manifest>
```

After that calls to `repo sync` and `mka bacon` will do the right thing, giving you a WireGuard-enabled ROM.

## Standalone Kernel Built-in Module

If you do not wish to run a custom ROM, but would still like to build a kernel with WireGuard, you may patch WireGuard into your kernel using the following script:

```
$ cd standalone-kernel
$ ./patch-kernel.sh path/to/kernel
```

After this, WireGuard will be included as part of the ordinary kernel build.

## Standalone Tools

If your kernel already has WireGuard, perhaps via a standalone kernel module, but you need the tools for userland, you may build a flashable zip file, installable via recovery, with:

```
$ cd standalone-tools
$ make -j$(nproc)
$ adb sideload wireguard-tools.zip
```

## `wg-quick(8)` for Android

All of the above approaches include [`wg-quick(8)`](https://git.zx2c4.com/WireGuard/about/src/tools/wg-quick.8) for Android, which works via calls to Android's `ndc` command. Compared to the ordinary wg-quick, this one does not support `SaveConfig` and `{Pre,Post}{Up,Down}`. Put your configuration files into `/data/misc/wireguard/`. After that, the normal `wg-quick up|down` commands will work as usual. This is used automatically via the [the WireGuard Android GUI app](https://play.google.com/apps/testing/com.wireguard.android).
