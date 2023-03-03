重要：[How to remove nix（](https://github.com/NixOS/nix/issues/1402#issuecomment-312496360)

- [Learn](https://nixos.org/learn.html)
- Nix
  - [Nix Package Manager Guide](https://nixos.org/manual/nix/stable/)
  - [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)
- NixOS
  - [NixOS Wiki](https://nixos.wiki/)
  - [NixOS Manual](https://nixos.org/manual/nixos/stable/)
  - [NixOS/nixpkgs: Nix Packages collection](https://github.com/NixOS/nixpkgs)
  - [Packages search for NUR](https://nur.nix-community.org/)
- [Nix/NixOS 镜像使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/nix/)
- [NixOS Images 下载](https://mirrors.tuna.tsinghua.edu.cn/nixos-images/)

> NixOS 是独立开发的 GNU/Linux 发行，它旨在改进系统配置管理的现状。在 NixOS 中，整个操作系统，包括内核、应用程序、系统软件包、配置文件，统统都由 Nix 包管理器来创建。Nix 将所有软件包以彼此分离的方式进行存储，因此就不存在/bin、/sbin、/lib、/usr 之类的目录；相反，所有软件包都保存在/nix/store 中。NixOS 的其他创新特色包括可靠升级、回滚、可重现的系统配置、二进制代码基于源文件的管理模型、多用户包管理。尽管 NixOS 是一份研究性项目，它是一份功能性的及可用的操作系统，能进行硬件检测，使用 KDE 作为缺省桌面，并采用 systemd 进行系统服务管理。
>
> [DistroWatch.com: NixOS](https://distrowatch.com/table.php?distribution=nixos)

- 别人的配置
  - https://github.com/dramforever/config
  - https://github.com/wineee/nixos-config
- 介绍 NixOS 的文章
  - [NixOS 系列（一）：我为什么心动了 | Lan Tian @ Blog](https://lantian.pub/article/modify-website/nixos-why.lantian/)
  - [NixOS 系列（二）：基础配置，Nix Flake，和批量部署 | Lan Tian @ Blog](https://lantian.pub/article/modify-website/nixos-initial-config-flake-deploy.lantian/)
  - [NixOS 系列（三）：软件打包，从入门到放弃 | Lan Tian @ Blog](https://lantian.pub/article/modify-computer/nixos-packaging.lantian/)
  - [如何评价 NixOS? - bobby285271 的回答 - 知乎](https://www.zhihu.com/question/56543855/answer/491883533)
    - https://github.com/bobby285271/nixos-config 这个不错

## 从 ArchLinux 安装 NixOS

https://wiki.archlinux.org/title/Nix_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

- [2.5.4. Installing from another Linux distribution](https://nixos.org/manual/nixos/stable/index.html#sec-installing-from-other-distro)

```bash
curl -L https://nixos.org/nix/install | sh
. ~/.nix-profile/etc/profile.d/nix.sh
mkdir ~/.config/nix
echo 'substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/' > ~/.config/nix/nix.conf

nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-21.05 nixpkgs
nix-channel --list

nix-env -f '<nixpkgs>' -iA nixos-install-tools

sudo `which nixos-generate-config` --root /run/media/hyuuko/NixOS/


sudo PATH="$PATH" NIX_PATH="$NIX_PATH" `which nixos-install` --root /run/media/hyuuko/NixOS/
```

```
正在保存至: “/tmp/nix-binary-tarball-unpack.wVkkDXQ8Md/nix-2.4-x86_64-linux.tar.xz”

/tmp/nix-binary-tarball-unpack.wVkkDXQ8Md/nix-2.4-x86 100%[=======================================================================================================================>]  27.12M  9.71MB/s  用时 2.8s

2021-11-15 00:11:02 (9.71 MB/s) - 已保存 “/tmp/nix-binary-tarball-unpack.wVkkDXQ8Md/nix-2.4-x86_64-linux.tar.xz” [28432840/28432840])

Note: a multi-user installation is possible. See https://nixos.org/nix/manual/#sect-multi-user-installation
performing a single-user installation of Nix...
directory /nix does not exist; creating it by running 'mkdir -m 0755 /nix && chown hyuuko /nix' using sudo
copying Nix to /nix/store...

installing 'nix-2.4'
building '/nix/store/r86vbqhkbikv9sf9vlawcmf13d44f5za-user-environment.drv'...
unpacking channels...
modifying /home/hyuuko/.bash_profile...
modifying /home/hyuuko/.zshenv...

Installation finished!  To ensure that the necessary environment
variables are set, either log in again, or type

  . /home/hyuuko/.nix-profile/etc/profile.d/nix.sh

in your shell.
```
