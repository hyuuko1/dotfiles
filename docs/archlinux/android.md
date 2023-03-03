```bash
# 安装 android-tools（包含 adb 和 fastboot 等工具）
paru android-tools
```

## Waydroid

- [Waydroid - ArchWiki](https://wiki.archlinux.org/title/Waydroid)
- [Anbox - ArchWiki](https://wiki.archlinux.org/title/Anbox)

教程

- [How to Install Android 11 on Arch Linux Using Waydroid | Install Waydroid 11 on Arch Linux - YouTube](https://www.youtube.com/watch?v=6ib0A0hs7JM)
- [Waydroid on KDE 初体验 - 竹林里有冰的博客](https://zhul.in/2021/10/31/waydroid-experience-on-kde/)

**GPU 的要求**

对于 Intel 的 CPU，开箱即用。

```bash
# linux-zen 自带 Waydroid 需要的 Ashmem 和 binder 模块
# 注：AUR上的 linux-xanmod 虽然也有这些模块支持，但是在编译时设置了 psi=0
# 以提升性能，而 waydroid 恰巧需要 psi=1 的支持，故不可使用。
sudo pacman -S linux-zen linux-zen-headers

# 生成 grub 配置文件（即更新 grub 界面的选择菜单）
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

```bash
paru waydroid
```

TODO 好像还需要安装 arm 转译库
