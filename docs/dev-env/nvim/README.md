# Neovim 配置

- [nanotee/nvim-lua-guide: A guide to using Lua in Neovim](https://github.com/nanotee/nvim-lua-guide)
  - [glepnir/nvim-lua-guide-zh: https://github.com/nanotee/nvim-lua-guide chinese version](https://github.com/glepnir/nvim-lua-guide-zh)

Vim stands for Vi IMproved.

## 教程

- [Neovim - ArchWiki](https://wiki.archlinux.org/title/Neovim)
- [2022 年 vim 的 C/C++ 配置](https://martins3.github.io/My-Linux-Config/docs/nvim.html)
- 必看 [Neovim IDE from Scratch - Introduction (100% lua config) - YouTube](https://www.youtube.com/watch?v=ctH-a-1eUME&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ)
  - [LunarVim/Neovim-from-scratch: A Neovim config designed from scratch to be understandable](https://github.com/LunarVim/Neovim-from-scratch) 有很多分支，一步步地从零开始配置。packer, nvim-lspconfig
  - [LunarVim/nvim-basic-ide: This is my attempt at a basic stable starting point for a Neovim IDE.](https://github.com/LunarVim/nvim-basic-ide)
  - [Neovim IDE Crash Course](https://www.chrisatmachine.com/blog/category/neovim/01-ide-crash-course)
- [Learn Neovim The Practical Way. | by alpha2phi | Medium](https://alpha2phi.medium.com/learn-neovim-the-practical-way-8818fcf4830f#545a) 一系列的教程，逐个讲解
  - [alpha2phi/dotfiles](https://github.com/alpha2phi/dotfiles/tree/main/config/nvim)
- [nshen/learn-neovim-lua: Neovim 配置实战：从 0 到 1 打造自己的 IDE](https://github.com/nshen/learn-neovim-lua)
- http://github.com/theniceboy/nvim
  - [上古神器 Vim：从恶言相向到爱不释手 - 终极 Vim 教程 01 - 带你配置属于你自己的最强 IDE\_哔哩哔哩\_bilibili](https://www.bilibili.com/video/av55498503/)
  - [上古神器 Vim：进阶使用/配置、必备插件介绍 - 终极 Vim 教程 02 - 带你配置属于你自己的最强 IDE\_哔哩哔哩\_bilibili](https://www.bilibili.com/video/av55664166/)
  - [「妈妈不会告诉你的 Vim 技巧」 -Vim 终极教程 03 - 带你配置属于你自己的最强 IDE\_哔哩哔哩\_bilibili](https://www.bilibili.com/video/av56020134/)
  - [21 世纪最强代码编辑器 ：NeoVim ——就是这些设置让它变成了编辑器之鬼 【附配置与插件教程】\_哔哩哔哩\_bilibili](https://www.bilibili.com/video/av67091857/)
- [neovim IDE&使用技巧\_bilibili](https://space.bilibili.com/26319956/channel/collectiondetail?sid=361766)
  - https://github.com/ravenxrz/dotfiles/tree/master/nvim
  - https://www.youtube.com/watch?v=ctH-a-1eUME&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ
- [Awesome Neovim Setup From Scratch - Full Guide - YouTube](https://www.youtube.com/watch?v=JWReY93Vl6g) viml 配置，没有 lua
- [How to Configure Vim like VSCode - YouTube](https://www.youtube.com/watch?v=gnupOrSEikQ) Vim 的配置

## awesome

- 主题配色 [Trending vim color schemes | vimcolorschemes](https://vimcolorschemes.com/)
  - [joshdick/onedark.vim: A dark Vim/Neovim color scheme inspired by Atom's One Dark syntax theme.](https://github.com/joshdick/onedark.vim)
- [rockerBOO/awesome-neovim: Collections of awesome neovim plugins.](https://github.com/rockerBOO/awesome-neovim)
- [awesome-cheatsheets/vim.txt at master · skywind3000/awesome-cheatsheets](https://github.com/skywind3000/awesome-cheatsheets/blob/master/editors/vim.txt)

## 值得参考的配置

- [nvim-config | A modern Neovim configuration with full battery for Python, C++, Markdown, LaTeX, and more…](https://jdhao.github.io/nvim-config/) 这个配置用的内置 lsp client
- [glepnir/nvim: neovim configuration written in lua](https://github.com/glepnir/nvim)
- [ayamir/nvimdots: A well configured and structured Neovim.](https://github.com/ayamir/nvimdots)

## 如何入门 vim

- [你们的 vim 配置都换成 lua 了吗？ - 杨格尔的回答 - 知乎](https://www.zhihu.com/question/445290918/answer/2354292342)
- [Learn Neovim The Practical Way. | by alpha2phi | Medium](https://alpha2phi.medium.com/learn-neovim-the-practical-way-8818fcf4830f#545a) 一系列的教程，逐个讲解

步骤：

1. 首先了解一下，为什么要学 vim
2. 学习 vim 基本操作 `:Tutor`，配合速查表使用 vim 几天，熟悉操作
3. 看一下 ytb 的视频 Neovim-from-scratch，插件一个一个地加，查看插件主页，看看效果
4. 使用 LunarVim
5. 参照 LunarVim，自己配置一个
6. vim 进阶，刻意练习，熟练操作

## 特性

[lsp](https://neovim.io/doc/lsp/), async, [tree-sitter](https://neovim.io/doc/treesitter/), float window

neovim coc.nvim clangd

- [ ] built-in lsp 是个啥？https://climatechangechat.com/setting_up_lsp_nvim-lspconfig_and_perl_in_neovim.html

Neovim 0.5 can for instance load its configuration from an `init.lua` instead of the traditional `init.vim`.
`:help lua` & [nanotee/nvim-lua-guide: A guide to using Lua in Neovim](https://github.com/nanotee/nvim-lua-guide)

## Neovim 教程

- 在线交互式学习 Vim [Interactive Vim tutorial](https://www.openvim.com/tutorial.html)
- Vim 速查表 [Vim Cheat Sheet](https://vim.rtorr.com/lang/zh_cn)
- 迷宫游戏 https://vim-adventures.com/

`:help` 打开 help.txt 界面，或者使用 `nvim -c help` 命令，看到的内容和 [Nvim documentation: help](https://neovim.io/doc/user/) 一样。在 help.txt 界面里，在蓝色的 tag 上 `Ctrl ]` 可以跳转进该链接，用 `Ctrl O` 返回。文档在 `/usr/share/nvim/runtime/doc/`。`:help usr_01.txt` 打开 usr_01.txt 这个文档。

`:Tutor` 打开 30 分钟交互式基础操作教程，或者使用 `nvim -c Tutor` 命令。教程在 `/usr/share/nvim/runtime/tutor/`。

对于 Vim，交互式教程通过 `vimtutor` 命令打开。文档位置在 `/usr/share/vim/vim82/doc/`

### built-in LSP client

Neovim contains a _built-in LSP client_ and the `nvim-lspconfig` plugin provides common configurations for it.

https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/manual.adoc#nvim-lsp
https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd

### coc.nvim

到目前为止，内置的 lsp 和 coc.nvim 的完善度还是存在一些差距。

coc.nvim 用的是微软的 LSP client（需要 nodejs）？

- [coc.nvim 插件体系 - 介绍 - 知乎](https://zhuanlan.zhihu.com/p/65524706)

coc.nvim 和 markdown.preview 两个插件需要使用 Node.js 编译。

用 fnm（应该能用 zinit 管理）管理 nodejs
archlinux 安装的 npm 和 yarn 有对 nodejs 的依赖，咋办。。

## 开始配置

```bash
sudo pacman -S --needed gcc clang llvm
sudo pacman -S --needed wget curl git bear ripgrep cmake

sudo pacman -S --needed neovim
```

nodejs npm yarn 的安装见 [本文件夹下的 README.md](./README.md)

在 vim 里 `:set 选项` 好像是临时的

```bash
# 安装到 /usr/share/nvim/site/pack/packer/start/packer.nvim/
❯ paru nvim-packer-git

# x11 clipboard 和 neovim 之间的复制
xclip 和 xsel 选哪个？

# FiraCode Nerd Font
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Regular/complete
nerd-fonts-fira-code

# 打了 Nerd fonts 补丁 的 Sarasa Mono SC Nerd 字体
# https://github.com/laishulu/Sarasa-Mono-SC-Nerd/releases
```

其实很多插件已经开始只提供 lua 的配置方法了

```lua
-- You must run this or `PackerSync` whenever you make changes to your plugin configuration
-- Regenerate compiled loader file
:PackerCompile
-- Remove any disabled or unused plugins
:PackerClean
-- Clean, then install missing plugins
:PackerInstall
-- Clean, then update and install plugins
:PackerUpdate
-- Perform `PackerUpdate` and then `PackerCompile`
:PackerSync
-- Loads opt plugin immediately
:PackerLoad completion-nvim ale
--
:PackerStatus
--
:PackerSnapShot
```

**关于 data 目录**

`~/.local/share/nvim/site/pack/packer`

start 目录的，启动时加载
opt（optional？） 目录的，lazy 加载

- [ ] 修改选项后，如何重新加载配置？

**LSP**

:LspInfo 查看连接到当前 buffer 的 lsp
:LspInstallInfo

gd 跳转定义
shift K 查看函数/变量信息

**numToStr/Comment.nvim**
gcc 注释一行
选择多行，gc 注释

**font**
字体有个问题，目前图标只占一格。
TODO 将图标调整为占两格

**buffer/window/tab**
buffer 像是 vscode 中的 tab，是一个被加载到内存中的文件
window 举个例子就是 :vsplit 可以打开一个垂直
tab 我觉得像是桌面的虚拟窗口？

总之一个 tab 可以有多个 window，一个 windows 可以包含多个 buffer

:Bdelete 关闭 buffer
:bdelete 关闭 buffer
区别？

**null-ls**
格式化，
需要安装好 stylua, prettier
