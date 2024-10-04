#! /usr/bin/sh
# [Session Environment Variables - KDE UserBase Wiki](https://userbase.kde.org/Session_Environment_Variables)

# https://github.com/fcitx/fcitx5/issues/295#issuecomment-893188937
# 设置为 fcitx 会有更大的兼容性，因为一些旧的应用程序可能只支持 fcitx4 im 模块
export XMODIFIERS=@im=fcitx
# wayland 情况下，这两个不再需要
# export XIM=fcitx
# export XIM_PROGRAM=fcitx
# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma
# 这两个也别设置了
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
# SDL 必须用 fcitx5，否则会套用对 fcitx4 的特殊处理导致 fcitx5 启动失败
# 是为了让一些使用特定版本 SDL2 库的游戏能正常使用输入法。
export SDL_IM_MODULE=fcitx5

# 使用 Dolphin file open dialog 而非默认的 gtk
export GTK_USE_PORTAL=1

# https://wiki.archlinux.org/title/Visual_Studio_Code#Unable_to_move_items_to_trash
# electron 默认使用 gio 删除文件，当检测到 plasma 时自动使用 kioclient5 删除文件，
# 但使用 kioclient5 可能导致 UI 冻结 (https://github.com/microsoft/vscode/issues/90034)
# 别人的解决办法是使用 gio，我尝试设置这个环境变量后，vscode 删除文件时反而显示无法移动到废纸篓，只能彻底删除。
# export ELECTRON_TRASH=gio

# https://wiki.archlinux.org/title/Hardware_video_acceleration#Configuring_VA-API
export LIBVA_DRIVER_NAME=iHD
