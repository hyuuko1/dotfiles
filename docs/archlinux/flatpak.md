##

- [Flatpak - ArchWiki](https://wiki.archlinux.org/title/Flatpak)
- [Flatpak 文档](https://docs.flatpak.org/zh_CN/latest/index.html)
- [主页 | Flathub](https://flathub.org/zh-Hans)

```bash
❯ flatpak --help
用法：
  flatpak [选项…] 命令

内置命令：
 管理已安装的应用程序和运行时
  install                安装应用程序或运行时
  update                 更新已安装的应用程序或运行时
  uninstall              卸载已安装的应用程序或运行时
  mask                   屏蔽更新和自动安装
  pin                    置顶运行时以避免自动移除
  list                   列出已安装的应用和/或运行时
  info                   显示已安装应用或运行时的信息
  history                显示历史
  config                 配置 flatpak
  repair                 修复 flatpak 安装
  create-usb             将应用程序或运行时放到可移动媒体上

查找应用程序和运行时
  search                 搜索远程仓库的应用/运行时

管理正在运行的应用程序
  run                    运行应用程序
  override               覆盖应用程序的权限
  make-current           指定要运行的默认版本
  enter                  进入正在运行应用程序的命名空间
  ps                     列举正在运行的应用程序
  kill                   停止正在运行的应用程序

管理文件访问
  documents              列出导出的文件
  document-export        同意应用程序对特定文件的访问
  document-unexport      撤消对特定文件的访问
  document-info          显示有关特定文件的信息

管理动态权限
  permissions            列出权限
  permission-remove      从权限存储中移除项目
  permission-set         设置权限
  permission-show        显示应用权限
  permission-reset       重置应用权限

管理远程仓库
  remotes                列出所有已配置的远程仓库
  remote-add             添加新的远程仓库（通过网址）
  remote-modify          修改已配置远程仓库的属性
  remote-delete          删除已配置的远程仓库
  remote-ls              列出已配置远程仓库的内容
  remote-info            显示远程仓库中应用或运行时的有关信息

构建应用程序
  build-init             初始化用于构建的目录
  build                  在构建目录中运行构建命令
  build-finish           完成导出的构建目录
  build-export           将构建目录导出到仓库
  build-bundle           从本地仓库中的引用创建捆绑包文件
  build-import-bundle    导入捆绑包文件
  build-sign             签署应用程序或运行时
  build-update-repo      更新仓库中的摘要文件
  build-commit-from      基于现有引用创建新的交付
  repo                   显示仓库的有关信息

帮助选项：
  -h, --help              显示帮助选项

应用程序选项：
  --version               打印版本信息并退出
  --default-arch          显示默认架构并退出
  --supported-arches      显示支持架构并退出
  --gl-drivers            显示激活 gl 驱动并退出
  --installations         显示系统安装路径并退出
  --print-updated-env     显示运行 flatpak 应用所需的已更新环境
  --print-system-only     仅包含带有 --print-updated-env 的系统安装
  -v, --verbose           显示调试信息，-vv 显示更多详情
  --ostree-verbose        显示 OSTree 调试信息




'/var/lib/flatpak/exports/share'
'/home/hyuuko/.local/share/flatpak/exports/share'


# 从 flathub 仓库系统级地安装软件
flatpak install flathub name.of.app
# 从 flathub 仓库用户级地安装软件（安装到 $HOME/.var/app/）
flatpak install --user flathub name.of.app

flatpak info name.of.app
```

`flatpak remotes` 会列出你添加到系统中的软件仓库。此外，执行结果还表明了软件仓库的配置是 用户级(per-user)还是 系统级(system-wide)。

Flatpak app 们都自带沙箱，而且与宿主操作系统的其他部分隔离。
允许用户在同一个系统中安装同一应用的多个版本。
