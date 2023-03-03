##

- [Archlinux 优化之一 - 我的自留地](https://blog.tiantian.cool/arch-1/)
-
- [ ] [优化 Linux bootloader 速度的究极之路：从 GRUB 到 EFI Stub - 知乎](https://zhuanlan.zhihu.com/p/28708585)
  ```bash
  sudo efibootmgr --disk /dev/nvme0n1 --part 1 --create --label "Arch" --loader /vmlinuz-linux-xanmod --unicode 'root=UUID=0f949b62-98bf-4787-b8b9-1f21d0889691  rw initrd=\initramfs-linux-xanmod.img loglevel=3 quiet nowatchdog'
  ```
- [ ] 用 timeshift 还是 snapper？
- [ ] linux-zen 还是 xanmod？
- [ ] 选择一个 Compositor
  - 平铺式：Sway, hyperland
  - 堆叠式：wayfire, KDE KWin
- [ ] wayland 版本的 redshift：`redshift-wayland-git`
- [ ] 网络加速？
- [ ] 优化 [ventureoo/ARU: Arch Linux Optimization Guide (RU) \[MIRROR\]](https://github.com/ventureoo/ARU)
- [ ] gnome 里一些好用的软件，比如 gparted 啥的 https://archlinux.org/groups/x86_64/gnome/ https://archlinux.org/groups/x86_64/gnome-extra/
- [ ] 如何使用 x86-64_v3
