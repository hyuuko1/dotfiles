- [i3: i3 User’s Guide](https://i3wm.org/docs/userguide.html)

- [ArchLinux 下 i3wm 安装和简单配置美化 | Try's Notebook](https://mindview.top/pages/be527f/)
- [Arch Linux i3wm 的安装与配置 - swwind's blog](https://blog.sww.moe/post/archlinux-setup)
- [Choose any key as the modifier in i3wm in 6 steps | Simple IT 🤘 Rocks](https://simpleit.rocks/linux/change-modifier-key-in-i3/)

```bash
#
paru -S 显卡驱动
# 安装显示服务器
paru -S xorg-server


# 如果你想用 startx 启动，就：
paru -S xorg-xinit
# 否则就安装登录管理器
paru -S sddm


# i3-gaps 为 i3wm 的分支，提供了更多特性
paru -S i3-gaps



paru -S alacritty neovim NetworkManager

compton 	提供窗口透明支持
polybar 	状态条，类似于windows那个任务栏，也可以用默认的i3bar或者装别的panel
rofi 	快捷程序启动，也可以装dmenu
feh 	墙纸设置


# 新建用户。-m 为用户创建家目录；-G wheel 将用户添加到 wheel 用户组
useradd -m -G wheel -s /bin/zsh username
# 设置密码
passwd username

nvim /etc/sudoers


systemctl enable 一些
```

network-manager-applet
