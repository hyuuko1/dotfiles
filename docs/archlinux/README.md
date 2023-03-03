目录

- [注意](#注意)
- [部分参考资料](#部分参考资料)
  - [ArchWiki](#archwiki)
- [安装前的准备](#安装前的准备)
  - [启动到 Live 环境](#启动到-live-环境)
  - [验证启动模式](#验证启动模式)
  - [连接到因特网](#连接到因特网)
  - [更新系统时间](#更新系统时间)
  - [建立硬盘分区](#建立硬盘分区)
  - [格式化分区](#格式化分区)
  - [挂载分区](#挂载分区)
- [安装](#安装)
  - [更换镜像源](#更换镜像源)
  - [安装必须的软件包](#安装必须的软件包)
- [配置系统](#配置系统)
  - [Fstab](#fstab)
  - [Chroot](#chroot)
  - [时区](#时区)
  - [本地化](#本地化)
  - [设置计算机名](#设置计算机名)
  - [Initramfs](#initramfs)
  - [设置 Root 密码](#设置-root-密码)
  - [安装引导程序](#安装引导程序)
  - [重启进入安装好了的 Arch Linux](#重启进入安装好了的-arch-linux)
- [安装后的工作](#安装后的工作)
  - [联网](#联网)
  - [添加 archlinuxcn 源](#添加-archlinuxcn-源)
  - [新建用户](#新建用户)
  - [图形界面](#图形界面)
    - [显示服务 (Display Server)](#显示服务-display-server)
  - [显示驱动（Display drivers）](#显示驱动display-drivers)
    - [桌面环境（Desktop Environment，DE）+ 窗口管理器（Window Manager, WM）](#桌面环境desktop-environmentde-窗口管理器window-manager-wm)
    - [显示管理器（Display manager）](#显示管理器display-manager)
  - [Btrfs 快照](#btrfs-快照)
  - [zram](#zram)
  - [字体](#字体)
    - [微软字体](#微软字体)
  - [输入法](#输入法)
  - [代理](#代理)
  - [AUR - Arch 用户软件源](#aur---arch-用户软件源)
  - [常用软件](#常用软件)
  - [zsh](#zsh)
  - [开发环境](#开发环境)
  - [美化](#美化)
- [其他](#其他)
  - [kwallet](#kwallet)
  - [调整鼠标滚轮速度](#调整鼠标滚轮速度)
  - [显示器亮度](#显示器亮度)
  - [更换内核](#更换内核)
  - [校园网](#校园网)
- [Tips \& Tricks](#tips--tricks)
- [Dotfiles 管理](#dotfiles-管理)
- [系统维护](#系统维护)
- [常见问题排除与解决](#常见问题排除与解决)
- [设备](#设备)
  - [蓝牙](#蓝牙)
  - [鼠标宏](#鼠标宏)

## 注意

- 关于 ntfs3
  - 从 linux 5.15 开始，由 Paragon 开发的 NTFS3 驱动并入了内核，如果内核版本在此之前，可以使用 ntfs-3g（基于 FUSE，性能很拉），[在 macos 上的性能对比](https://maxim-saplin.github.io/cpdt_results/?selected=43%2C44)。如果想提前体验，可以通过 ntfs-dkms 软件包为当前内核编译安装[fs/ntfs3 模块](https://github.com/torvalds/linux/tree/master/fs/ntfs3)。
    ```bash
    # 建议从 archlinuxcn 软件源安装
    sudo pacman -S ntfs3-dkms
    ```
    记得修改 `/etc/fstab` 中与 ntfs3 文件系统有关的条目，比如修改为 `/dev/nvme1n1p4 /mnt/XXX ntfs3 rw,nosuid,nodev,noatime,uid=1000,gid=1000,iocharset=utf8,prealloc 0 0`
  - 5.15 内核虽然支持 ntfs3，但是 Paragon 还未给出相应的 userspace utiltiies，可以选择使用 tuxera 的 [ntfsprogs-ntfs3](https://aur.archlinux.org/packages/ntfsprogs-ntfs3/)（提供了 `/usr/bin/mount.ntfs` `/usr/bin/mkfs.ntfs` 等工具）用于挂载、格式化等操作。见 <https://wiki.archlinux.org/title/NTFS>。这样使用 `mount` 命令进行挂载时，该命令会 fork 并 exece `/usr/bin/mount.ntfs`，然后 mount syscall 会使用内核中的 ntfs3 模块进行挂载/读写。
  - 如果你使用 ntfs-3g，但仍想要使用内核中的 ntfs3 模块，那么使用 `mount` 命令时请指定 `-t ntfs3` 选项。对于 Dolphin 文件管理器（应该是直接使用 mount 系统调用？）需要修改默认的挂载选项，见[NTFS#udisks_support - Archlinux](https://wiki.archlinux.org/title/NTFS#udisks_support)（也可安装 ntfsprogs-ntfs3，这个包提供了配置文件）
  - `5.15.5-arch1-1` 如果 vscode 打开着 ntfs3 文件系统里的文件夹，那么此时关机的话，会出现这种错误：
    ```log
    Nov 18 15:06:45 archlinux systemd[1]: Failed unmounting /mnt/Share.
    ░░ Subject: A stop job for unit mnt-Share.mount has finished
    ░░ Defined-By: systemd
    ░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
    ░░
    ░░ A stop job for unit mnt-Share.mount has finished.
    ░░
    ░░ The job identifier is 1451 and the job result is failed.
    ```

## 部分参考资料

### ArchWiki

建议边看 ArchWiki 的英文版本（中文翻译不怎么及时，有许多已经过时的内容）边安装，遇到的问题，一般都能在 ArchWiki 找到答案。

- [Installation guide (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Installation_guide_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [General recommendations (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/General_recommendations_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [List of applications (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/List_of_applications_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

其他的一些很不错的教程，可以与本教程对照着看

- [Arch Linux 安装使用教程](https://archlinuxstudio.github.io/ArchLinuxTutorial/#/)
- [archlinux 简明指南](https://arch.icekylin.online/)
  - [序章 | archlinux 简明指南](https://arch.icekylin.online/guide/)
  - [常用软件 | archlinux 简明指南](https://arch.icekylin.online/app/common/daily.html)

## 安装前的准备

1. 从[SJTU 镜像站](https://mirror.sjtu.edu.cn/archlinux/iso/latest/)下载 `archlinux-版本日期-x86_64.iso` 镜像文件到你的电脑上（[其他的镜像站](https://archlinux.org/download/#:~:text=China,edu.cn)）
2. 准备一个 1G 大小以上 U 盘（容量比 archlinux 的镜像文件大就行，如果没 U 盘，可以试试在已获取 Root 权限的手机上用 DriveDroid 模拟 U 盘）
3. 将 [ventoy](https://www.ventoy.net/cn/doc_start.html) 安装进 U 盘（分区类型选择 GPT）。注意只有第一次安装需要格式化。安装完成之后，U 盘会被分成两个分区，将 ArchLinux ISO 文件复制至 U 盘的第一个分区（容量大的那个）即可，Ventoy 默认会遍历该分区下所有的目录和子目录，找出所有的镜像文件，并按照字母排序之后显示在菜单中。
4. 使用 Windows/Linux 的磁盘管理工具分出一块**未分配**的区域供我们要安装的 ArchLinux 使用
5. 如果你的电脑上有 Windows，那么请务必**禁用 Windows 的快速启动**，否则可能会无法访问 Windows 系统所在的分区。控制面板->硬件和声音->电源选项，点击`更改当前不可用的设置`，然后取消勾选`启用快速启动`，保存修改。

### 启动到 Live 环境

1. U 盘插在电脑上，在键盘亮起/屏幕微亮/快要显示出品牌图标时，（如果你之前没有关闭过 secure boot，请按 F2 进入 BIOS 设置界面，将 secure boot 禁用再来进行这一步）按 F12（有些电脑是 F10，建议自己查一下）进入启动顺序选择界面，然后选择你的 USB。
2. 当 Arch 菜单出现时，选择 _Arch Linux install medium (x86_64, UEFI)_ 并按 Enter 进入安装环境。
3. 等几分钟后就会以 root 身份登录进一个显示`root@archiso ~ # `字样的虚拟控制台

### 验证启动模式

用下列命令列出 efivars 目录：

```bash
ls -d /sys/firmware/efi/efivars
```

如果显示 `/sys/firmware/efi/efivars`，则说明系统以 UEFI 模式启动。如果提示 `ls: cannot access '/sys/firmware/efi/efivars': No such file or directory`，则说明系统可能以 BIOS 或 CSM 模式启动，自己百度怎么改为 UEFI 吧

### 连接到因特网

- 如果是有线网络
  - 直接 `ping baidu.com -c 4` 来判断网络是否连接正常。
- 如果是无线网络
  - 执行以下命令（详见[iwctl - ArchWiki](<https://wiki.archlinux.org/index.php/Iwd_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#iwctl>)）
    ```bash
    # 进入交互式提示符环境
    iwctl
    # 接下来是在以 [iwd] 开头的提示符环境中进行的
    # 列出所有 WiFi 设备
    device list
    # 假设刚才的 Name 一列的网络设备名称为 wlan0，接下来扫描网络
    station wlan0 scan
    # 列出所有可用的网络
    station wlan0 get-networks
    # 假设想要连到 Network name 一列中，名称为 Xiaomi 的网络
    station wlan0 connect Xiaomi
    # 然后按照提示输入密码即可
    # ctlrl d 退出
    ```

### 更新系统时间

```bash
# 启用 NTP 时间同步
timedatectl set-ntp true
# 查看 NTP 服务状态
timedatectl timesync-status
```

### 建立硬盘分区

每个硬盘都被会被分配为一个块设备，如 `/dev/sda`、`/dev/sdb`、`/dev/sdc`、`/dev/nvme0n1`。可以使用 fdisk 查看：

```bash
fdisk -l
```

如果想在硬盘 `/dev/sda` 上进行分区，则运行：

```bash
cfdisk /dev/sda
```

按上下键选择想要操作的分区，移动到绿色的空闲分区。然后按左右键选择所要进行的操作，选择 `[ New ]`，然后回车，输入想要分配的大小，然后再确认，再按左右键选择 `[ Type ]`，然后回车，来设置该分区的类型。

以我的分区为例（没弄 swap，而是使用性能更好的 zram，后面会提到）：

|  挂载点   | 假设的设备文件 |      分区类型       |      大小      |
| :-------: | :------------: | :-----------------: | :------------: |
| /mnt/boot |   /dev/sda1    |     EFI System      | 500M（足够了） |
|   /mnt    |   /dev/sda2    | Linux root (x86-64) |                |

也有人将`/mnt/boot`换成`/mnt/efi`或`/mnt/boot/efi`，其实这个随意，不过最好还是`/mnt/boot`。分完后，按左右键选择`[ Write ]`回车，再 yes，使修改生效，再按 q 退出 cfdisk 界面。

注意：EFI 分区别开启 `NoBlockIOProtocol` 标志，如果有那么 UEFI 固件会忽略该分区。可以通过 `fdisk /dev/sda`（`m` 显示菜单）然后按 `x` 进入专家模式，再按 `B` 并选择分区号，来开启/关闭该标志，记得按 `r` 返回主菜单，按 `w` 保存更改并退出。

### 格式化分区

这里的 `/dev/sda1` 等等请换成你自己的

```bash
# 将 EFI System 分区格式化为 fat32（UEFI 标准规定了只支持 fatfs）
mkfs.fat -F32 /dev/sda1
# 格式化为 btrfs
mkfs.btrfs -L btrfs-arch /dev/sda2
```

### 挂载分区

- [Btrfs (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Btrfs_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [mkfs.btrfs(8)](https://man.archlinux.org/man/mkfs.btrfs.8)
- [btrfs(5)](https://man.archlinux.org/man/btrfs.5) 关于 BTRFS 文件系统的主题(挂载选项、支持的文件属性等)
- [btrfs.wiki](https://btrfs.wiki.kernel.org/index.php/SysadminGuide)
- [compress 参数 benchmark](https://docs.google.com/spreadsheets/d/1x9-3OQF4ev1fOCrYuYWt1QmxYRmPilw_nLik5H_2_qA/edit#gid=0)

btrfs 的一些挂载选项：

- `autodefrag, noautodefrag`。自动碎片整理，默认关闭
- `compress, compress=type[:level], compress-force, compress-force=type[:level]`控制 BTRFS 文件数据压缩。Type 可以指定为 zlib、lzo、zstd 或 no，默认 zlib
- `discard, discard=sync, discard=async, nodiscard` 启用丢弃已释放的文件块。这对于 SSD 设备、精简配给的 LUNs 或虚拟机映像很有用；然而，每个存储层必须支持 discard 才能工作。注意内核 5.6 以后才支持 async。默认关闭，如果启用，建议 async
- `ssd, ssd_spread, nossd, nossd_spread` 控制 SSD 分配方案的选项。默认情况下，BTRFS 将启用或禁用 SSD 优化，这取决于设备的旋转或非旋转类型的状态。默认会自动检测 SSD。
- 通用挂载选项 `noatime` 在读取密集的工作负载下，指定 noatime 可以显著提高性能，因为不需要写入新的访问时间信息。如果没有这个选项，默认值是 relatime，与传统的 strictatime 相比，它只减少了 inode atime 更新的数量。另外，noatime 已经包含了 nodiratime。不需要同时指定。

```sh
# 先挂载该分区
mount -o compress=zstd /dev/sda2 /mnt
# 然后在该分区中创建子卷（同时也会在该文件系统创建 @ 和 @home 这两个目录）
btrfs subvolume create /mnt/@      # 创建子卷 @
btrfs subvolume create /mnt/@home  # 创建子卷 @home
# 卸载
umount /mnt

# 将 btrfs 分区的 @ 子卷挂载到 /mnt
mount -o noatime,compress=zstd,subvol=@     /dev/sda2 /mnt
# 将 btrfs 分区的 @home 子卷挂载到 /mnt/home
mkdir /mnt/home
mount -o noatime,compress=zstd,subvol=@home /dev/sda2 /mnt/home
```

```bash
# 挂载 EFI System 分区
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

## 安装

### 更换镜像源

```bash
# 修改软件源
echo 'Server = https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
# 也可使用 reflector 获取国内的 https 软件源，并且按下载速度进行排序，并保存到 /etc/pacman.d/mirrorlist 中
# reflector -c China > /etc/pacman.d/mirrorlist
# 更新软件包数据库
pacman -Syy
```

其他镜像源请见通过 [Pacman Mirrorlist 生成器](https://www.archlinux.org/mirrorlist/)生成的[国内源列表](https://www.archlinux.org/mirrorlist/?country=CN&protocol=http&protocol=https&ip_version=4)，用自己学校的更快哦！

### 安装必须的软件包

使用 pacstrap 脚本，安装 base 软件包和 Linux 内核以及常规硬件的固件等等：

```bash
# 安装基本的软件。注意：一定要在 linux 软件包安装之间先把 base 软件包安装好，原因后面会讲
pacstrap /mnt --needed base base-devel
# 安装 Linux 内核以及常规硬件的固件
pacstrap /mnt --needed linux linux-firmware
# 安装编辑器、网络管理器（若不安装后面就会有连不上网络的麻烦）、一些有用的脚本、btrfs 工具
pacstrap /mnt --needed neovim networkmanager arch-install-scripts btrfs-progs
```

## 配置系统

### Fstab

用以下命令生成 fstab 文件 (`-U` 或 `-L` 选项使用 UUID 或卷标)：

```bash
# 检查一下生成的 fstab 是否正确
genfstab -L /mnt
# 如果正确就将其追加进 /mnt/etc/fstab
# 注：建议 EFI 分区使用 UUID，因为有时候加装新硬盘可能会导致块设备名发生变化
genfstab -L /mnt >> /mnt/etc/fstab
```

### Chroot

切换到我们新安装的系统，执行了这步以后，我们的操作都相当于在硬盘上新装的系统中进行

```bash
arch-chroot /mnt
```

### 时区

```bash
# 设置时区为上海
timedatectl set-timezone Asia/Shanghai
# 查看时间
date -R
# 将硬件时钟（RTC）调整为与目前的系统时钟一致
hwclock --systohc
```

### 本地化

```bash
# 先弄个软链接
ln -s /usr/bin/nvim /usr/bin/vim
ln -s /usr/bin/nvim /usr/bin/vi

# 编辑/etc/locale.gen，将 en_US.UTF-8 UTF-8 和 zh_CN.UTF-8 UTF-8 取消注释
vim /etc/locale.gen
# 生成 locale 信息
locale-gen
# 创建 locale.conf 文件，并编辑设定 LANG 变量，不建议弄成中文的，会导致 tty 乱码
# 这步千万别写错！（这个设置会影响到 ~/.config/plasma-localerc 的内容）
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
```

### 设置计算机名

注意：这里的 myhostname 换成你自己想要设置的主机名

```bash
echo 'myhostname' > /etc/hostname
# 然后编辑 /etc/hosts
vim /etc/hosts
```

填入如下内容以配置本地主机名的解析：

```
127.0.0.1  localhost
::1        localhost
127.0.1.1  myhostname.localdomain  myhostname
```

### Initramfs

- [mkinitcpio (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Mkinitcpio_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

在前面执行 `pacstrap /mnt --needed linux` 命令安装 `linux` 软件包时，pacman 会运行一些 hooks，其中就包括 `/usr/share/libalpm/hooks/90-mkinitcpio-install.hook`，它会执行 `/usr/share/libalpm/scripts/mkinitcpio install` 命令，生成 `/etc/mkinitcpio.d/linux.preset` 文件，并且生成两个 initial ramdisk images：

```bash
❯ ls /boot/initramfs*
/boot/initramfs-linux-fallback.img  /boot/initramfs-linux.img
```

如果没有这两个文件，则说明 hooks 没成功运行。原因可能是安装 linux 软件包之前没有安装 base 软件包，缺少了 sed 命令，导致运行 hook 时，其中的一条命令 `sed "s|%PKGBASE%|linux|g" /usr/share/mkinitcpio/hook.preset > /etc/mkinitcpio.d/linux.preset` 没有运行。我们运行该命令，就可以生成缺失的 `/etc/mkinitcpio.d/linux.preset` 文件了。
然后运行 `mkinitcpio -p linux` 以生成 initial ramdisk images。

注：fallback 的一般都用不到，所以我修改了 `/etc/mkinitcpio.d/linux.preset`，改成了 `PRESETS=('default')`，只生成 `/boot/initramfs-linux.img`

### 设置 Root 密码

```bash
passwd
```

### 安装引导程序

- [安装引导程序 - ArchWiki](<https://wiki.archlinux.org/index.php/Installation_guide_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E5%AE%89%E8%A3%85%E5%BC%95%E5%AF%BC%E7%A8%8B%E5%BA%8F>)
- [GRUB (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/GRUB_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

内核可以通过更新启动时的 _Microcode_，即[微码](<https://wiki.archlinux.org/index.php/Microcode_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)，来修正处理器的[错误行为](https://www.anandtech.com/show/8376/intel-disables-tsx-instructions-erratum-found-in-haswell-haswelleep-broadwelly)。

- 如果是 AMD CPU，需先 `pacman -S amd-ucode`
- 如果是 Intel CPU，则 `pacman -S intel-ucode`

接下来安装 GRUB 引导程序

```bash
# 安装 grub 及可选依赖
pacman -S --needed grub efibootmgr os-prober
# 部署 grub
# 生成 /boot/EFI/ArchLinux/grubx64.efi 并将其加入引导条目
# --target=x86_64-efi 可以省略，因为这是默认值
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux
# 生成 /boot/EFI/BOOT/BOOTX64.EFI 并将其加入引导条目
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux --removable
# 查看引导条目及顺序
efibootmgr -v
# 更改引导顺序
# efibootmgr --bootorder 序号,序号,...
```

`vim /etc/default/grub`，按需修改以下几个选项：

```conf
# 使用记住的启动项为默认启动项
GRUB_DEFAULT=saved
# 启动时打印更多 log
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=5"
# 使 GRUB 记住最近一次使用的启动项
GRUB_SAVEDEFAULT=true
# 支持检测同一 ESP 内其他系统的引导，比如 Windows
GRUB_DISABLE_OS_PROBER=false
```

最后 `sudo grub-mkconfig -o /boot/grub/grub.cfg` 更新配置文件，如果是双系统，输出中应该有 `Found Windows Boot Manager ...` 字样。

注意：

- 如果在安装 ArchLinux 之后再安装 Windows，Windows 会和 ArchLinux 共用一个 EFI 分区，Windows 的引导为 `esp/EFI/Microsoft/Boot/bootmgfw.efi`。Windows 大版本更新时可能会破坏 ArchLinux 的 grub，建议更新 Windows 之前备份好 grub 或者准备一个启动盘用来修复。
- 如果 `grub-install` 使用 `--removable` 选项，那 GRUB 还将被安装到 `esp/EFI/BOOT/BOOTX64.EFI`（一个 default/fallback boot path），此时即使 EFI 变量被重设或者你把这个硬盘接到其他电脑上，这个启动项仍不会被丢失。（所以建议为每个系统都建一个 esp 分区，并且都使用 `--removable` 选项，这样将硬盘装到新电脑上后就不会丢失引导了）

### 重启进入安装好了的 Arch Linux

```bash
# 退出我们安装好了的系统，回到 U 盘里的 Live 环境
exit
# 重启
reboot
```

屏幕微亮时按 F8/F10/F12（不同的主板可能不同）进入启动顺序选择界面，然后选择 ArchLinux（也可按 F2 进入 BIOS 设置界面，将 ArchLinux 调到第一位）

输入用户名 root，回车，再输入密码，即可完成登录！

## 安装后的工作

**这一部分主要参考 [General recommendations (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/General_recommendations_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)**

### 联网

- [Network configuration (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Network_configuration_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [NetworkManager 自带的 nmcli 使用示例 - ArchWiki](<https://wiki.archlinux.org/index.php/NetworkManager_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#nmcli_%E4%BD%BF%E7%94%A8%E7%A4%BA%E4%BE%8B>)

```sh
# 设置 DNS server
echo 'nameserver 223.5.5.5' > /etc/resolv.conf
# 给该文件设置写保护，防止将来被 NetworkManager 修改
chattr +i /etc/resolv.conf
# 如果之后想修改该文件，需先 chattr -i /etc/resolv.conf 去除写保护
```

然后启用 NetworkManager.service systemd 服务，并用其自带的 nmcli 联网。

```sh
# 首先需要启动 NetworkManager 守护进程
systemctl enable --now NetworkManager
# 显示附近的 wifi
nmcli device wifi list
# 连接 WIFI，此处假设要连接的 WIFI 的名称(SSID) 为 MY_WIFI，密码为 MY_PASSWD
nmcli device wifi connect MY_WIFI password MY_PASSWD
# 测试
ping baidu.com -c 4
```

### 添加 archlinuxcn 源

- [Arch Linux 中文社区](https://www.archlinuxcn.org/)
- [archlinuxcn 软件源列表](https://github.com/archlinuxcn/mirrorlist-repo)

```sh
vim /etc/pacman.conf
```

- 取消 `#Color` 的注释以启用彩色输出
- `ParallelDownloads = 8` 启用并行下载
- 取消 `[multilib]` 两行的注释以启用 multilib 库。（我平时用不到 32 位的程序，就没开）
- 然后加 archlinuxcn 源，在文件末尾加上以下内容：
  ```conf
  [archlinuxcn]
  Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch
  Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
  ```

```bash
# 给一些文件添加写保护，防止文件被其他程序修改
chattr +i /etc/pacman.d/mirrorlist

pacman -Syy archlinuxcn-keyring     # 强制更新软件包数据库，并安装 archlinuxcn 的 keyring
```

### 新建用户

- [Users and groups (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Users_and_groups_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

注意：username 请换成你自己的用户名

```bash
# 新建用户。-m 为用户创建家目录；-G wheel 将用户添加到 wheel 用户组
# -s 设置启动命令
useradd -m -G wheel -s /bin/zsh username
# 设置密码
passwd username
```

运行命令 `EDITOR=vim visudo` 修改 `/etc/sudoers`，将以下两行行首的`# `去掉。作用分别是给 wheel 用户组的用户添加 sudo 命令权限并且 sudo 时无需输入密码。

```bash
# %wheel ALL=(ALL) ALL
# %wheel ALL=(ALL) NOPASSWD: ALL
```

### 图形界面

#### 显示服务 (Display Server)

- [Xorg - ArchWiki](https://wiki.archlinux.org/title/Xorg)
- [Wayland - ArchWiki](https://wiki.archlinux.org/title/Wayland#Compositors)

display server 通过 display server protocol 和 client (application) 进行通信（发送鼠标移动、点击等输入事件）

有两种常用的 display server protocol：

- X Window System(X11)。X Window System 是基于网络的 display server protocol，提供了窗口功能，包含建立图形用户界面(GUI)的标准工具和协议。Xorg 是一个使用了 X11 protocol 的 display server 实现。
  ```bash
  # 只安装 xorg-server 即可
  # 可选：xorg 软件包组，包含 xorg-server，以及 xorg-apps xorg-fonts 组中的软件包
  pacman -S --needed xorg-server
  ```
- （**推荐**）Wayland 是一个新的 display server protocol。使用 Wayland protocol 的 display server 叫做 compositors（因为它们还充当 compositing window managers），支持 Wayland protocol 的 compositors 见 [Wayland#Compositors](https://wiki.archlinux.org/title/Wayland#Compositors)。Xwayland 则提供了一个兼容层，以无缝运行原生 X11 应用程序。
  compositing window managers 会在后面安装桌面环境时被安装好。

### 显示驱动（Display drivers）

- [Xorg#Driver_installation - ArchWiki](https://wiki.archlinux.org/title/Xorg#Driver_installation)
- [archlinux 显卡驱动 | archlinux 简明指南](https://arch.icekylin.online/guide/rookie/graphic-driver.html)

先使用 `lspci | grep -e VGA -e 3D` 命令以查看显卡类型。

- NVIDIA
  ```bash
  # 这个是闭源的
  # 开源的是 nvidia-open https://github.com/NVIDIA/open-gpu-kernel-modules 不怎么稳定
  pacman -S nvidia
  pacman -S nvidia-settings lib32-nvidia-utils
  ```
  注：nvidia-utils 软件包里的 `/usr/lib/modprobe.d/nvidia-utils.conf` 禁用了 nouveau。
  另外请编辑 `/etc/mkinitcpio.conf`，在 HOOKS 一行删除 `kms` 并保存，然后执行 `mkinitcpio -P` 重新生成一次镜像。这能防止 initramfs 包含 nouveau 模块，避免 在 early boot 时 nouveau 和官方驱动的冲突。（如果没安装 xf86-video-nouveau，那可以略过这一步）
- Intel
  不建议安装 `xf86-video-intel`，Xorg 会 fall back 到 kernel mode setting 驱动
  ```bash
  pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel
  ```
- 如果是较旧的 AMD 显卡（GPU 架构为 GCN2 及之前的，详见<https://wiki.archlinux.org/index.php/Xorg#AMD>）：
  ```sh
  pacman -S mesa lib32-mesa xf86-video-ati
  ```
  如果是较新的 AMD 显卡，我用的是 APU 4750G，GPU 代号为 Renoir，根据<https://en.wikipedia.org/wiki/Radeon_RX_Vega_series#Renoir_(2020)>可知为 Vega 8 架构，为 GCN5，故：
  ```sh
  pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
  ```

mesa 是 OpenGL 驱动，vulkan 是 OpenGL 的继承者。

其他
虽然 xf86-input-synaptics 已经不再更新了，但是一些旧笔记本的触控板还是需要这个包的

#### 桌面环境（Desktop Environment，DE）+ 窗口管理器（Window Manager, WM）

- [Desktop environment (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Desktop_environment_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [Window manager (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Window_manager_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [Compare Packages](https://pkgstats.archlinux.de/compare/packages#packages=cinnamon,gnome-shell,lxde-common,mate-panel,plasma-workspace,xfdesktop)
  ArchLinux 各种桌面环境使用率对比，KDE Plasma > Gnome > Xfce4

Xorg 只提供图形环境的基本框架，桌面环境则在 Xorg 之上并与其共同运作，通过汇集使用相同组件库的程序，为用户提供完全的图形用户界面。

桌面环境将各种组件捆绑在一起，以提供常见的图形用户界面元素，如图标、工具栏、壁纸和桌面小部件。此外，大多数桌面环境包括一套集成的应用程序和实用程序。最重要的是，桌面环境提供了他们自己的窗口管理器，然而通常可以用另一个兼容的窗口管理器来代替。

窗口管理器（WM）是一种系统软件，在图形用户界面（GUI）中的窗口系统中控制窗口的位置和外观。它可以是桌面环境（DE）的一部分，也可以独立使用。
注意：窗口管理器是 Xorg 独有的。Wayland 上窗口管理器的等价物称为混成器，因为它们也充当混成窗口管理器。

这里只介绍两种桌面环境，根据需要选一个即可。

- KDE（我觉得这个最好看也最好用），使用 KWin 作为窗口管理器/混成器
  ```sh
  # 安装 plasma 桌面环境
  # 建议安装元软件包 plasma-meta 而非软件包组 plasma
  # 若要使用 Plasma 的最小安装，只安装 plasma-desktop 包即可
  pacman -S --needed plasma-meta
  # 可选：软件包组 kde-applications，但是包含一大堆没用的软件包组，比如：
  # kde-pim kde-accessibility kde-education telepathy-kde
  # 另外，若要在 plasma 中支持 wayland，还须安装 plasma-wayland-session
  pacamn -S --needed plasma-wayland-session
  ```
- Xfce（轻量稳定，实测内存占用只有 600M 左右，适合性能一般，内存较小的机器）。Xfce 默认使用 Xfwm 作为窗口管理器（Window Manager，WM）。
  ```sh
  pacman -S --needed xfce4 xfce4-goodies
  # 由于 xfce 桌面环境并不自带网络管理器托盘组件，所以安装这个
  pacman -S --needed network-manager-applet
  ```

#### 显示管理器（Display manager）

- [Display manager (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Display_manager_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

许多桌面环境提供了显示管理器**来自动启动图形界面（可选择 X11 和 Wayland）和管理用户登录**。当然也可以不使用显示管理器，而是使用 [xinit](<https://wiki.archlinux.org/index.php/Xinit_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E5%9C%A8%E7%99%BB%E5%BD%95%E6%97%B6%E8%87%AA%E5%8A%A8%E5%90%AF%E7%94%A8_X>) 直接从 tty 启动图形界面。

- 如果你选择了 KDE 桌面环境，推荐使用 SDDM
  ```sh
  pacman -S --needed sddm-git
  # 启用 sddm.service，这样每次开机都会启动 sddm
  # --now 选项表示立即启动 sddm
  systemctl enable --now sddm
  ```
  在 sddm 登录进入图形界面后，你可以打开 Yakuake 终端来运行命令。你可能会发现无法使用触控板进行点击，这需要在系统设置->触摸板中进行设置（也有可能是你的笔记本锁住触控板了）。
- 如果你选择了 Xfce 桌面环境，推荐使用 LightDM
  ```sh
  pacman -S --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
  # 启用 lightdm.service，这样每次开机都会启动 lightdm
  # --now 选项表示立即启动 lightdm
  systemctl enable --now lightdm
  ```

### Btrfs 快照

- [Snapper (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Snapper_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [用 snapper 轻松玩转 Btrfs 的快照功能 - 「已注销」的文章 - 知乎](https://zhuanlan.zhihu.com/p/31082518)

在 Btrfs 中，snapper 是以子卷为单位管理快照的。我们要先为子卷建立配置文件才能管理快照。

```sh
# 安装 snapper
sudo pacman -S snapper

# 创建 snapper 配置文件
# snapper -c <配置名称> create-config <子卷路径>
sudo snapper -c root create-config /
sudo snapper -c home create-config /home

# 其他用法
# 删除配置文件
sudo snapper -c <配置名称> delete-config
# 列出现有配置文件
snapper list-configs
```

一个快照时间线(timeline)由可配置数目的每小时/日/月/年快照组成。当自动按时创建启用时，默认每小时创建一个快照。每天由时间线清理算法清理多余快照。

默认配置将保留 10 个每小时快照，10 个每日快照，10 个每月快照和 10 个每年快照。你可以在配置文件 `/etc/snapper/configs/<配置名称>` 中更改这些限制，特别是在繁忙的子卷，例如 `/` 上。

```sh
# 启用自动按时创建快照
sudo systemctl enable --now snapper-timeline.timer
# 启用定期清理老旧快照
sudo systemctl enable --now snapper-cleanup.timer
```

其他的操作，比如更改创建和清理频率、手动创建快照等详见 ArchWiki。

### zram

- [zram or zswap - ArchWiki](https://wiki.archlinux.org/title/improving_performance#zram_or_zswap)

zram-generator 是一个用 Rust 写的 systemd unit generator for zram devices。

```bash
sudo pacman -S zram-generator
```

`sudo vim /etc/systemd/zram-generator.conf` 填入如下内容：

```toml
# https://github.com/systemd/zram-generator
# https://man.archlinux.org/man/zram-generator.conf.5
[zram0]
```

```bash
# 启用 zram
# create new device units
❯ sudo systemctl daemon-reload
❯ sudo systemctl start /dev/zram0
❯ free -h

# 接下来启用 swapfile
❯ touch /swapfile
# 如果在 btrfs 上则需要禁用该文件的 CoW
❯ chattr +C /swapfile
❯ lsattr /swapfile
❯ dd if=/dev/zero of=/swapfile bs=1G count=8 status=progress
# 优先级为 0（低）
❯ chmod 600 /swapfile && mkswap /swapfile && swapon -p 0 /swapfile
# 查看交换分区
❯ swapon -s
Filename      Type        Size        Used    Priority
/dev/zram0    partition   4194300     0       100
/swapfile     file        8388604     0       0

# 然后再修改一下 /etc/fstab
❯ vim /etc/fstab
把如下内容放进文件末尾
/swapfile   none    swap    defaults,pri=0  0 0
```

### 字体

- [Fonts (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [修正简体中文显示为异体（日文）字形 - ArchWiki](<https://wiki.archlinux.org/index.php/Localization_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)/Simplified_Chinese_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E4%BF%AE%E6%AD%A3%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87%E6%98%BE%E7%A4%BA%E4%B8%BA%E5%BC%82%E4%BD%93%EF%BC%88%E6%97%A5%E6%96%87%EF%BC%89%E5%AD%97%E5%BD%A2>)

```bash
# 安装 noto-fonts
pacman -S --needed noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
# 更纱黑体
pacman -S ttf-sarasa-gothic
```

然后打开 System Settings->Regional Settings->Language，点击 `Add languages`，添加简体中文，并将其移至第一个，`Apply` 使其生效，然后再 Log out（注销）重新登录，就会是中文图形界面了。

接下来修正简体中文显示为异体（日文）字形的问题，`vim ~/.fonts.conf`，写入如下内容：

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <!-- 无衬线字体 -->
    <family>sans-serif</family>
    <prefer>
      <family>Noto Sans</family>
      <family>Noto Sans CJK SC</family>
      <family>Noto Sans CJK TC</family>
      <family>Noto Sans CJK JP</family>
    </prefer>
  </alias>
</fontconfig>
```

然后：

```bash
# 更新字体缓存即可生效
fc-cache -fv
# 执行以下命令检查，如果出现 NotoSansCJK-Regular.ttc: "Noto Sans CJK SC" "Regular" 则表示设置成功
fc-match sans-serif
# 查看安装了的中文字体
fc-list :lang=zh
```

如果要设置等宽字体为更纱黑体，那就在`<fontconfig>`标签内再加上：

```xml
  <alias>
    <!-- 等宽字体 -->
    <family>monospace</family>
    <prefer>
      <family>Sarasa Mono SC</family>
    </prefer>
  </alias>
```

其他：serif 是衬线字体

#### 微软字体

- [Microsoft fonts - ArchWiki](https://wiki.archlinux.org/title/Microsoft_fonts)
- [ttf-ms-win11 - AUR](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=ttf-ms-win11)

微软的字体，比如微软雅黑：`msyh.ttc msyhbd.ttc msyhl.ttc`。软件包 `ttf-ms-fonts` 提供的字体已经过时，显示效果奇差，别用。建议直接从 win10 或者 ISO 安装介质中复制字体文件（由于版权原因不会提供构建好的软件包），然后刷新字体缓存。

例如，Windows 的 `C:\` 盘被挂载在 `/path-to-windows`：

```bash
sudo mkdir /usr/share/fonts/WindowsFonts
sudo cp /path-to-windows/Windows/Fonts/* /usr/share/fonts/WindowsFonts
sudo chmod 644 /usr/share/fonts/WindowsFonts/*
# 重新生成字体缓存
fc-cache -f
```

或者是安装 aur 包 `ttf-ms-win11`，安装方法详见[其 PKGBUILD 文件顶部的注释](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=ttf-ms-win11)。如果嫌麻烦，可以安装第三方已经构建好的（有安全风险）：

```bash
# https://pkgs.org/download/ttf-ms-win10
# 按照描述添加第三方的软件包仓库：https://dx37.gitlab.io/dx37essentials/
# 安装
sudo pacman -Syy
# 别安装 japanese,korean,zh_tw 的，在某些网站上会有异体字的问题（需要修改 ~/.fonts.conf）
sudo pacman -S --needed ttf-ms-win10 ttf-ms-win10-zh_cn
```

### 输入法

见 [fcitx5.md](./fcitx5.md)

### 代理

- [ArchWiki 推荐的代理软件](<https://wiki.archlinux.org/title/General_recommendations_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E4%BB%A3%E7%90%86>)

Qv2ray 因为一些原因已经停止维护了。
可以尝试 v2rayA(~~v2ray for Arch~~)，它支持使用 RoutingA 书写路由规则。[v2rayA 的配置](./v2raya.md)。
更推荐 clash verge

### AUR - Arch 用户软件源

- [AUR helpers (简体中文) - ArchWiki](<https://wiki.archlinux.org/title/AUR_helpers_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

paru 是一个用 Rust 写的 AUR helper，同时还是对 pacman 的包装，会调用 `sudo pacman ...` 来安装软件包，用法与 pacman 相似并且提供了一些更好用的功能，平时我都是使用 paru 而非 pacman

```sh
# 注：请确保已经添加 archlinuxcn 软件源，否则会找不到 paru 这个软件包
sudo pacman -S paru
```

### 常用软件

软件安利环节（

- [常用软件 | archlinux 简明指南](https://arch.icekylin.online/app/common/daily.html)

只列出包名，注意有些是在 aur 里的

```bash
# Ark 压缩文件管理工具，以及 7Z 和 RAR 格式支持
# unarchiver 提供的 unar 命令解压 Windows 下的压缩包时会自动检测编码，支持 rar zip 等绝大多数格式
paru --needed ark p7zip unarchiver
# zip 命令行解压工具
unzip

wget
# df 的替代品。用于查看磁盘空间占用情况
dust
# 文件管理器
dolphin
# 图形化界面直观查看磁盘占用情况
filelight
# 两个终端模拟器
yakuake alacritty
# pdf 及电子书阅读器，带批注编辑功能
okular
# firefox 或 edge 浏览器
firefox
microsoft-edge-stable-bin

# Smartmontools 通过使用自我监控（Self-Monitoring）、分析（Analysis）和报告（Reporting）三种技术（SMART）来管理和监控存储硬件。
# sudo smartctl -a /dev/nvme0n1 查看磁盘的所有 SMART 信息
smartmontools
# cpu gpu 信息，温度，性能测试
cpu-x
# 查看系统绝大部分硬件信息
dmidecode
# 图形界面磁盘分区工具
gparted

# 截图工具， spectacle 启动有些慢，推荐 flameshot
# 在 wayland 下 flameshot 需要 xdg-desktop-portal
# 建议给 flameshot gui 命令弄个快捷键
flameshot xdg-desktop-portal
# spectacle 还有录屏功能
spectacle

# 聊天工具
# Telegram，简体中文语言包：https://t.me/setlanguage/zhcncc
paru --needed telegram-desktop
# linuxqq
# 聊天记录保存在 ~/.config/QQ/ 文件默认保存在 ~/Downloads
# 如果闪退，安装回 2:3.0.0_571-1 版本
# 或者 rm -rf ~/.config/QQ/crash_files && ln -sf /dev/null ~/.config/QQ/crash_files
paru -S linuxqq

# 百度网盘 网抑云 钉钉 xmind
paru --needed baidunetdisk-bin netease-cloud-music-gtk dingtalk-electron xmind-2020

# 一个稳定、用户友好以及高度可定制的音乐播放器 https://github.com/feeluown/FeelUOwn
paru --needed feeluown feeluown-qqmusic feeluown-netease
# 可以搜索和播放来自网易云音乐，QQ音乐，酷狗音乐，酷我音乐，Bilibili，咪咕音乐网站的歌曲
# listen1 也不错 http://listen1.github.io/listen1/

# WPS 以及其部分可选依赖
paru --needed wps-office-cn wps-office-mime-cn wps-office-mui-zh-cn
# 安装 WPS 需要的字体，字体缺失可能会导致 WPS 卡顿
paru --needed ttf-wps-fonts wps-office-fonts

# 也可以选择 LibreOffice 稳定版
paru --needed libreoffice-still libreoffice-still-zh-cn

# vscode
paru --needed visual-studio-code-bin

# 杂项
paru --needed  pacman-contrib downgrade
# 一些命令行工具
paru --needed neofetch exa bat lolcat fd tokei zenith-bin

# 如果终端程序不支持 http_proxy 等环境变量，就用这个
# 缺点：对 go 程序无效
proxychains-ng

# TODO 这部分删掉
# 安装基于 Deepin wine6 版的 QQ
# 遇到了问题去这里看看：https://github.com/countstarlight/deepin-wine-qq-arch/issues?q=
paru --needed deepin-wine-qq
# 进入 deepin-wine5 的设置界面，将 DPI 改为 120
WINEPREFIX=~/.deepinwine/Deepin-QQ deepin-wine5 winecfg
# simsun 字体问题：https://blog.zhullyb.top/2021/04/27/hide-simsun-from-deepin-wine-tim/
# 我试了但是 doesn't work，最后直接把 simsun 删掉解决了问题。
# deepin-wine6-stable 还有不少问题，比如不能记住密码，可以暂时使用 deepin-wine5
paru --needed deepin-wine5
# 将 run.sh 文件中的 deepin-wine6-stable 修改为 deepin-wine5
vim /opt/apps/com.qq.office.deepin/files/run.sh
# 删除原先安装的 QQ，用户数据在 ~/Documents/Tencent Files 里不会被删除
rm -rf ~/.deepinwine/Deepin-QQ

# 坚果云。如果打开的界面不能调整大小，按一下回车就好。如果实在用不了就手动安装官网的
# https://www.jianguoyun.com/s/downloads/linux#install_for_kdexfce
paru --needed nutstore

# 用来制作启动盘的 ventoy
# 使用方法：在未挂载U盘的情况下，sudo ventoygui 或 sudo ventoyweb
paru ventoy-bin

# 文字识别（需要配置好接口参数）
paru fastocr
```

### zsh

见 [hyuuko/dotfiles](https://github.com/hyuuko/dotfiles)

### 开发环境

见 [development.md](./development.md)

### 美化

见 [美化.md](./美化.md)

## 其他

### kwallet

见 [kwallet](./kwallet.md)

### 调整鼠标滚轮速度

系统设置里只能调整鼠标滚轮的全局速度。如果要针对某个应用程序，就需要使用 imwheel。

```bash
sudo pacman -S imwheel
nvim ~/.imwheelrc
```

写入如下内容并保存：

```bash
# https://wiki.archlinux.org/title/IMWheel
# imwheel -df 在终端输出并且根据鼠标位置来选定窗口（而非 focus 的窗口）
# imwheel -df --debug --kill | grep name 用来调试，滚动时会输出 name

# 只对 microsoft-edge 和 google-chrome 生效
"^(microsoft-edge|google-chrome)"
None,      Up,   Button4, 3
None,      Down, Button5, 3
Control_L, Up,   Control_L|Button4
Control_L, Down, Control_L|Button5
Shift_L,   Up,   Shift_L|Button4
Shift_L,   Down, Shift_L|Button5
```

然后将其作为一个服务来启动，新建文件 `~/.config/systemd/user/imwheel.service`，文件内容如下所示。然后 `systemctl --user enable --now imwheel.service`。

```conf
[Unit]
Description=IMWheel
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=exec
# 睡眠 20 秒是因为 nvidia+wayland 下进入图形界面比较慢
# ExecStartPre=/usr/bin/sleep 20
# 使用 X11 时，-X :0
# 使用 wayland 时，-X :1
ExecStart=/usr/bin/imwheel -df -X :1
ExecStop=/usr/bin/pkill imwheel
RemainAfterExit=yes
# 可以试试不用 -X :1 选项，而是用 DISPLAY 环境变量，我试了没用（
# Environment=DISPLAY=:1

[Install]
WantedBy=graphical-session.target
```

### 显示器亮度

- [How to change LCD brightness from command line (or via script)?](https://askubuntu.com/a/149264)
- [Backlight - ArchWiki](https://wiki.archlinux.org/title/backlight)

晚上关灯后漆黑一片，即使外接显示器的亮度调到最暗，还是会觉得刺眼，这时可以通过 color correction 在软件层面修改亮度。

**对于 Xorg**

```bash
# 调整亮度
brightness() {
    typeset -F b=$1
    (( b >= 0.3 && b <= 1.2 )) &&
        xrandr --output "$(xrandr | grep -w connected | cut -f '1' -d ' ')" --brightness $b ||
        echo 'usage: brightness num, 0.3 <= num <= 1.2'
}
```

`--brightness brightness` 将当前附加到输出的 crtc 上的伽马值乘以指定的浮点值。适用于过亮或过暗的输出。但是，这只是一个软件修改，如果您的硬件支持实际更改亮度，您可能更喜欢使用 xbacklight（只适用于 Intel 和 X11）。

**对于 Wayland**
也许可以试试 colord-kde。
color management protocol 还未完成 [WIP: unstable: add color management protocol (!14) · Merge requests · wayland / wayland-protocols · GitLab](https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/14)

### 更换内核

- [Kernel - ArchWiki](https://wiki.archlinux.org/title/kernel) 除了 linux 之外，还有 linux-lts、linux-zen。
- [Details about linux-zen](https://liquorix.net/)

```sh
# linux-zen 以吞吐量和功耗为代价调整内核以提高响应能力，而且还自带 Anbox 需要的模块
sudo pacman -S linux-zen linux-zen-headers
# stable 版的 linux kernel 可以卸载掉
# sudo pacman -Rns linux linux-headers

# 生成 grub 配置文件（即更新 grub 界面的选择菜单）
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

linux-lts 的内核版本通常落后的比较多，所以需要注意一些事情，比如：

- 5.7 开始才支持 amd 4000 系列的 cpu
- 5.15 开始才原生支持 ntfs3 文件系统，更低版本的内核则需要安装 ntfs-3g 软件包

### 校园网

- [Drcom (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Drcom_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [mchome/dogcom](https://github.com/mchome/dogcom)

学校提供的 linux 版客户端经常掉线，故选择使用 dogcom。

在 windows 上使用学校提供的客户端，在登录前用 wireshark 开始截包，保存文件。接着下载[配置文件生成器](https://raw.githubusercontent.com/drcoms/generic/master/drcom_d_config.py)，将其与第一步的截包文件放到同一个目录下，并且将 `filename = '3.pcapng'` 中的 `3.pcapng` 改为第一步保存的文件名。接着 `python2 drcom_d_config.py > dhcp.conf`。我得到的内容为：

```conf
server = '10.254.7.4'
username='20180000'
password=''
CONTROLCHECKSTATUS = '\x00'
ADAPTERNUM = '\x00'
host_ip = '10.234.115.96'
IPDOG = '\x01'
host_name = 'GILIGILIEYE'
PRIMARY_DNS = '0.0.0.0'
dhcp_server = '0.0.0.0'
AUTH_VERSION = '\x30\x00'
mac = 0x000000000000
host_os = 'NOTE7'
KEEP_ALIVE_VERSION = '\xdc\x02'
ror_version = False
```

需要将 `password` 改为你自己的，并且添加 `keepalive1_mod`：

```conf
server = '10.254.7.4'
username='20180000'
password='114514'
CONTROLCHECKSTATUS = '\x00'
ADAPTERNUM = '\x00'
host_ip = '10.234.115.96'
IPDOG = '\x01'
host_name = 'GILIGILIEYE'
PRIMARY_DNS = '0.0.0.0'
dhcp_server = '0.0.0.0'
AUTH_VERSION = '\x30\x00'
mac = 0x000000000000
host_os = 'NOTE7'
KEEP_ALIVE_VERSION = '\xdc\x02'
ror_version = False
keepalive1_mod = True
```

在 linux 中，先 `paru --needed dogcom-git` 安装 dogcom，然后将 `/etc/dogcom.d/dhcp.conf` 修改成上面的样子，最后启用 dogcom 服务：

```bash
sudo systemctl enable --now dogcom-d
# 查看状态，如果显示 Active: active (running)，则说明成功了
systemctl status dogcom-d
```

## Tips & Tricks

见 [tips_and_tricks.md](./tips_and_tricks.md)

## Dotfiles 管理

- [Dotfiles - ArchWiki](https://wiki.archlinux.org/title/Dotfiles)

## 系统维护

见 [sysadmin.md](./sysadmin.md)

## 常见问题排除与解决

见 [troubleshooting.md](./troubleshooting.md)

## 设备

### 蓝牙

```bash
# 启用蓝牙服务
sudo systemctl enable --now bluetooth
# 如果要连接蓝牙音频设备，需要安装 pulseaudio-bluetooth 并重启 pulseaudio
sudo pacman -S pulseaudio-bluetooth
pulseaudio -k

# XXX 不过更建议直接用 pipewire 取代 pulseaudio，pipewire 自带了蓝牙的模块
# 用 pipewire 替代 pulseaudio（会被自动卸载）
paru -S pipewire pipewire-alsa pipewire-pulse
```

### 鼠标宏

```bash
sudo pacman -S piper
```

然后将前进和后退按钮由默认的 Forward 和 Backward 设置为`Alt + right`（点击配置对话框末尾的 Send keystroke，先按住 Alt，然后按下并松开 Right，最后松开 Alt）和`Alt + left`（chrome 的前进后退快捷键就是这个）

设置 vscode 安装插件 Windows Default Keybindings，并且给 vscode 添加设置以禁用中键的复制行为，这样就可以使用中键选择多行了：

```json
{
  "editor.selectionClipboard": false
}
```
