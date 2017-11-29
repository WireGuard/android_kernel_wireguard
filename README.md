[WireGuard](https://www.wireguard.com/) for Android ROMs
==========================

This is a repository meant to be included via a `local_manifest.xml`, so that [WireGuard](https://www.wireguard.com/) is built into the kernel and userland of an Android ROM. This is currently tested on Android 7 and kernels ≥3.10. It may be used with [the WireGuard Android GUI app](https://play.google.com/apps/testing/com.wireguard.android).

Usage
-----

Add the following local manifest to your project, or include the `<remote>` and `<project>` lines in an existing manifest:

```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="zx2c4" fetch="https://git.zx2c4.com/" />
  <project remote="zx2c4" name="android_kernel_wireguard" path="kernel/wireguard" revision="master" sync-s="true" />
</manifest>
```

Tools
-----

In addition to the kernel module, this repository also contains a version of [`wg-quick(8)`](https://git.zx2c4.com/WireGuard/about/src/tools/wg-quick.8) that works with Android 7's `ndc` command. Compared to the ordinary wg-quick, this one does not support `SaveConfig` and `{Pre,Post}{Up,Down}`. Put your configuration files into `/data/misc/wireguard/`. After that, the normal `wg-quick up|down` commands will work as usual. Users who only want the tools without having to use this inside a ROM may use the [standalone tool building/installing scripts](standalone/README.md).
