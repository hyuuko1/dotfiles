- [Hardware video acceleration - ArchWiki](https://wiki.archlinux.org/title/Hardware_video_acceleration)
- [HardwareVideoAcceleration - Debian Wiki](https://wiki.debian.org/HardwareVideoAcceleration)

## VA-API

- VA-API - Supported on Intel, AMD, and NVIDIA (only via the open-source Nouveau drivers). Widely supported by software, including Kodi, VLC, MPV, Chromium, and Firefox. Main limitation is lacking any support in the proprietary NVIDIA drivers.
- VDPAU - Supported fully on AMD and NVIDIA (both proprietary and Nouveau). Supported by most desktop applications like Kodi, VLC, and MPV, but has no support at all in Chromium or Firefox. Main limitations are poor and incomplete Intel support and not working with browsers for web video acceleration.

VDPAU 不支持浏览器的视频硬解，所以选择 VA-API。

对于 Intel 核显 `paru -S intel-media-driver`

对于 AMD GPU

```bash
# VA-API
libva-mesa-driver lib32-libva-mesa-driver

# opengl
mesa lib32-mesa
```

Note:
You may need to force your application to use AMDGPU PRO Vulkan Driver.
HEVC encoding may not be available on GPUs Older than Navi（RDNA？）.
支持情况见表 https://wiki.archlinux.org/title/Hardware_video_acceleration#VA-API_drivers

```bash
# 这个包提供 vainfo 命令
❯ paru -S libva-utils
# 检查 VA-API 的设置
❯ vainfo
vainfo: VA-API version: 1.14 (libva 2.14.0)
vainfo: Driver version: Mesa Gallium driver 22.1.1 for AMD RENOIR (LLVM 13.0.1, DRM 3.46, 5.18.5-arch1-1)
vainfo: Supported profile and entrypoints
      VAProfileMPEG2Simple            : VAEntrypointVLD
      VAProfileMPEG2Main              : VAEntrypointVLD
      VAProfileVC1Simple              : VAEntrypointVLD
      VAProfileVC1Main                : VAEntrypointVLD
      VAProfileVC1Advanced            : VAEntrypointVLD
      VAProfileH264ConstrainedBaseline: VAEntrypointVLD
      VAProfileH264ConstrainedBaseline: VAEntrypointEncSlice
      VAProfileH264Main               : VAEntrypointVLD
      VAProfileH264Main               : VAEntrypointEncSlice
      VAProfileH264High               : VAEntrypointVLD
      VAProfileH264High               : VAEntrypointEncSlice
      VAProfileHEVCMain               : VAEntrypointVLD
      VAProfileHEVCMain               : VAEntrypointEncSlice
      VAProfileHEVCMain10             : VAEntrypointVLD
      VAProfileHEVCMain10             : VAEntrypointEncSlice
      VAProfileJPEGBaseline           : VAEntrypointVLD
      VAProfileVP9Profile0            : VAEntrypointVLD
      VAProfileVP9Profile2            : VAEntrypointVLD
      VAProfileNone                   : VAEntrypointVideoProc
```

`VAEntrypointVLD` 表示显卡可以解码该格式，`VAEntrypointEncSlice` 表示可以编码该格式。

`VAProfileHEVCMain10` 是指 H.265/HEVC 10bit？

Although the video driver should automatically enable hardware video acceleration support for both VA-API and VDPAU, it may be needed to configure VA-API/VDPAU manually.

```
[ 6.765] (II) AMDGPU(0): [DRI2] DRI driver: radeonsi
[ 6.765] (II) AMDGPU(0): [DRI2] VDPAU driver: radeonsi
```

可以通过配置环境变量强制更改使用的驱动（默认是 radeonsi `/usr/lib/dri/radeonsi_drv_video.so`）

## Chromium

- [Chromium#Hardware video acceleration - ArchWiki](https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration)
- 🌟 [enable-chromium-hevc-hardware-decoding/README.zh_CN.md](https://github.com/StaZhu/enable-chromium-hevc-hardware-decoding/blob/main/README.zh_CN.md)

Note: The `chromium-flags.conf` file and the accompanying custom launcher script are specific to the Arch Linux chromium package. For google-chrome and google-chrome-dev, use `chrome-flags.conf` and `chrome-dev-flags.conf` instead.

根据 `/usr/bin/microsoft-edge-stable`，使用 `~/.config/microsoft-edge-stable-flags.conf`

https://bbs.archlinux.org/viewtopic.php?id=244031&p=26

```conf
--use-vulkan
--use-gl=desktop
--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization
--ignore-gpu-blocklist
--enable-gpu-rasterization
--enable-zero-copy
--disable-features=UseChromeOSDirectVideoDecoder
```

**注意！对于 intel 核显，不能用 `--use-gl=desktop`！用下面的这个配置即可：**

--use-gl=desktop 和 --use-vulkan 不能同时用

```conf
--use-vulkan
#--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization
--enable-features=VaapiVideoEncoder,VaapiVideoDecodeLinuxGL,CanvasOopRasterization
--ignore-gpu-blocklist
--enable-gpu-rasterization
--enable-zero-copy
--disable-features=UseChromeOSDirectVideoDecoder
```

```conf
# https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration

--enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks
# --enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization
--disable-features=UseChromeOSDirectVideoDecoder
# --use-gl=egl
--use-vulkan

# Force GPU acceleration
--ignore-gpu-blocklist
--enable-gpu-rasterization
--enable-zero-copy
# prevent GPU workaround from being used
--disable-gpu-driver-bug-workarounds

# Native Wayland support
--ozone-platform-hint=auto
```

https://source.chromium.org/chromium/chromium/src/+/main:testing/variations/fieldtrial_testing_config.json

Bilibili 也不支持 Chrome 浏览器和使用 Chromium 内核的 Edge 浏览器硬解码，仅支持老版 Edge 浏览器或 macOS 下的 Safari 浏览器硬解码 HEVC，所以我们需要更改 UA。
选择 Safari 和 Mac OS，然后点击最新版本，再点击 Apply(all windows)即可。
现在已经完成了 UA 的设置，不过这个设置是全局的，我们只想要在 B 站中启用 UA。扩展程序管理面板，找到刚刚安装的 User-Agent Switcher and Manager，点击详细信息，选择在特定站点上，填入 `https://*.bilibili.com/*`
重启浏览器，打开 4k 视频 https://www.bilibili.com/video/BV1Vv4y1g7xY 没法切换到 hevc。。。
但是，实测 edge for linux 可以支持硬解 h264。

https://www.reddit.com/r/MicrosoftEdge/comments/mv2lcm/hardwareaccelerated_video_decoding_on_linux/h1cg9z9/
https://www.reddit.com/r/MicrosoftEdge/comments/qab7u4/microsoft_edge_linux_hardware_acceleration/hh6lys1/

**测试**

```bash
# For Intel Gen 8+ hardware
paru -S intel-media-driver

paru -S intel-gpu-tools
sudo intel_gpu_top
```

如果是硬解，那么 Video 和 VideoEnhance 不会是 0%

- 🌟 [Linux users can now enable hardware acceleration via VAAPI using Microsoft Edge Stable. Secret sauce in post. : r/GeForceNOW](https://www.reddit.com/r/GeForceNOW/comments/ynznkj/linux_users_can_now_enable_hardware_acceleration/)
- 🌟 [How To Enable Hardware Accelerated Video Decode In Google Chrome, Brave, Vivaldi And Opera Browsers On Debian, Ubuntu Or Linux Mint - Linux Uprising Blog](https://www.linuxuprising.com/2021/01/how-to-enable-hardware-accelerated.html)

## firefox

- [在 Linux 平台的 Firefox 上启用 VA-API 的视频硬件解码 - 知乎](https://zhuanlan.zhihu.com/p/268401890)
  内容有些过时，有些多于的步骤
- [Firefox - ArchWiki](https://wiki.archlinux.org/title/Firefox#Hardware_video_acceleration)

1. 确保显卡正确配置了 VA-API
2. about:config
   `media.ffmpeg.vaapi.enabled` true
   `gfx.webrender.all` true

注意：即使支持 HEVC 但是仍然放不了（版权问题？）

**测试**
在开启/关闭 `media.ffmpeg.vaapi.enabled` 的两种情况下进行测试

方法一：`MOZ_LOG="PlatformDecoderModule:5" firefox-developer-edition 2>&1 | grep "VA-API"` 播放视频时有输出 `[RDD 53528: MediaPDecoder #1]: D/PlatformDecoderModule FFMPEG: VA-API Got one frame output with pts=2467000 dts=2484027 duration=33000 opaque=-9223372036854775808` 就说明对了！

方法二：通过 bili-evolved 下载 h264 格式的 4k b 站视频，保存后（建议再用 vlc 打开检查一下 codec 是否为 h264/avc），直接用 firefox 打开该视频，看 CPU 占用。（因为直接在 b 站看视频时会一边下载一边播放，影响 cpu 占用）
如果开了硬解，刚开始占用 4%，然后降到 0.4%
如果没开硬解，一直 4% 以上

## 关于编码

- [Video coding format - Wikipedia](https://en.wikipedia.org/wiki/Video_coding_format#List_of_video_coding_standards)
- [网页视频编码指南 - Web 媒体技术 | MDN](https://developer.mozilla.org/zh-CN/docs/Web/Media/Formats/Video_codecs)
- <https://caniuse.com/hevc>
  可以看到，firefox 不支持，safari 支持，
  Linux(Chrome >= 108.0.5354.0) 支持
  edge 只在 windows 上支持，并且需要在软件商店安装硬件解码器
- <https://caniuse.com/av1>
  firefox/chrome 完全支持，edge 需要在软件商店安装 AV1 Video Extension
- [Download video files encoded](https://www.elecard.com/videos)

H.265 supports up to 8192×4320

- h264/AVC(AVC1,MPEG-4) 压缩率很糟糕，2003 年的技术，大部分 gpu 都能硬解它
  - 支持解码的分辨率范围 16x16 to 4096x4906 pixels
  - 经实测，edge for linux 甚至都不支持 h264 的硬解！
- h265/HEVC
  - 专利费用高。
  - 2013 年的技术。目前的显卡基本都支持
- AV1
  - 谷歌，微软，Mozilla 和思科等多家大型 IT 公司发起了开放媒体联盟开发的，完全免版税。大多数软件都支持（Chrome/firefox）
  - 2018 年的技术，基本上只有最新的 gpu 支持。NVIDIA RTX 30 系列或 AMD Radeon RX 6000 系列

HEVC 和 AV1 的压缩率都差不多。
