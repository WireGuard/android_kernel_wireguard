# [WireGuard](https://www.wireguard.com/) for Android ROMs and Kernels

This repository contains various ways of integrating [WireGuard](https://www.wireguard.com/) into Android systems. The result may be used with [the WireGuard Android GUI app](https://play.google.com/apps/testing/com.wireguard.android). This is currently tested on Android 6, 7, and 8 and kernels ≥3.10.

Choose between **Method A** and **Method B**, below. Do not choose both methods at the same time.

## Method A: Adding to Kernel Trees

If you maintain your own kernel, you may easily patch your kernel tree to support WireGuard with the following command:

```
$ ./patch-kernel.sh path/to/kerneltree
```

This will patch your kernel and create a commit for you.

## Method B: Integrating into ROMs

If you do not maintain your own kernel, but rather maintain a `local_manifest.xml` file, and would like to add WireGuard to your ROM, you can simply add these two lines to your `local_manifest.xml`:

```
  <remote name="zx2c4" fetch="https://git.zx2c4.com/" />
  <project remote="zx2c4" name="android_kernel_wireguard" path="kernel/wireguard" revision="master" sync-s="true" />
```

Then, run `repo sync`. The kernel used by your ROM will automatically gain WireGuard support.
