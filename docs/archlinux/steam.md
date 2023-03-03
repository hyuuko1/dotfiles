- [游戏娱乐 | archlinux 简明指南](https://arch.icekylin.online/apps/play.html)
- [Steam - ArchWiki](https://wiki.archlinux.org/title/Steam#Installation)
- [Steam/Troubleshooting - ArchWiki](https://wiki.archlinux.org/title/Steam/Troubleshooting)

本文将安装 steam，并使用 Proton-GE 运行游戏千恋＊万花。

```bash
# 安装 AMD GPU 驱动，以及 OpenGL 驱动
paru -S --needed xf86-video-amdgpu mesa lib32-mesa

# 安装 steam
paru steam
# 安装 proton-ge（官方 proton 的派生版本，支持的游戏更多）
paru proton-ge-custom-bin

# 安装 proton-ge 的可选依赖
paru -S --needed winetricks
```

安装的游戏在 `~/.local/share/Steam/steamapps/common/`

左上 Steam->设置->Steam Play，勾选`为所有其他产品启用 Steam Play`，选择 `Proton-GE`，确定，重启 Steam。

可以在 [ProtonDB](https://www.protondb.com/) 查询 proton 支持的游戏。

可以 Windows ArchLinux 双系统共用一个 SteamLibrary。
XXX 我在 ArchLinux 上启动在 Windows 上安装的千恋万花时，游戏窗口都出不来。但是在 ArchLinux 上安装该游戏时，可以成功启动。

## 千恋＊万花

- [ProtonDB | Game Details for Senren＊Banka](https://www.protondb.com/app/1144400)
- [proton 环境变量](https://github.com/GloriousEggroll/proton-ge-custom#modification)

设置 `PROTON_USE_WINED3D` 环境变量解决全屏时黑屏的问题：库->千恋＊万花->设置->属性->通用->启动选项。填入 `PROTON_USE_WINED3D=1 %command%` 以使用基于 OpenGL 的 wined3d，而非基于 Vulkan 的 DXVK for d3d11 和 d3d10。

```bash
# 据说需要安装 Windows Media Player 11 才可以在游戏中播放视频（例如OP/ED）
# 实测不需要
# TODO protontricks 可以用于 proton-ge 吗
protontricks 1144400 wmp11
```

- 存档位置 `~/.local/share/Steam/steamapps/compatdata/1144400/pfx/drive_c/users/steamuser/AppData/Roaming/YuzuSoft/SenrenBanka/`
- 补丁位置 `~/.local/share/Steam/steamapps/common/SenrenBanka/`
