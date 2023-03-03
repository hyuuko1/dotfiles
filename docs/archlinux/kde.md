- [KDE - ArchWiki](https://wiki.archlinux.org/title/KDE)

## 安装

先安装 plasma 桌面环境，有几种选择

- plasma-meta 软件包，包含许多依赖
- plasma 软件组，包含的软件包和 plasma-meta 的依赖差不多
- plasma-desktop 软件包，最小安装

`pacman -Sg plasma` 查看该软件组包含的软件包

- plasma-systemmonitor 系统监视器
- ...

有些软件包属于好几个软件组，`pacman -Qg` 查看已安装的属于某个软件组里的软件包，`pacman -Sg 软件组` 查看远程的

## 软件组

- plasma
- kde-applications
- kde-utilities
- kde-multimedia
- kde-graphics
- kde-network
- kde-system
- kdevelop
- kdesdk
- kf5
- kf5-aids
- kdepim
- kde-accessibility
- kde-education
- telepathy-kde
- ...
