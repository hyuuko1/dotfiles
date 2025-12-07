# 常见问题排除与解决

## 各种引导丢失情况

我目前遇到过四种引导丢失的情况：

1. 在 Win10 里使用傲梅分区助手移动分区的位置，导致开机按 F12 没有出现 ArchLinux 的选项
2. 把装有双系统的硬盘 A 拆下来，换另一个装了 Win10 硬盘 B，然后开机使用一段时间。再把 B 换下去，把硬盘 A 装回来，开机发现 ArchLinux 的选项没了
3. Win10 大版本更新，开机按 F12 出现了 ArchLinux 的选项，但是会进入 grub rescue 模式
4. 误删 EFI 系统分区中 Windows 的部分

解决方案有：

### 使用 USB 启动盘，进入 Live 环境

可以解决前 3 种情况

```bash
# 查看 root 和 efi 分区是哪两个设备文件
fdisk -l
# 假设根目录为 /dev/sda2
mount /dev/sda2 /mnt
# 切换到硬盘上的 ArchLinux
arch-chroot /mnt
# 挂载 /etc/fstab 中列出的，但还没挂载的设备
mount -a
# 查看 /boot 目录里的 vmlinuz-linux initramfs 等文件有没有丢
ls /boot
# 如果没这些文件，则需要：
# pacman -S linux intel-ucode 或者 amd-ucode

# 部署 grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux
# 生成配置文件
grub-mkconfig -o /boot/grub/grub.cfg
```

### 进入 grub rescue 模式

仅对 第 3 种情况

```bash
# 先查找 Linux 系统引导所在
grub rescue> ls
(hd0) (hd0,gpt8) (hd0,gpt7) (hd0,gpt6) ...
grub rescue> ls (hd0,gpt8)/
./ ../ lost+found/ bin/ boot/ dev/ etc/ ...
# 说明根目录在`(hd0,gpt8)`
grub rescue> set prefix=(hd0,gpt8)/boot/grub
grub rescue> set root=(hd0,gtp8)
# 启动 normal 模块
grub rescue> insmod normal
grub rescue> normal
```

接着就会进入 ArchLinux 了

```bash
# 部署 grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux
# 生成配置文件
grub-mkconfig -o /boot/grub/grub.cfg
```

### 制作 PE

如果有备份就复制过去，如果没有就需要制作一个 PE，用 bcdboot 修复

https://zhuanlan.zhihu.com/p/80926040

## 遇到过的一些小问题

- 有时 KDE 的 Compositor 有窗口一直半透明的 bug，重启 Compositor 就能解决。
  - 按两次 Alt Shift F12，或者：
  - `qdbus org.kde.KWin /Compositor suspend && qdbus org.kde.KWin /Compositor org.kde.kwin.Compositing.resume`
- VSCode 删除（移动进回收站）文件时会卡顿。这是因为 Electron 在检测到 plasma 时会自动使用 kioclient5：`echo 'export ELECTRON_TRASH=gio' >> ~/.xprofile`。注销，重新登录
- 如果挂载的 ntfs 文件系统设备是只读的，无法写入，需要关闭 Win10 的快速启动：控制面板->硬件和声音->电源选项，点击`更改当前不可用的设置`，然后取消勾选`启用快速启动`，保存修改。
- 系统负荷查看器
  - 在表格中鼠标不动停留 2 秒即可显示进程的详细信息
  - 无法显示 CPU 和网络的图表，修复方法：`cp /usr/share/ksysguard/SystemLoad2.sgrd ~/.local/share/ksysguard/`
- 刚安装的软件有时会出现没在应用程序菜单里显示的问题，解决办法：打开系统设置，切换一下图标，然后看看有没有显示出来，再切换回去，来回几次，就有了
- 每次开机后打开 chrome 时都要求输入密码，解决方法：系统设置->KDE 钱包->调用钱包管理器->更改密码，不要输入，直接确认即可。
- 有次将 archlinux 的 EFI 分区格式化了，`initramfs-linux-fallback.img initramfs-linux.img vmlinuz-linux`，这三个文件消失了，这时需要`pacman -S linux`，再来安装 grub 和生成配置文件。windows 可以用 dism++来修复 esp 分区
- linuxqq 扫码登录后闪退。
  - `rm -rf ~/.config/tencent-qq`
  - `sudo vim /usr/share/applications/qq.desktop`，改为 `Exec=/usr/bin/qq %U –no-sandbox`
  - 上面两个方法都没用，垃圾 qq，卸载！
