- [systemd-boot - ArchWiki](https://wiki.archlinux.org/title/systemd-boot)

```bash
❯ sudo bootctl install
Created "/boot/EFI".
Created "/boot/EFI/systemd".
Created "/boot/EFI/BOOT".
Created "/boot/loader".
Created "/boot/loader/entries".
# 这个目录应该是让用户放置 vmlinuz-linux 和 initramfs-linux.img 的？
Created "/boot/EFI/Linux".
# systemd-bootx64.efi 会被添加到 UEFI 引导条目中
# Boot0002* Linux Boot Manager    HD(1,GPT,a24a2058-fe31-9a4c-8bf6-d8823745e443,0x800,0xfa000)/File(\EFI\systemd\systemd-bootx64.efi)
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "/boot/EFI/systemd/systemd-bootx64.efi".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "/boot/EFI/BOOT/BOOTX64.EFI".
Random seed file /boot/loader/random-seed successfully written (32 bytes).
Created EFI boot entry "Linux Boot Manager".
```

修改文件 `/boot/loader/loader.conf`

```conf
# @saved 会自动记录上次启动的系统
default arch # 默认引导的系统，注意这里的 arch 对应的是 arch.conf
timeout 3    # 在引导界面停留的时间，如果你想引导不止一个系统，不应将这一项设置成 0
console-mode 1
# editor	0    # 0 禁用编辑内和参数的功能，默认是开启的
```

`man loader.conf`

创建文件 `/boot/loader/entries/arch.conf`

```conf
title Arch Linux               # 这是启动选项的名称，将会出现在引导界面
linux   /vmlinuz-linux         # 压缩的可引导内核，用于系统启动
initrd  /amd-ucode.img         # 由芯片制造商提供的对 CPU 微码的稳定性和安全性更新，按照 Arch wiki 的说法
                               # 它应当是' first initrd in the bootloader config file'
initrd  /initramfs-linux.img   # 为内核提供的一个临时的文件系统

# 内核参数
# root 挂载的位置，可以由 LABEL, PARTUUID 或者 UUID识别
options root=UUID=a5618889-cc92-484b-ac69-b07df8cd00c4 rw rootflags=subvol=@archlinux
options loglevel=5 nowatchdog modprobe.blacklist=iTCO_wdt
options transparent_hugepage=always iommu=pt intel_iommu=on
options nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1
```

创建文件 `/boot/loader/entries/arch-lts.conf`

```conf
title Arch Linux LTS
linux   /vmlinuz-linux-lts
initrd  /amd-ucode.img

initrd  /initramfs-linux-lts.img

options root=UUID=7c385288-8d94-4f83-972a-8352e3e48941 rw rootflags=subvol=@ loglevel=5 nowatchdog modprobe.blacklist=iTCO_wdt
```

##

当 grub 更新时，可以通过 hook，自动更新 esp 中的 efi 可执行文件。
准确的说，是当 `/usr/lib/systemd/boot/efi/systemd-bootx64.efi` 文件更新时。

`/etc/pacman.d/hooks/systemd-boot.hook`

```conf
[Trigger]
Type = Path
Operation = Upgrade
Target = usr/lib/systemd/boot/efi/systemd-bootx64.efi

[Action]
Description = Updating systemd-boot...
When = PostTransaction
Exec = /usr/bin/bootctl --no-variables --graceful update
```

```bash
# 查看 bootctl 启动列表
sudo bootctl list

# 查看 bootctl 状态
sudo bootctl status
```

## 其他

- [UEFI variables - ArchWiki](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface#UEFI_variables)

systemd-boot 可以自动从 UEFI 变量中读取启动项，比如：

```bash
❯ bootctl list
Boot Loader Entries:
         type: Automatic
        title: Windows Boot Manager
           id: auto-windows
       source: /sys/firmware/efi/efivars/LoaderEntries-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f

         type: Automatic
        title: Reboot Into Firmware Interface
           id: auto-reboot-to-firmware-setup
       source: /sys/firmware/efi/efivars/LoaderEntries-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f

❯ ls /sys/firmware/efi/efivars/
# LoaderEntries-*           记录了引导条目列表
# LoaderEntryLastBooted-*   记录了上一次启动的引导条目
# LoaderEntrySelected-*     记录了此次启动的引导条目

❯ efivar --list
```

**UEFI defines variables through which an operating system can interact with the firmware.** UEFI boot variables are used by the boot loader and used by the OS only for early system start-up. UEFI runtime variables allow an OS to manage certain settings of the firmware like the UEFI boot manager or managing the keys for UEFI Secure Boot protocol etc.

Linux kernel exposes UEFI variables data to userspace via efivarfs (EFI VARiable FileSystem) interface.

**Userspace tools**
There are few tools that can access/modify the UEFI variables, namely

- efivar — Library and Tool to manipulate UEFI variables (used by efibootmgr)
- efibootmgr — Tool to manipulate UEFI Firmware Boot Manager Settings

启动流程

1. 开机
2. UEFI（主板厂商的固件）检测并从 efi variables 里读取 boot loader entries，组成一个 boot loader list
3. 选择 boot entries，比如 Windows Boot Manager `/EFI/Microsoft/Boot/Bootmgfw.efi`，systemd-boot (Linux Boot Manager) `/EFI/systemd/systemd-bootx64.efi` 和 EFI Default Loader `/EFI/BOOT/BOOTX64.EFI`
4. 我们选择了 systemd-boot，systemd-boot 从 EFI Variables（可以读取到 Windows Boot Manager 和 UEFI shell 等等）以及 `/boot/loader/` 目录里的配置文件（我们配置的 Arch Linux）中读取 boot loader entries，组成一个 boot loader list
5. 选择 Arch Linux，就会启动 `/EFI/vmlinuz-linux` 内核。

**systemd-boot 在 boot 时，会自动检测这些：**
https://wiki.archlinux.org/title/Systemd-boot

1. Windows Boot Manager `/EFI/Microsoft/Boot/Bootmgfw.efi` 文件（应该是指与 systemd-boot 同一个分区内的文件）
2. Apple macOS Boot Manager
3. UEFI shell `/shellx64.efi`
4. EFI Default Loader `EFI/BOOT/bootx64.efi`
5. `/boot/EFI/Linux/` 里的 Unified kernel images https://wiki.archlinux.org/title/Unified_kernel_image
6. 搜索 `/loader/entries/*.conf`

## EFI shell

- [tianocore/edk2: EDK II](https://github.com/tianocore/edk2)
  - [What is TianoCore?](https://www.tianocore.org/)

```bash
❯ paru -S edk2-shell
❯ sudo cp /usr/share/edk2-shell/x64/Shell_Full.efi /boot/shellx64.efi
```

## Tips and tricks

**Choosing next boot**

```bash
❯ systemctl poweroff
❯ systemctl reboot
# 重启，并从 arch.conf 配置的 boot loader 启动
❯ systemctl reboot --boot-loader-entry=arch.conf
# 查看 --boot-loader-entry 选项的可用值
❯ systemctl reboot --boot-loader-entry=help
arch.conf
arch-lts.conf
auto-windows
auto-efi-shell
auto-reboot-to-firmware-setup
# 重启到固件设置界面
❯ systemctl reboot --firmware-setup
```

**Manual entry using efibootmgr**

```bash
# 创建一个引导条目
❯ efibootmgr --create --disk /dev/nvme0n1p1 --loader /EFI/refind/refind_x64.efi --label "rEFInd Boot Manager" --verbose
```

**Manual entry using bcdedit from Windows**

```bash
# 以管理员身份启动 powershell
> bcdedit /copy {bootmgr} /d "Linux Boot Manager"
# guid 替换成第一个命令返回的 id
> bcdedit /set {guid} path \EFI\systemd\systemd-bootx64.efi
```

**Menu does not appear after Windows upgrade**

- [Windows changes boot order - ArchWiki](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface#Windows_changes_boot_order)

## 给 Ventoy 的 Boot Entry 改个名字

```bash
# 删除
sudo efibootmgr -b 0002 -B
# /dev/nvme1n1p2
sudo efibootmgr --create --disk /dev/nvme1n1 --part 2 --loader '\EFI\BOOT\BOOTX64.EFI' --label "Ventoy"
```

```bash
# /dev/nvme0n1p1
sudo efibootmgr --create --disk /dev/nvme0n1 --part 1 --loader '\EFI\Microsoft\Boot\bootmgfw.efi' --label "Windows Boot Manager"
# /dev/nvme0n1p1
sudo efibootmgr --create --disk /dev/nvme0n1 --part 1 --loader '\EFI\BOOT\BOOTX64.EFI' --label "Systemd Boot"
# /dev/nvme1n1p2
sudo efibootmgr --create --disk /dev/nvme1n1 --part 2 --loader '\EFI\BOOT\BOOTX64.EFI' --label "Ventoy"

# 修改引导顺序
sudo efibootmgr --bootorder 0001,0002,0000
```
