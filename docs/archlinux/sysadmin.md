- [System maintenance - ArchWiki](https://wiki.archlinux.org/title/System_maintenance)

## 检查错误

### systemd 服务问题

```bash
# 检查是否有 systemd 服务失败
systemctl --failed
```

### 日志文件

- [systemd/Journal - ArchWiki](https://wiki.archlinux.org/title/Systemd/Journal)

systemd 提供了自己的日志系统（logging system），称为 journal。

```bash
# -x 选项添加解释性帮助文本
# 显示本次启动后的所有错误
journalctl -p 3 -xb
# 显示本次启动后的所有警告
journalctl -p 4 -xb
# Notice
journalctl -p 5 -xb
# Informational
journalctl -p 6 -xb
# Debug
journalctl -p 7 -xb

# 显示本次启动后的所有消息
journalctl -b

# 显示指定单元今天内的所有消息
journalctl -u v2raya --since today

# 实时查看最新的日志
journalctl -f
```

```bash
sudo vim /etc/systemd/journald.conf
# SystemMaxUse=100M # 日志总大小限制在 100 M

# 重启 journald 服务使更改生效
sudo systemctl restart systemd-journald.service

# 由于硬件 bug，内核一直打印错误信息，我怕写坏硬盘，所以把 /var/log/journal/ 删掉，
# 这样 journal 就会把日志写到 /run/systemd/journal/ 和 /run/log/journal/ ？关机后日志不会被保存
sudo rm -rf /var/log/journal/
# 并且在 /etc/pacman.conf 里设置一下 NoExtract
NoExtract   = var/log/journal/
# 重启 journald 服务
sudo systemctl restart systemd-journald.service
```

XXX 打印错误消息这个问题，我试过加内核参数 `acpi_osi="!Windows 2015"` 或 `acpi_osi=! acpi_osi='Windows 2009'` 都没用。
evregion-130
exfldio-261

## 清理文件系统

filelight 图形画显示空间分布

- `sudo pacman -Sc`：清理所有的缓存文件和无用的软件库。`/var/cache/pacman/pkg/` 和 `/var/lib/pacman/`
- `sudo pacman -Rns $(pacman -Qdtq)` 清除系统中无用的包
- `paru -Scd`: -d option **delete** cached AUR packages and any untracked files in the cache

旧的配置文件可能和新软件版本不兼容，所以请定期清理和更新配置文件

|                |                              |
| -------------- | ---------------------------- |
| ~/.config      | 用户特定的配置               |
| ~/.cache       | 用户特定的非必要（缓存）数据 |
| ~/.local/share | 用户特定数据文件             |
| ~/.local/state | 用户特定状态文件             |

更多见 [XDG 基本目录规范](https://wiki.archlinux.org/title/XDG_Base_Directory)

```bash
source /opt/anaconda/bin/activate root
sudo conda clean -p     # 删除没有用的包 --packages
sudo conda clean -y -a  # 删除所有的安装包及cache(索引缓存、锁定文件、未使用过的包和tar包)

pip cache purge
```

```bash
# 查找一些破损的软链接（比如软件卸载后 systemd service unit 没删除）
find /bin /etc /lib /sbin /usr -xtype l -print
```

## 硬盘管理

- fdisk（命令行）
  - 调整分区大小、查看分区信息、更改分区类型、修改分区名、开/关标志（Attributes）、修复分区顺序
- cfdisk（终端图形化工具）
  - 功能比 fdisk 少一些
- gparted（GUI 工具）
  - fdisk 有的功能基本都有（分区类型不太全面），而且可以修改卷标（LABEL）
  - [Managing Partition Flags](https://gparted.org/display-doc.php%3Fname%3Dhelp-manual#gparted-manage-partition-flags)
- 注意
  - 注意区分卷标和分区名称，分区名称一般只在 Windows 上用到
    - 在 Linux 将 Windows 的动态磁盘改为基本磁盘时，不仅需要把分区类型改为 `Microsoft basic data`，还需要把分区名称改成 `Basic data partition`
  - 如果 NTFS 文件系统出了文件，最好是在 Windows 上进行修复驱动器
  - [GPT partition attribute bits](https://man7.org/linux/man-pages/man8/sfdisk.8.html)
    - Bit 0 (RequiredPartition)：如果设置了这个位，则平台需要该分区。分区的创建者表示，删除或修改内容可能导致平台功能的丢失或平台启动或操作失败。如果这个分区被删除，系统就不能正常工作，它应该被认为是系统硬件的一部分。
    - Bit 1 (NoBlockIOProtocol)：EFI 固件会忽略该分区的内容，并不去读它
    - Bit 2 (LegacyBIOSBootable)：分区可以通过 legacy BIOS 固件可。
    - Bits 3-47：未定义且必须为零。保留供未来版本的 UEFI 规范扩展。
    - Bits 48-63：保留供 GUID 特定使用。这些位的使用将根据分区类型而有所不同。
  - 关于 EFI 分区
    - 不能有 NoBlockIOProtocol 标志
    - 分区类型必须是 EFI System，GUID 为 `C12A7328-F81F-11D2-BA4B-00A0C93EC93B`

### fdisk

```bash
sudo fdisk /dev/sda
# 输入 m 获取帮助
# 输入 t 更改分区类型（比如 Linux home）

# 输入 x 进入专家命令模式
# 输入 f 修复分区顺序（即重新排序 /dev/sda1 /dev/sda2 设备名称）
# 输入 n 更改分区名（比如 Basic data partition）
```

`fdisk` 不能修改文件系统的 label，需要使用特定于文件系统的工具，比如 `btrfs filesystem label /dev/XXX <label>`，或者 GParted 这样的软件。

```
   A   toggle the legacy BIOS bootable flag
   B   toggle the no block IO protocol flag
   R   toggle the required partition flag
   S   toggle the GUID specific bits
```

### GParted

GParted 比 KDE 的 partitionmanager 要好用一点，感觉 partitionmanage 对 Fat32 的支持有些问题（不能修改卷标、格式化会默认加上 NoBlockIOProtocol/LegacyBIOSBootable 标志）。

```bash
sudo pacman -S gparted
# 可选依赖（文件系统的 userspace utiltiies）：
# 支持 FAT32：dosfstools, mtools
# 支持 exFAT：exfatprogs
# 支持 NTFS：ntfs-3g
```

## BIOS 设置

日志中出现错误 `__common_interrupt: 1.55 No irq handler for vector`，解决办法：以华硕 TUF B550M 的主版为例，在高级->PCI 子系统里将一些东西启用即可。

## systemd

## OOM

- [2. 内存管理 — 内核知识 v0.1 documentation](https://learning-kernel.readthedocs.io/en/latest/mem-management.html)

Linux 系统允许程序申请比系统可用内存更多的内存空间，这个特性叫做 overcommit 特性，这样做可能是为了系统的优化，因为不是所有的程序申请了内存就会立刻使用，当真正的使用时，系统可能已经回收了一些内存。但是，当你使用时 Linux 系统没有内存可以使用时，OOM Killer 就会出来让一些进程退出。
Linux 下有 3 种 Overcommit 的策略（参考内核文档： Documentation/vm/overcommit-accounting ），可以在 `/proc/sys/vm/overcommit_memory` 配置（可以取 0,1 和 2 三个值，默认是 0）。

- 0：启发式策略，比较严重的 Overcommit 将不能得逞，比如你突然申请了 128TB 的内存。而轻微的 overcommit 将被允许。另外，root 能 Overcommit 的值比普通用户要稍微多。
- 1：永远允许 overcommit，这种策略适合那些不能承受内存分配失败的应用，比如某些科学计算应用。
- 2：永远禁止 overcommit，在这个情况下，系统所能分配的内存不会超过 `swap+RAM*系数` （`/proc/sys/vm/overcmmit_ratio`，默认 50%，你可以调整），如果这么多资源已经用光，那么后面任何尝试申请内存的行为都会返回错误，这通常意味着此时没法运行任何新程序。

我们可以通过设置一些值来影响 OOM killer 做出决策。Linux 下每个进程都有个 OOM 权重，在 `/proc/<pid>/oom_adj` 里面，取值是-17 到+15，取值越高，越容易被干掉。
最终 OOM killer 是通过 `/proc/<pid>/oom_score` 这个值来决定哪个进程被干掉的。这个值是系统综合进程的内存消耗量、CPU 时间(utime + stime)、存活时间(uptime - start time)和 oom_adj 计算出的，消耗内存越多分越高，存活时间越长分越低。

`/proc/sys/vm/panic_on_oom` 当发生 out of memory 时，该值允许或者禁止内核 panic。（默认为 0）

- 0：发生 oom 时，内核会选择性的杀死一些进程，然后尝试着去恢复。
- 1：发生 oom 时，内核直接 panic。（如果一个进程使用 mempolicy、cpusets 来现在内存在一个 nodes 中消耗，则不会发生 panic）
- 2：发生 oom 时，内核无条件直接 panic

panic_on_oom=2+kdump，一起作用时，这样用户就可以分析出为什么会发生 oom 的原因了。

```bash


```
