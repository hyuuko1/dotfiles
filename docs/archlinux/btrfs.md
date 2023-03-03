- [Btrfs - ArchWiki](https://wiki.archlinux.org/title/Btrfs)
- [mkfs.btrfs(8)](https://man.archlinux.org/man/mkfs.btrfs.8)
- [btrfs(5)](https://man.archlinux.org/man/btrfs.5) 关于 BTRFS 文件系统的主题(挂载选项、支持的文件属性等)
- [SysadminGuide - btrfs.wiki](https://btrfs.wiki.kernel.org/index.php/SysadminGuide)
- [compress 参数 benchmark](https://docs.google.com/spreadsheets/d/1x9-3OQF4ev1fOCrYuYWt1QmxYRmPilw_nLik5H_2_qA/edit#gid=0)
- [文件系统层次结构标准 - Wikipedia](https://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%E5%B1%82%E6%AC%A1%E7%BB%93%E6%9E%84%E6%A0%87%E5%87%86)

## Btrfs

```bash
# 查看文件系统信息
sudo btrfs inspect-internal dump-super -a /dev/nvme1n1p2

# 列出子卷
sudo btrfs subvolume list /
```

## 记一次从 Ext4 转换到 Btrfs

- [Linux ext4 文件系统转 Btrfs](https://blog.samchu.cn/posts/linux-ext4-to-btrfs/)
- [rsync 用法教程](https://www.ruanyifeng.com/blog/2020/08/rsync.html)
- [Linux rsync 命令用法详解](http://c.biancheng.net/view/6121.html)
- [Rsync 常用选项参数 - linux 中国网 wiki](https://wiki.linuxchina.net/index.php/Rsync%E5%B8%B8%E7%94%A8%E9%80%89%E9%A1%B9%E5%8F%82%E6%95%B0)

主要步骤：

1. 进入 livecd 环境
2. 将 root 分区挂载到 `/mnt`，home 分区挂载到 `/mnt/oldhome`
3. 备份 home 分区
4. 删除 home 分区，并扩展到 root 分区上
5. root 分区转成 btrfs 文件系统

```bash
# 进入 livecd 环境
# 将 root 分区挂载到 /mnt，home 分区挂载到 /mnt/oldhome

# 将文件复制到 /mnt/home
# -a 以递归方式传输文件，并保持所有属性（比如修改时间、权限等）
# -v 表示打印一些信息，比如文件列表、文件数量等。
# -l 表示保留软连接。
# -L 表示像对待常规文件一样处理软连接。如果是 SRC 中有软连接文件，则加上该选项后，将会把软连接指向的目标文件复制到 DEST。
# --progress 在同步的过程中可以看到同步的过程状态
sudo rsync -av --hard-links --progress /mnt/oldhome/ /mnt/home
# -n 如果不确定 rsync 执行后会产生什么结果，可以先用-n或--dry-run参数模拟执行的结果
sudo rsync -avn --hard-links --progress /mnt/oldhome/ /mnt/home

umount /mnt
# 删除 home 分区，扩展 root 分区
cfdisk /dev/sda

# 首先使用 fsck 检查磁盘，保证 root 分区没有问题
fsck.ext4 /dev/sda2

# 开始文件系统转换
btrfs-convert /dev/sda2
# 挂载分区
mount -o compress=zstd:2 /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot

# 调整 btrfs 文件系统大小为该设备分区的最大可用大小
btrfs filesystem resize max /mnt
# 给整个文件系统重新压缩（碎片整理）
btrfs filesystem defragment -r -czstd /mnt

# 然后修改 /etc/fstab
vim /etc/fstab
# 并且重新创建 initramfs
mkinitcpio --preset linux
# 重新创建引导
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux
# 生成配置文件
grub-mkconfig -o /boot/grub/grub.cfg

# 检修
btrfs scrub start /dev/sda2
btrfs scrub status /dev/sda2
# 如果出现了校验值错误，则 dmesg | grep "checksum error at" 查看是哪个文件的问题

# 之后就可以重启了

# /ext2_saved 是备份子卷，确认没有问题后，可以删除它
btrfs subvolume delete /ext2_saved

# 其他

# balance 主要用于在添加或删除设备时跨设备重新平衡文件系统中的数据
# 一般在组 RAID 的时候才会用到吧
btrfs balance start /
btrfs balance status /

# 查看 IO 错误统计
btrfs device stats /dev/sda2
# 重置统计数据
btrfs device stats --reset /dev/sda2
```

## RAID

- [Btrfs\_(简体中文)#多设备文件系统 - ArchWiki](<https://wiki.archlinux.org/title/Btrfs_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E5%A4%9A%E8%AE%BE%E5%A4%87%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F>)

注意须在 `/etc/mkinitcpio.conf` 中加入 udev 钩子或 btrfs 钩子才能在一个池中使用多个 Btrfs 设备。

## CoW

默认情况下 Btrfs 对所有文件使用写时复制 (CoW)（从 coreutils 9.0 开始），而无需为 `cp` 命令指定 `--reflink` 选项。若要以标准方式复制文件，可使用 `--reflink=never` 选项。

```bash
❯ dd if=/dev/zero of=test bs=1M count=1
❯ btrfs filesystem du -s test
     Total   Exclusive  Set shared  Filename
   1.00MiB     1.00MiB       0.00B  test

❯ cp test test1
❯ btrfs filesystem du -s test
     Total   Exclusive  Set shared  Filename
   1.00MiB       0.00B     1.00MiB  test

❯ rm test1
❯ sync
❯ btrfs filesystem du -s test
     Total   Exclusive  Set shared  Filename
   1.00MiB     1.00MiB       0.00B  test

❯ cp --reflink=never test test2
❯ btrfs filesystem du -s test
     Total   Exclusive  Set shared  Filename
   1.00MiB     1.00MiB       0.00B  test
```

### 禁用 CoW

- 对子卷使用 `nodatacow` 挂载选项。只会影响新创建的文件，对于已存在的文件 CoW 依然会发生。该选项还会禁用 checksums 和 compression。
- 禁用文件/目录：`chattr +C /dir/file`。只对该目录下新创建的和不存在其他引用的文件有效。

对已存在的目录禁用 CoW，比如说 [`/var/log/journal` 因为 CoW 而降低了访问速度](https://askubuntu.com/a/836106)

```bash
cd /var/log
mv journalctl tmp
mkdir journalctl
chown root:systemd-journal journal
# Disable COW on the new journal directory
chattr +C journal
# --reflink=never 选项禁止以 CoW 的方式复制
cp -a --reflink=never tmp/* journal
rm -rf tmp
# Set shared 为 0 则说明该目录下不存在 CoW
btrfs filesystem du -s journal
```

## 子卷

Btrfs 子卷根目录与目录的不同之处在于，每个子卷定义不同的 inode 编号空间（不同子卷中的不同 inode 可以具有相同的 inumber），并且子卷下的每个 inode 具有不同的设备编号。

子卷可以嵌套，每个子卷（顶级子卷除外）都有一个父子卷。
Btrfs 文件系统有一个默认子卷，它最初被设置为顶级子卷，如果没有指定 subvol 或 subvolid 选项，则会挂载。

### 布局

- [SysadminGuide#Layout - btrfs.wiki](https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Layout)

有几种基本模式来布局子卷（包括快照）及其混合。

#### Flat

所有子卷都是顶级子卷（ID 5）的子卷，通常位于层次结构的正下方或属于顶级子卷的某些目录的下方，但不嵌套在其他子卷的下方，例如：

```
toplevel         (volume root directory, not to be mounted by default)
  +-- root       (subvolume root directory, to be mounted at /)
  +-- home       (subvolume root directory, to be mounted at /home)
  +-- var        (directory)
  |   \-- www    (subvolume root directory, to be mounted at /var/www)
  \-- postgres   (subvolume root directory, to be mounted at /var/lib/postgresql)
```

优缺点

- 快照的管理（尤其是滚动快照）可能更容易，因为有效的布局更直观。
- 这些子卷/装入点中的每个都可以使用不同的选项进行装入。
- 所有子卷都需要手动（例如，通过 fstab）安装到其所需位置
- 卷中所有不在已挂载的子卷下方的所有内容都不可访问，甚至不可见（比如示例中的顶级根目录 toplevel 以及 var 目录）。 这可能有利于安全，尤其是在与快照一起使用时。

#### Nested

子卷位于文件层次结构中的任何位置，通常位于它们所需的位置。

```
toplevel                  (volume root directory, to be mounted at /)
+-- home                  (subvolume root directory)
+-- var                   (subvolume root directory)
    +-- www               (subvolume root directory)
    +-- lib               (directory)
         \-- postgresql   (subvolume root directory)
```

- 管理快照（尤其是滚动快照）可能会被认为更加困难，因为有效的布局不直接可见。
- 子卷不需要手动（或通过 fstab）安装到所需位置，它们“自动”显示在各自的位置。
- 对于这些子卷中的每一个子卷，其装入点的装入选项都适用。
- 一切都是看得见的。这可能会对安全性造成不利影响，尤其是与快照一起使用时。

### 何时制作子卷

- 将文件系统的某些部分排除在快照之外。
  比如用于存放编译目标文件的目录
- “分割”其本身“完整”和/或“一致”的区域。
  例如 `/home`、`/var/www` 或 `/var/lib/postgresql/`，它们通常或多或少“独立”于系统的其他部分。相比之下，将依赖于彼此特定状态的系统部分拆分为不同的子卷是个坏注意。
- 拆分需要特殊属性/安装选项的区域。

## 快照

快照只是使用 Btrfs 的 CoW 功能与其他子卷共享其数据（和元数据）的子卷。

一旦创建了（可写）快照，原始子卷和新快照子卷之间的状态没有区别。要回滚到快照，请卸载修改后的原始子卷，使用 mv 将旧子卷重命名为临时位置，然后再次将快照重命名为原始名称。 然后您可以重新挂载子卷。

当心：创建快照然后对任何用户可见（例如，当它们在嵌套布局中创建时）时必须小心，因为这可能具有安全隐患。
