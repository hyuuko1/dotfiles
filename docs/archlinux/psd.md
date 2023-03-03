一般固态硬盘 2TB 版本最高可达 1200 TBW，如果用 6 年，那么平均每天最多写入 1200000/6/365 = 548GB。

##

- [Profile-sync-daemon - ArchWiki](https://wiki.archlinux.org/title/profile-sync-daemon)
- [52663 - frequent small disk I/O - chromium](https://bugs.chromium.org/p/chromium/issues/detail?id=52663)

虽然 btrfs 默认有 commit=30 选项，但是有些软件会通过 fsync syscall 强制将数据从 page cache 中写回 disk，比如 edge, chrome, firefox 都有 frequent small disk I/O。

我们可以使用 profile-sync-daemon

```bash
❯ paru -S profile-sync-daemon

# 生成 $XDG_CONFIG_HOME/psd/psd.conf
❯ psd
# 并修改，取消注释 BROWSERS=(microsoft-edge)
# 创建文件
❯ cat /usr/share/psd/browsers/microsoft-edge
if [[ -n "$MSEDGE_CONFIG_HOME" ]]; then
    DIRArr[0]="$MSEDGE_CONFIG_HOME/$browser"
else
    DIRArr[0]="$XDG_CONFIG_HOME/$browser"
fi
PSNAME="msedge"

# 解析配置文件，看看 psd 会做什么
❯ psd parse
# 启动 psd
❯ systemctl enable --now --user psd.service
```

其他的一些写入的文件。

vsocde，每个工作区（窗口）的状态被修改时（比如鼠标选择文本），都要保存写入 /home/hyuuko/.config/Code/User/workspaceStorage/b5277402a37e5462a2e7ec4f93b3eb20/state.vscdb 这个 SQLite3 数据库，并且立即写回硬盘。有时还会写到 /home/hyuuko/.config/Code/User/globalStorage/state.vscdb。
这个源头是 <https://github.com/microsoft/vscode/blob/d1aa00acef8b2cfa88621c448b8fd8cd034f60a9/src/vs/base/parts/storage/node/storage.ts#L304> 这里用了 `sqlite3.Database` 而非 [Caching · TryGhost/node-sqlite3 Wiki](https://github.com/TryGhost/node-sqlite3/wiki/Caching) 里的 `sqlite3.cached.Database`

- [ ] 仍然有一些小的写入，应该是其他的日志啥的，主要是 /home/hyuuko/.config/Code/TransportSecurity
  - 继续用 inotifywatch -t 10 -r ~/.config/Code/User 来 debug！
  - 还有 edge、telegram 也是，仍然有一些小的写入，应该也是 SQLite3
  - 用 iotop 抓取数据试试
  - /home/hyuuko/.local/share/TelegramDesktop/tdata/user_data/cache/0/binlog
  - /home/hyuuko/.local/share/TelegramDesktop/tdata/user_data/media_cache/0/binlog
  - /home/hyuuko/.local/share/TelegramDesktop/log.txt
  - ~.local/state/wireplumber/restore-stream

```bash
❯ ln -sf /run/user/1000/edge-cache ~/.cache/microsoft-edge

❯ ln -sf /run/user/1000/icon-cache.kcache ~/.cache/icon-cache.kcache
❯ ln -sf /run/user/1000/plasma_theme_Layan_v0.1.kcache ~/.cache/plasma_theme_Layan_v0.1.kcache


rm ~/.cache/mesa_shader_cache/
mkdir -p /run/user/1000/.cache/mesa_shader_cache
ln -sf /run/user/1000/.cache/mesa_shader_cache ~/.cache/mesa_shader_cache



# vscode 的

rm -rf ~/.config/Code/Backups
rm -rf ~/.config/Code/Cache
rm -rf ~/.config/Code/GPUCache
rm -rf ~/.config/Code/DawnCache
rm -rf ~/.config/Code/logs
# vscode 自动保存未保存的文件
rm -rf ~/.config/Code/User/History
rm -rf ~/.config/Code/User/workspaceStorage

mkdir -p /run/user/1000/Code/Backups
mkdir -p /run/user/1000/Code/Cache
mkdir -p /run/user/1000/Code/GPUCache
mkdir -p /run/user/1000/Code/DawnCache
mkdir -p /run/user/1000/Code/logs
mkdir -p /run/user/1000/Code/User/History
mkdir -p /run/user/1000/Code/User/workspaceStorage

ln -sf /run/user/1000/Code/Backups ~/.config/Code/Backups
ln -sf /run/user/1000/Code/Cache ~/.config/Code/Cache
ln -sf /run/user/1000/Code/GPUCache ~/.config/Code/GPUCache
ln -sf /run/user/1000/Code/DawnCache ~/.config/Code/DawnCache
ln -sf /run/user/1000/Code/logs ~/.config/Code/logs
ln -sf /run/user/1000/Code/User/History/ ~/.config/Code/User/History
ln -sf /run/user/1000/Code/User/workspaceStorage/ ~/.config/Code/User/workspaceStorage

mkdir -p /run/user/1000/Code/User/globalStorage
cp ~/.config/Code/User/globalStorage/state.vscdb.backup /run/user/1000/Code/User/globalStorage/state.vscdb
ln -sf /run/user/1000/Code/User/globalStorage/state.vscdb ~/.config/Code/User/globalStorage/state.vscdb



paru -S inotify-tools
# 只能显示发生修改的文件所处的文件夹，不能显示具体的文件
inotifywatch -t 10 -r ~/.config/Code

# 监控磁盘 io
# -b 选项非交互式，可以留下发生 diskio 的进程的记录
paru -S iotop
sudo iotop -o -b -u hyuuko -a
# -P 只显示进程而非所有线程
sudo iotop -o -b -u hyuuko -a -P

sudo strace -f -p 进程号 -e trace=open,write

先 iotop 看看是哪个进程有 diskio
然后再 strace 并且查看是哪个 fd，然后 ll /proc/进程号/fd
还可以 inotifywatch 看看是哪个文件夹下的文件发生了变化

    PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
   1177 ?dif hyuuko        0.00 B    116.00 K  ?unavailable?  kwin_wayland --wayland-fd 7 --socket wayland-0 --xwayland-fd 8 --xwayland-fd 9 --xwayland-display :1 --xwayland-xauthority /run/user/1000/xauth_ZCSIyl --xwayland
   1486 ?dif hyuuko       76.00 K    332.00 K  ?unavailable?  plasmashell --no-respawn
   1699 ?dif hyuuko        0.00 B    232.00 K  ?unavailable?  wireplumber




# 进程号用那个第一个 code 进程的进程号
# 然后在 vsocde 里创建文件，修改，保存文件，会发现 vscode 在 write 后会 fdatasync！
sudo strace -f -p 进程号 -e trace=openat,write,fcntl,fsync,fdatasync
```

- [ ] [5.2.2. Tracking I/O Time For Each File Read or Write](http://sourceware.org/systemtap/SystemTap_Beginners_Guide/iotimesect.html)
