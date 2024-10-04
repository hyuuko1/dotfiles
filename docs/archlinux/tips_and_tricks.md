- [AUR 软件包 Popularity 排行](https://aur.archlinux.org/packages/?SB=p&SO=d)
- 按 F12 可以打开 Yakuake（一个快捷终端），不要点击关闭按钮，直接按 F12 或点击其他地方隐藏就行
- 右下角系统托盘，鼠标光标放在电源图标或音量图标上，滚动滚轮，就可以调节屏幕亮度和音量。
- Alt+Space 或者直接在桌面输入字符就可打开 KRunner（可以用来搜索应用程序、书签等）
- 状态栏剪贴板右键->配置剪贴板->常规->勾选「忽略选区」。这样能避免鼠标选中文字时自动复制
- 给 spectacle 配置快捷键：系统设置->快捷键->Spectacle 截图工具。截取矩形区域 `Ctrl + Alt + A`。
- 修改 grub 字体
  ```sh
  # 安装点阵字体 ttf-unifont
  paru ttf-unifont
  # 生成 fontsize 为 24 的 pf2 文件
  sudo grub-mkfont -o /boot/grub/fonts/Unifont24.pf2 -s 24 /usr/share/fonts/Unifont/Unifont.ttf
  # 编辑 /etc/default/grub，GRUB_FONT="/boot/grub/fonts/Unifont24.pf2"
  # 重新生成配置
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  ```
- 解压 zip 乱码
  ```bash
  sudo pacman -S unarchiver
  # unar 一般情况下可以检测到正确的编码，保险起见加上 -e gb18030 选项
  unar -e gb18030 xxx.zip
  # 也可用 https://github.com/quininer/unzrip 用 rust 写的一个，也可以自动检测编码
  ```
- Firefox 设置无边框：进入 Firefox 的 Customize 界面，取消勾选左下角的 Title Bar
- TIM 导致 KDE 桌面卡死。
  ```sh
  # Ctrl Alt F2 进入 tty2
  kill $(pgrep TIM.exe)
  # 如果还不行，就只好 sudo systemctl restart sddm 了
  ```
- 如果新安装的软件在菜单中找不到，可以试试 `rm ~/.cache/icon-cache.kcache` 清除图标缓存
- 禁止 DiscoverNotifier 自启动
  ```bash
  cp /etc/xdg/autostart/org.kde.discover.notifier.desktop ~/.config/autostart
  vim ~/.config/autostart/org.kde.discover.notifier.desktop
  # 删除一行 X-KDE-autostart-phase=1
  # 新增一行 Hidden=true
  ```
- kde 的 baloo 开机时会占用很多内存建立文件索引，`balooctl disable` 或 `systemctl --user mask kde-baloo.service` 禁用之。
  还有 `systemctl --user mask plasma-baloorunner.service`
- telegram 图标分辨率太低
  ```bash
  # 生成 ~/.local/share/applications/ /usr/share/applications/org.telegram.desktop.desktop 里的 Exec 字段，unset 环境变量 QT_SCREEN_SCALE_FACTORS
  desktop-file-install --dir ~/.local/share/applications/ --set-key=Exec --set-value="env -u QT_SCREEN_SCALE_FACTORS telegram-desktop -- %u" /usr/share/applications/org.telegram.desktop.desktop
  ```
- 禁用 geoclue service
  geoclue 是 redshift 的依赖，用于为一些软件提供位置服务。
  ```
  sudo systemctl mask geoclue.service
  sudo ln -sf /dev/null /etc/xdg/autostart/geoclue-demo-agent.desktop
  ```