- 进入 sddm 时黑屏
  - `Ctrl+Alt+F2`，登录用户，然后`startx /usr/bin/startplasma-x11`进入 plasma 图形界面，`journalctl -b --unit=sddm`查看 sddm 的日志，发现日志中有这样的错误：`PAM unable to dlopen(/usr/lib/security/pam_tally2.so): /usr/lib/security/pam_tally2.so: cannot open shared object file: No such file or directory`。于是去 google，找到了解决办法：<https://bugs.archlinux.org/task/67347>，将`/etc/pam.d/sddm-autologin`文件中的`auth required pam_tally.so file=/var/log/faillog onerr=succeed`改为`auth required pam_faillock.so`，然后重启
- 窗口变透明，而且窗口关闭后还不消失。KDE Compositor 的 bug，按两次 Alt Shift F12 重启 Compositor
- okular 无法显示中文
  ```bash
  sudo pacman -S poppler-data
  ```
- KDE 分区管理器（partitionmanager）不支持创建 exfat 分区。`sudo pacman -S exfatprogs` 即可（别用基于 fuse 的 exfat-utils）。
- 用 Wayland 时，flameshot 没法截全屏
  写个脚本，内容 `env XDG_SESSION_TYPE=x11 exec flameshot gui`
  快捷键执行这个脚本

### vscode 鼠标右键单击变双击问题

