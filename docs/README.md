- [Comparison of Linux distributions - Wikipedia](https://en.wikipedia.org/wiki/Comparison_of_Linux_distributions)
  预编译的软件包数（ArchLinux 的包粒度没那么细）
  - ArchLinux 13,307 + 85134 (AUR)
  - CentOS 6,813
  - Debian 153,621
  - Ubuntu 100,530

我觉得 ArchLinux 的一些优点

- ArchWiki 文档丰富齐全
- 软件包依赖简单，粒度没有 Ubuntu 这么细
- AUR 与 FreeBSD Ports 类似，软件包丰富
- 软件包很新，而且更贴近上游，不带私货，比如 gnome、KDE 就是原生的样子
- 定制型强，从头安装一个 ArchLinux 系统，用户可以了解 linux 软件包组成的机制，一些具有系统洁癖的人会很受用
- 滚动升级，随时用上最新的东西
- pacman 速度快，压缩方式从 xz 到 zst 了，解压效率高了 10 倍多，包的大小只大了 1%。

<hr>

Arch Linux teach you Linux, while Ubuntu teach you Ubuntu.

TODO

- 好好学习一下打包，研究怎么把 .deb 的打包成 ArchLinux 的

##

- [getpelican/pelican: Static site generator that supports Markdown and reST syntax. Powered by Python.](https://github.com/getpelican/pelican)
  - https://github.com/bekcpear/bitbiliNewTheme 这个主题不错

## kde wayland 亮度

目前 kde wayland 只支持 night color，也就是屏幕会变黄

Gamma 指光亮度值的编码，用于补偿人类视觉的非线性特点，从而获得给定波宽的最佳图像质量。Gamma 是指编码光亮度与所需输出光亮度之间的关系。Gamma 值会影响白点、显示 RGB 中性色的全局能力，以及显示器可能显示的全局暗度和对比度。

[WIP: Add option to set gamma values (!1335) · Merge requests · Plasma / KWin · GitLab](https://invent.kde.org/plasma/kwin/-/merge_requests/1335)

## Sway

- [Sway](https://swaywm.org/)
- [Sway](https://github.com/swaywm)
  - [Sway Wiki](https://github.com/swaywm/sway/wiki)
  - [swaywm/sway: i3-compatible Wayland compositor](https://github.com/swaywm/sway)
    - [Home · swaywm/sway Wiki](https://github.com/swaywm/sway/wiki)
  - Sway 的开发者维护的 [wlroots/wlroots · GitLab](https://gitlab.freedesktop.org/wlroots/wlroots)

Sway 是和 i3 兼容的 Wayland compositor，基于 wlroots（一个模块，用于构建 wayland 混成器）。

##

- [freedesktop](https://freedesktop.org/wiki/) 的文档挺多的

## Asahi Linux

- [About - Asahi Linux](https://asahilinux.org/about/)

Asahi Linux is a project and community with the goal of porting Linux to Apple Silicon Macs.

## 平铺式

i3 sway
bspwm
dwm

## kde + nvidia + wayland

- [Arch Linux Wayland 之路 | i1nfo](https://blog.i1nfo.com/posts/arch-linux-wayland/index.html)
- [NVIDIA 驱动和 GNOME 和 Wayland - 喵's StackHarbor](https://sh.alynx.one/posts/NVIDIA-GNOME-Wayland/)
- [Wayfire&Awesome-Wayland&X11 | Moichi Rain](http://moichi.cn/posts/2023/01/24/Wayfire-Awesome/)
- [2022 年,用 Wayland 开启 linux - 知乎](https://zhuanlan.zhihu.com/p/531205278)
  有问题可以看评论区
- [Plasma/Wayland Showstoppers - KDE Community Wiki](https://community.kde.org/Plasma/Wayland_Showstoppers)
  Plasma/Wayland 问题清单
- [Plasma/Wayland/Nvidia - KDE Community Wiki](https://community.kde.org/Plasma/Wayland/Nvidia)
  Plasma/Wayland/Nvidia 官方指南

`paru -S plasma-workspace`

我目前用的独显模式，安装的 nvidia 而非 nvidia-open，感觉闭源的更稳定。
根据[NVIDIA - ArchWiki](https://wiki.archlinux.org/title/NVIDIA)
目前 Wayland 只能在使用了 KMS 的系统上工作，也就是说需要 enable DRM (Direct Rendering Manager) kernel mode setting，
`sudo vim /etc/default/grub` 添加内核参数 `nvidia_drm.modeset=1`，然后 `sudo grub-mkconfig -o /boot/grub/grub.cfg` 重新生成 grub 配置文件。
把 `nvidia_drm.fbdev=1` 也加上，
根据 [NVIDIA/Tips and tricks - ArchWiki](https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks) 和 https://bugs.kde.org/show_bug.cgi?id=448866，要把 `nvidia.NVreg_PreserveVideoMemoryAllocations=1` 也加上，并且 sudo systemctl enable nvidia-suspend.service, nvidia-hibernate.service, nvidia-resume.service

- 注意，下面这几步生成 initramfs 的可以跳过，实测不影响
  `sudo vim /etc/mkinitcpio.conf`，在 `MODULES` 里添加 `nvidia nvidia_modeset nvidia_uvm nvidia_drm` 这几个内核模块，如果是 I+N 双显卡的用户最好再额外添加 `intel_agp i915` 两个内核模块。
  然后再 `sudo mkinitcpio -P` 重新生成 initramfs。（草，100 多 M。。。）
  `sudo vim /etc/pacman.d/hooks/nvidia.hook` 设置 hooks，在每次 nvidia 驱动更新后都重新生成 initramfs
  ```conf
  [Trigger]
  Operation=Install
  Operation=Upgrade
  Operation=Remove
  Type=Package
  Target=nvidia
  Target=linux
  # Change the linux part above and in the Exec line if a different kernel is used
  [Action]
  Description=Update NVIDIA module in initcpio
  Depends=mkinitcpio
  When=PostTransaction
  NeedsTargets
  Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/  mkinitcpio -P'
  ```

不需要设置缩放，100%即可，设置一下字体 DPI 120，注销，重新登录，就好了。

**注意**

- 不建议在 BIOS 打开 NVIDIA 独显模式，会有许多小 bug，比如：睡眠后唤醒时，会闪屏，根本没法用，已经退回 x11 :(
  搜索 kde plasma nvidia wayland wake up from sleep , Tear, graphical glitches
  [448866 – \[NVIDIA\] Graphical glitches and unresponsive after waking from sleep](https://bugs.kde.org/show_bug.cgi?id=448866)
- 建议使用 optimus-managert-qt，设置开机时默认使用集显。打游戏时再通过 prime-run 使用独显就行

###

自 NVIDIA 在版本 495 引入 GBM 支持以来，许多合成器 (包括 Mutter 和 KWin) 都开始默认使用 GBM 。通常认为 GBM 更好，有更为广泛的支持，而以前仅支持 EGLStreams 是因为之前无法在 Wayland 下通过专有驱动程序来使用 NVIDIA GPU。此外，在 NVIDIA 支持 GBM 后，KWin 放弃了对 EGLStreams 的支持[2]。

如果您使用的是流行的桌面环境/混成器，GPU 也受 NVIDIA 支持，那么很可能已经在使用 GBM 后端了。要检查是否使用 GBM 后端，请执行 journalctl -b 0 --grep "renderer for"。要强制使用 GBM 后端，请设置以下环境变量：

```bash
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
```

```bash
# 查看 Buffer API 是 GBM 还是 EGL
# 仍是 EGL。。上文的设置环境变量没用
❯ qdbus org.kde.KWin /KWin supportInformation | grep EGL
OpenGL platform interface: EGL

❯ printenv | grep wayland
DESKTOP_SESSION=plasmawayland
WAYLAND_DISPLAY=wayland-0
XDG_SESSION_TYPE=wayland
```

## 内核模块

Linux 系统加载哪些内核模块，和配置文件有关系。

模块位置：

- `` /usr/lib/modules/`uname -r`/kernel/ `` 是一些没有被编译进内核的模块
- `` /usr/lib/modules/`uname -r`/extramodules/ `` 是一些 out-of-tree 的模块

`/usr/lib/modules-load.d/` `/etc/modules-load.d/` 配置系统启动时加载哪些模块。
`/usr/lib/modprobe.d/` 和 `/etc/modprobe.d/` 配置模块加载时的一些参数.

systemd-modules-load.service 会读取这些配置，

```bash
# 查看有效的配置
❯ systemd-analyze cat-config modules-load
# /usr/lib/modules-load.d/nvidia-utils.conf
nvidia-uvm

❯ systemd-analyze cat-config modprobe.d
# /usr/lib/modprobe.d/nvdimm-security.conf
install libnvdimm /usr/bin/ndctl load-keys ; /sbin/modprobe --ignore-install libnvdimm $CMDLINE_OPTS

# /usr/lib/modprobe.d/nvidia-utils.conf
blacklist nouveau

# /usr/lib/modprobe.d/optimus-manager.conf
blacklist nouveau
blacklist nvidia_drm
blacklist nvidia_uvm
blacklist nvidia_modeset
blacklist nvidia

略 ...
```

**initramfs**
linux 还可以在 early user space (initramfs) 加载模块

mkinitcpio 生成 initramfs，配置文档见 [mkinitcpio - ArchWiki](https://wiki.archlinux.org/title/mkinitcpio#Configuration)

[Arch 下使用 bbswitch 彻底禁用双显卡笔记本的独立显卡 - YaCHEN's Blog](https://xuchen.wang/archives/archbbswitch.html)
这是一个没有使用 optimus-manager 的方案。
