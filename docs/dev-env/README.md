# 开发环境配置

## 参考

- [工欲善其事，必先利其器](https://martins3.github.io/My-Linux-Config/)

## 编辑器

### vscode

配置文件见[../vscode/settings.json](../vscode/settings.json)

```bash
# 让 vscode 通过 wayland 运行，缺点：无法使用输入法
❯ vim ~/.config/code-flags.conf
--enable-features=WaylandWindowDecorations
--ozone-platform-hint=auto
```

## Docker

- [Docker (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Docker_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [HTTP/HTTPS proxy - docker docs](https://docs.docker.com/config/daemon/systemd/)

```bash
# 安装 docker
sudo pacman -S --needed docker docker-compose
# 启动 docker
sudo systemctl start docker
# 或者设置开机自启并立即启动 docker
# sudo systemctl enable --now docker.service

# 将当前用户加入 docker 用户组以赋予当前用户使用 docker 的权限
# 需要注销重新登录才能生效
sudo usermod -aG docker $USER
```

接下来配置镜像地址，先在[阿里云](https://www.aliyun.com/)注册一个帐号，然后打开控制台的[容器镜像服务](https://cr.console.aliyun.com/cn-shenzhen/instances/mirrors)，点击左侧的镜像中心->镜像加速器，就可以看到专属加速器地址，再通过修改 daemon 配置文件`/etc/docker/daemon.json` 来使用加速器

```bash
sudo mkdir -p /etc/docker
sudo vim /etc/docker/daemon.json
```

填入：

```json
{
  "registry-mirrors": [
    "http://hub-mirror.c.163.com",
    "https://mirror.ccs.tencentyun.com",
    "https://换成你自己的.mirror.aliyuncs.com"
  ]
}
```

接下来再配置一下代理

```sh
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo vim /etc/systemd/system/docker.service.d/http-proxy.conf
```

填入：

```conf
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:7890"
Environment="HTTPS_PROXY=http://127.0.0.1:7890"
```

```bash
# 重启 docker 使配置生效
sudo systemctl daemon-reload
sudo systemctl restart docker
# 查看 docker 的代理、镜像等信息
docker info
```

## Rust

[hyuuko/dotfiles](https://github.com/hyuuko/dotfiles/tree/master/zsh/.config/zsh) 里包含环境变量和补全等配置，此处不再重复。

```bash
curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh
source ~/.cargo/env
# 安装 nightly 版工具链
rustup toolchain install nightly
# 默认 nightly
rustup default nightly
# rust-analyzer 需要这个
rustup component add rust-src

# 有以下几种方式安装 rust-analyzer
# 1. rustup +nightly component add rust-analyzer-preview，/usr/local/rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer
# 2. 或者 pacman -S rust-analyzer
# 3. 通过 vscode 安装，更新的最及时

# llvm-tools 安装在 ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/bin/ 还有 ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib/libLLVM-16-rust-1.71.0-nightly.so
rustup component add llvm-tools
# https://github.com/rust-embedded/cargo-binutils
# 让你可以用 cargo subcommand 的形式来调用 llvm-tools
cargo install cargo-binutils

# TODO rust-gdbgui 需要依赖 aur/python-gdbgui
# TODO cargo-cache
```

在 dotfiles 目录下，`stow rust` 生成 `~/.cargo/config.toml` 链接文件（请先确保 `~/.cargo` 目录已经被创建，否则被链接的就是 `.cargo` 目录）

**sccache**

`sudo pacman -S sccache` 安装 sccache，然后修改 `~/.cargo/config.toml`，`sccache --show-stats` 查看状态。

```toml
[build]
rustc-wrapper = "sccache"
```

**mold**

cargo build 时，实际上执行的是 rustc 命令，然后 rustc 编译后会使用 /usr/bin/cc 进行链接？
链接失败报错 `` error: linking with `cc` failed: exit status: 1 ``
cargo rustc 时，最后直接用 rust-lld 链接器

```toml
[target.'cfg(any(target_arch = "x86", target_arch = "x86_64", target_arch = "arm", target_arch = "aarch64", target_arch = "riscv64"))']
rustflags = ["-C", "link-arg=-fuse-ld=mold"]
```

```bash
❯ readelf -p .comment target/debug/demo

String dump of section '.comment':
  [     0]  mold 1.11.0 (cca255e6be069cdbc135c83fd16036d86b98b85e; compatible with GNU ld)
  [    50]  GCC: (GNU) 12.2.1 20230201
```

## C/C++

- [Using the mold linker for fun and 3x-8x link time speedups – Productive C++](https://www.productive-cpp.com/using-the-mold-linker-for-fun-and-3x-8x-link-time-speedups/)

```bash
# base-devel 依赖了 gcc make binutils make patch 等工具
pacman -S --needed base-devel
pacman -S --needed clang
pacman -S --needed gdb cmake bear

# lld 是 LLVM project 开发的一个链接器
pacman -S --needed lld
# mold 是 Rui Ueyama 开发的一个链接器，旨在取代现有的 Unix 平台的链接器
pacman -S --needed mold
# 性能 ld.mold > ld.lld > ld.gold > ld.bfd
# gcc 默认使用的 /usr/bin/ld 是 bfd
# gold 只能链接 ELF format object file，而 bfd 可以链接很多种类型的 object file
# lld 支持 ELF (Unix), PE/COFF (Windows), Mach-O (macOS) and WebAssembly
#
# gcc/clang 选项 -fuse-ld=mold 需要有 /usr/bin/ld.mold
# 如果没有 ld.mold 就 --ld-path=/path/to/mold 试试

# 手册
pacman -S --needed man-db man-pages man-pages-zh_cn
# 这个是用来编译器开发的？可以不安装
pacman -S --needed llvm
# 如果要写 32 位的程序，就安装这个
pacman -S --needed lib32-gcc-libs
```

## Node

node 的版本迭代太快了，用 node 版本管理器就会舒服很多。
听说 nvm 有一些比较严重的问题，比如 nvm 与 prefix 不兼容，还有就是慢。
听说 fnm 切换 session 的速度比 nvm 快很多。

还有一些其他的工具，比如 volta、n

volta 貌似还不支持锁 pnpm 版本

在 `~/.zshrc` 填入以下内容：

```bash
# 用 zinit 延后加载 fnm https://github.com/Schniz/fnm
# --use-on-cd 的作用：当文件夹下有 .node-version 或 .nvmrc 文件时，自动运行 fnm use 切换版本
zinit wait lucid light-mode blockf \
    as"program" from"gh-r" bpick"*linux*" atclone"./fnm completions --shell zsh >_fnm" atpull"%atclone" \
    atload'eval "$(./fnm env --use-on-cd --node-dist-mirror https://npmmirror.com/mirrors/node/)"' \
    Schniz/fnm
```

fnm 用法简记：

```sh
# 查看远程 Node 版本
fnm ls-remote
# 安装最新版本
fnm install --latest
# 安装最新的 lts 版本
fnm install --lts
# 安装指定的 lts 版本
fnm install lts/Gallium
# 如果当前目录下有 .node-version 或 .nvmrc 文件，则安装对应版本
fnm install

# 列出本地的 Node 版本
fnm ls
# 设置默认 Node 版本
fnm default lts-latest
# 查看当前 Node 版本
fnm current
# 使用参数或者 .node-version 或 .nvmrc 文件中的版本
fnm use

# 安装 yarn（不用安装 nodejs 包）
sudo pacman --assume-installed nodejs -S yarn

# 给两个 node 的包管理器换源
npm config set registry https://registry.npmmirror.com
yarn config set registry https://registry.npmmirror.com
# 检查
yarn config get registry && npm config get registry
```

- [npmmirror 中国镜像站](https://npmmirror.com/)
- [NPM 镜像\_NPM 下载地址\_NPM 安装教程-阿里巴巴开源镜像站](https://developer.aliyun.com/mirror/NPM?spm=a2c6h.13651102.0.0.30da1b11pNohuT)

### 版本管理工具对比

- [A Comparison of Node.js Environment Managers - Honeybadger Developer Blog](https://www.honeybadger.io/blog/node-environment-managers/)
  nvm n fnm volta asdf

**nvm** 的缺点：只支持符合 POSIX 的 shell，如 bash 或 zsh，不支持 fish shell。对 Windows 的支持也缺乏

**n** 命令是作为一个 node 的模块而存在，而 nvm 是一个独立于 node/npm 的外部 shell 脚本，因此 n 命令相比 nvm 更加局限

**fnm** 的原理是为每个 shell 创建一个符号链接，比如 `/run/user/1000/fnm_multishells/31683_1658460503210 -> ~/.fnm/aliases/default/`，然后将 `/run/user/1000/fnm_multishells/31683_1658460503210/bin` 放进 PATH 环境变量。
更改目录时，可以自动根据 .node_version 和 .nvmrc 切换。
和 nvm 的行为很像，可以认为是 nvm plus

**volta**
原理：通过 shims（例：名为 node 符号链接指向/usr/bin/volta-shim，volta-shim 根据符号链接的名字知道了要调用 node，然后决定 node 的版本）。
也就是说 node 版本的确定被推迟到了真正执行 node 命令时。
volta 还可以安装 npm/yarn
换源需要修改 ~/.volta/hooks.json

```json
{
  "node": {
    "index": {
      "prefix": "https://npmmirror.com/mirrors/node/"
    },
    "latest": {
      "prefix": "https://npmmirror.com/mirrors/node/"
    },
    "distro": {
      "template": "https://registry.npmmirror.com/-/binary/node/v{{version}}/node-v{{version}}-{{os}}-{{arch}}.tar.gz"
    }
  }
}
```

```bash
# 安装 LTS latest
volta install node
# 安装 latest
volta install node@latest
# 每次 install 的都会自动被设为 default
```

但是还是有一些缺点 [Goodbye Volta? - DEV Community](https://dev.to/jcayzac/goodbye-volta-494e)

**asdf** 还能管理 ruby 等语言

### 包管理

npm 是 nodejs 安装包自带的，各版本的 nodejs 安装包附带的 npm 的版本可能不同，不同版本的 npm 支持的 nodejs 的版本范围也可能不同。

npm 的一些命令

- `npm prefix`
  - 打印出最近的包含 package.json 或 node_modules 的目录的路径
  - `--location=global` 选项。打印出 node 的安装位置，比如 `/home/用户名/.fnm/node-versions/v版本号/installation/`
- `npm root`
  - 打印出 node_modules 目录的路径
  - `--location=global` 选项。打印出全局安装的软件包被安装到的位置
- `npm list`
  - 列出本地安装的软件包
  - `--location=global` 选项。列出全局安装的软件包
- `npm install <package-name>`
  - 软件包被安装到当前目录下的 node_modules 子文件夹下。在这种情况下，npm 还会在当前文件夹中存在的 package.json 文件的 dependencies 属性中添加 lodash 条目。
  - `--location=global` 选项。全局安装到 `npm root --location=global` 处，比如 `/home/用户名/.fnm/node-versions/v版本号/installation/lib/node_modules/`，npm 自身也在这个目录下

注意更新全局软件包会使所有的项目都使用新的版本，这可能会导致维护方面的噩梦，因为某些软件包可能会破坏与其他依赖项的兼容性等。
当程序包提供了可从 shell（CLI）运行的可执行命令、且可在项目间复用时（比如 vue-cli），则该程序包应被全局安装。

- [Node.js Corepack - 简书](https://www.jianshu.com/p/c239ed5dedd6)

除了 npm，还有一些包管理工具，比如 yarn 和 pnpm。在 v16.9.0 和 v14.19.0 之后的版本里，nodejs 自带 corepack，corepack 可以帮助管理包装管理器的版本，并自带了 yarn 和 pnpm。Corepack 需要和 package.json 的 "packageManager" 属性配合使用。这样能够做到 Yarn 项目不能使用 pnpm，pnpm 项目中无法使用 Yarn。

```bash
# 启用 nodejs 自带的 yarn 和 pnpm
#
❯ corepack enable
```

不同版本的 yarn/pnpm 所支持 node 的版本也不同。所以不建议用 pacman 安装 yarn/pnpm（需要注意使用 pacman 安装的 yarn 全局安装软件包时，会安装到 `~/.local/share/yarn/global/node_modules`）

软件包 [npm](https://www.npmjs.com/)

[Node.js 中文入门教程](http://nodejs.cn/learn)

- [ ] ~/.cache/yarn/ 是什么
- [ ] [antfu/ni: 💡 Use the right package manager](https://github.com/antfu/ni)
- [ ] yarn 和 pnpm 用法

typescript 用 pacman 安装比较好，毕竟只是用来将 ts 编译成 js，和 node 无关。

```bash
❯ paru -S typescript ts-node

# TODO
❯ paru -S deno typescript-language-server
```

## VMware

```bash
sudo pacman -S --needed vmware-workstation
sudo pacman -S --needed linux-headers            # 可选依赖项，模块编译所需
sudo modprobe -a vmw_vmci vmmon                  # 加载 vmw_vmci 和 vmmon 内核模块
sudo systemctl enable --now vmware-networks      # 启用虚拟机网络
sudo systemctl enable --now vmware-usbarbitrator # 启用 vmware 的 usb 设备连接
```

## Java

```bash
sudo pacman -S --needed jdk8-openjdk openjdk8-doc openjdk8-src
sudo archlinux-java set java-8-openjdk

sudo pacman -S --needed intellij-idea-ultimate-edition intellij-idea-ultimate-edition-jre
```

推荐通过以下三种方式之一获得免费的 JetBrains 全套产品许可证，大概两周就能申请通过：

- 通过 GitHub 学生认证，获取 [GitHub Student Developer Pack](https://education.github.com/pack)，然后[用 GitHub 账户申请 JetBrains 的免费许可证](https://www.jetbrains.com/shop/eform/students/github/auth)
- [使用学校邮箱申请](https://www.jetbrains.com/shop/eform/students)，如果失败，这可能是因为你的学校进黑名单了
- [通过你的开源项目申请](https://www.jetbrains.com/shop/eform/opensource)

## MariaDB

- [MariaDB - ArchWiki](https://wiki.archlinux.org/index.php/MariaDB)

```sh
sudo pacman -S --needed mariadb

sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb.service

# 创建密码（如果不创建，可以直接 mysql 进去）
sudo mysqladmin -u root password "new_password"
# 进入数据库，例如 mysql -u root -p123456
mysql -u root -pnew_password
```

## TEX Live

```sh
sudo pacman -S texlive-most texlive-lang

[改一下 cpan 的镜像源](https://mirrors.tuna.tsinghua.edu.cn/help/CPAN/)，再来安装一些模块

# 直接从 archlinux 软件源安装比较快
sudo pacman -S perl-log-log4perl
# 其他的模块 archlinux 软件源里没有，需要从 cpan 的源里下载安装，比较慢
cpan Log::Dispatch::File
cpan YAML::Tiny
cpan File::HomeDir
cpan Unicode::GCString
```

## Python

`~/.pip/pip.conf`

```conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
```