- [Right Click acting abnormal · Issue #113175 · microsoft/vscode · GitHub](https://github.com/microsoft/vscode/issues/113175)
  已知的正常行为：在编辑器内，按下鼠标右键不松开，光标移动到弹出的菜单上，然后松开右键，就会自动点击这个菜单。
  出现的问题，按下鼠标右键迅速松开，也会自动点击这个菜单，原因是鼠标右键按下后光标选择了菜单。

缓解办法：`"window.zoomLevel": 0` 不要更改，保持为默认值。

### r8152 网卡 Tx timeout 错误断网

如果 r8169 驱动不管用，可以试试。

```bash
pacman -S --needed linux-headers
paru -S r8152-dkms

# 用 r8125 驱动，避免用 r8169 驱动
❯ cat /etc/modprobe.d/blacklist-r8169.conf
# To use r8125 driver explicitly
blacklist r8169

❯ lspci -k
08:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller (rev 0c)
        Subsystem: Gigabyte Technology Co., Ltd Device e000
        Kernel driver in use: r8125
        Kernel modules: r8169, r8125
```

这下应该没问题了

## 阿米洛静电容 function keys

- [Keyboard function keys always trigger media shortcuts, regardless of whether Fn is held down](https://unix.stackexchange.com/a/618508)

阿米洛静电容 MA108 键盘在 Linux 下有些问题，无论 Fn 键是否按下，F7-F12 都会触发多媒体功能按键。这是因为在 Linux 下该键盘会激活 hid_apple 驱动程序。

解决办法见 [Apple_Keyboard#Function_keys_do_not_work - ArchWiki](https://wiki.archlinux.org/title/Apple_Keyboard#Function_keys_do_not_work)。

```bash
# 临时生效，测试看看是否有用
echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
# 永久生效，设置 hid_apple 的 fnmode 选项的值为 2
echo 'options hid_apple fnmode=2' | sudo tee /etc/modprobe.d/hid_apple.conf
# 为了应用更改到初始 ramdisk，请确保在 /etc/mkinitcpio.conf 文件里的 HOOKS 变量里有 modconf，或者 FILES 变量里有 /etc/modprobe.d/hid_apple.conf
# 如果没有，则修改，然后 mkinitcpio -p linux 重新生成 initramfs（如果用的是 linux-lts 则是 mkinitcpio -p linux-lts）
```

### 我之前的解决方案（不推荐）

使用 `xev | grep keycode` 获取键码，再[使用 xmodmap 进行重映射](<https://wiki.archlinux.org/index.php/Xmodmap_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

在文件 `~/.Xmodmap` 写入如下内容，然后 `xmodmap ~/.Xmodmap` 生效。

```
keycode 232 = F1 F1 F1 F1 F1 F1 XF86Switch_VT_1
keycode 233 = F2 F2 F2 F2 F2 F2 XF86Switch_VT_2
keycode 128 = F3 F3 F3 F3 F3 F3 XF86Switch_VT_3
keycode 212 = F4 F4 F4 F4 F4 F4 XF86Switch_VT_4
keycode 237 = F5 F5 F5 F5 F5 F5 XF86Switch_VT_5
keycode 238 = F6 F6 F6 F6 F6 F6 XF86Switch_VT_6
keycode 173 = F7 F7 F7 F7 F7 F7 XF86Switch_VT_7
keycode 172 = F8 F8 F8 F8 F8 F8 XF86Switch_VT_8
keycode 171 = F9 F9 F9 F9 F9 F9 XF86Switch_VT_9
keycode 121 = F10 F10 F10 F10 F10 F10 XF86Switch_VT_10
keycode 122 = F11 F11 F11 F11 F11 F11 XF86Switch_VT_11
keycode 123 = F12 F12 F12 F12 F12 F12 XF86Switch_VT_12
```

vscode 需要添加设置

```jsonc
{
  // 如果用了 xmodmap，需要设置这个 https://github.com/microsoft/vscode/issues/23991#issuecomment-292336504
  "keyboard.dispatch": "keyCode"
}
```

## 无法打开 tg 链接

出现错误 `无法创建输入输出后端。klauncher 回应：未知的协议“tg”。`

查看文件 `~/.config/mimeapps.list`，发现两处 `x-scheme-handler/tg=userapp-Telegram Desktop-3D2CC1.desktop`，

解决办法：

1. `rm ~/.local/share/applications/userapp-Telegram\ Desktop-3D2CC1.desktop`
2. 然后修改 `~/.config/mimeapps.list` 将两处都修改为 `x-scheme-handler/tg=telegramdesktop.desktop`

主要原因是 `~/.local/share/applications/userapp-Telegram\ Desktop-3D2CC1.desktop` 里没有 `MimeType=x-scheme-handler/tg;`

## 没有网络

1. `cat /etc/resolv.conf` 先查看是不是 dns 的问题

## 关机时卡住很久才能关机

- [关机时卡住很久才能关机 - ArchLinuxTutorial](https://archlinuxstudio.github.io/ArchLinuxTutorial/#/advanced/troubleshooting?id=%e5%85%b3%e6%9c%ba%e6%97%b6%e5%8d%a1%e4%bd%8f%e5%be%88%e4%b9%85%e6%89%8d%e8%83%bd%e5%85%b3%e6%9c%ba)

```bash
# 修改 DefaultTimeoutStopSec=30s
sudo vim /etc/systemd/system.conf
# 生效
sudo systemctl daemon-reload
```

上述解决方案其实只是将这个等待时间缩小了，并没有解决实际问题。如果你想排查问题真正的原因所在，重启后 `journalctl -p 5 -b -1` 查看上次启动的日志，按 `/` 搜索 `Killing`，查看导致 timeout 的进程。

## WARNING: Possibly missing firmware for module: xhci_pci

- [mkinitcpio 5.4 Possibly missing firmware for module XXXX - ArchWiki](https://wiki.archlinux.org/title/mkinitcpio#Possibly_missing_firmware_for_module_XXXX)

`sudo vim /etc/mkinitcpio.d/linux.preset` 将 `PRESETS=('default' 'fallback')` 修改为 `PRESETS=('default')`。
`sudo rm /boot/*-fallback.img`

```log
==> WARNING: Possibly missing firmware for module: xhci_pci
```

`paru upd72020x-fw`

## 睡眠后立即被唤醒

- [电源管理/挂起与休眠 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/%E7%94%B5%E6%BA%90%E7%AE%A1%E7%90%86/%E6%8C%82%E8%B5%B7%E4%B8%8E%E4%BC%91%E7%9C%A0)
- [电源管理/唤醒触发器 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/%E7%94%B5%E6%BA%90%E7%AE%A1%E7%90%86/%E5%94%A4%E9%86%92%E8%A7%A6%E5%8F%91%E5%99%A8#%E6%8C%82%E8%B5%B7%E5%90%8E%E8%A2%AB%E7%AB%8B%E5%8D%B3%E5%94%A4%E9%86%92) 挂起后被立即唤醒

好像是因为 BIOS 的 bug

```log
archlinux kernel: ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PC00.LPCB.EC0._Q44.WM00], AE_NOT_FOUND (20240322/psargs-330)
archlinux kernel: ACPI Error: Aborting method \_SB.PC00.LPCB.EC0._Q44 due to previous error (AE_NOT_FOUND) (20240322/psparse-529)
```

解决办法：

```bash
# 禁止被 XHC2 这个设备唤醒。重复执行这个命令，就会重新启用。
❯ echo XHC2 > /proc/acpi/wakeup
# 测试下睡眠。睡眠之后要按电源键唤醒。
❯ systemctl suspend
```

如果不管用，就把 /proc/acpi/wakeup 里 Device 那一列的挨个尝试。

以上都是临时生效，要持久生效就写个 service，每次系统启动后都禁用。

```bash
sudo tee /etc/systemd/system/disable-usb-wakeup.service <<EOF
[Unit]
Description=Disable USB wakeup triggers in /proc/acpi/wakeup

[Service]
Type=oneshot
# 第一次 echo 是禁用，第二次 echo 就是启用了
ExecStart=/bin/sh -c "echo XHC0 > /proc/acpi/wakeup; echo XHC1 > /proc/acpi/wakeup; echo XHC2 > /proc/acpi/wakeup; echo XH00 > /proc/acpi/wakeup"
ExecStop=/bin/sh -c "echo XHC0 > /proc/acpi/wakeup; echo XHC1 > /proc/acpi/wakeup; echo XHC2 > /proc/acpi/wakeup; echo XH00 > /proc/acpi/wakeup"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now disable-usb-wakeup.service
```
