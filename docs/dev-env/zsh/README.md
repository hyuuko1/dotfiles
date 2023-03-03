- [Zsh 开发指南](https://zshguide.readthedocs.io/zh/latest/)
- [A User's Guide to ZSH](https://zsh.sourceforge.io/Guide/)
- [ZSH - Documentation](https://zsh.sourceforge.io/Doc/)
  - 建议通过各种 index 进行快速查找
- [zsh 系列教程 - Aloxaf's Blog](https://www.aloxaf.com/categories/zsh-%E7%B3%BB%E5%88%97%E6%95%99%E7%A8%8B/)

```bash
# 详细模式，打印执行过的脚本
zsh -v

source 会先在当前目录查找
. 不查找当前目录
```

## Zsh Completion System

- [Zsh Documentation: 20 Completion System](https://zsh.sourceforge.io/Doc/Release/Completion-System.html)

Zsh has two completion systems, the old `compctl` and the more recent `compsys`.
compsys is a collection of Zsh functions. `/usr/share/zsh/functions/Completion/`
其中就包括 compinit, compinstall, cpmdump 等等

To initialize the completion for the current Zsh session, you’ll need to call the function compinit.

`autoload -U compinit; compinit`

The autoload command load a file containing shell commands. To find this file, Zsh will look in the directories of the Zsh file search path, defined in the variable $fpath, and search a file called compinit.
When compinit is found, its content will be loaded as a function. The function name will be the name of the file. You can then call this function like any other shell function.
在此处，`/usr/share/zsh/functions/Completion/compinit` 文件被加载为一个函数

With the `-U` flag, alias expansion is suppressed when the function is loaded. （避免有个 alias 也叫 compinit 的情况）

autoload 只是加载函数，并未执行

可以用 shell function `compinstall` 来进行配置，写进 .zshrc

completer function 是名为 `_命令` 的函数，通常是通过加载同名的文件而来的

When you type a command in Zsh and hit the `TAB` key, a completion is attempted depending on the context. This context includes:

- What command and options have been already typed at the command-line prompt.
- Where the cursor is.

The context is then given to one or more completer functions which will attempt to complete what you’ve typed. Each of these completers are tried in order and, if the first one can’t complete the context, the next one will try. When the context can be completed, some possible matches will be displayed and you can choose whatever you want.
A warning is thrown if none of the completers are able to match the context.

### zstyle

You can configure many aspects of the completion system using the zsh module zstyle.

###

- compinit 的调用位置放哪？
  - 貌似 zstyle 和 setopt 的前面或后面都行。但对 `_comp_options` 的修改必须在 compinit 后面，因为 `_comp_options` 在 compinit 时才被定义
  - 对 fpath 的修改必须在 compinit 前面
- [ ] .zcompdump autoload 了一些 `/usr/share/zsh/site-functions/`（软件包自带的）里的。还 autoload 了很多完全不需要的函数（`/usr/share/zsh/functions/Completion/` 里的，zsh 安装包自带的）
- [ ] 按 TAB 补全时，zsh-autosuggestions 显示的灰色提示没有消失
  - 现在好像突然解决了？貌似是 `/usr/share/fzf/completion.zsh` 的缘故
- 如果某个命令的补全没用，如何调试？
  - 看看是否存在 `_命令` 函数，如果没有，说明该 `_命令` 文件没有被加载
  - 此时查看一下 `~/.config/zsh/.zcompdump`，删除试试 `rm -f ~/.config/zsh/.zcompdump*`
- [ ] ls 补全的候选的目录是红色的。需要修改 $ZDOTDIR/snippets/completion.zsh 调整选项
- [ ] blockf 是如何实现的？
  - 插件内进行 fpath+= 时，创建到该文件的链接。
  - 但是仍然有 `/home/hyuuko/.zfunc` `/home/hyuuko/.config/zsh/zinit/plugins/_local---zinit`
- [ ] zsh/.config/zsh/zinit/snippets/OMZ::plugins 是啥？zsh/.config/zsh/zinit/snippets/plugins 是啥？
- 如果删除了 `zsh/.config/zsh/zinit/plugins/_local---zinit`，该文件夹又会自动生成回来，但是如果也把 `_init` 补全删了，用 `zinit creinstall _local/zinit` 命令安装回来。
- `zinit creinstall $HOME/.zfunc` 安装补全
- 别用 `OMZL::completion.zsh`

###

如果在 wait 插件处，通过 src"" 来调用 e.zsh 就会出问题。。
而且在插件里面调用 zinit 也会出问题。

/home/hyuuko/.config/zsh/.zcompdump 的加载耗时 50ms（正常情况下 1ms）
并且：

```
❯ ls 按下tab
_tags:comptags:67: no tags registered
_requested:comptags:8: no tags registered
_next_label:comptags:8: no tags registered
```

.zcompdump 完全一样

总结：多用 atload

- 现象
  - .zcompdump 加载太慢（.zcompdump 并未重复生成）
  - 对 fpath 的修改不生效

## history

## prompt

[Bash Shell: Take Control of PS1, PS2, PS3, PS4 and PROMPT_COMMAND](https://www.thegeekstuff.com/2008/09/bash-shell-take-control-of-ps1-ps2-ps3-ps4-and-prompt_command/)

PS2 是命令为多行时使用的提示符。比如 PS1 为 `>>> `，PS2 为 `... ` 时：

```bash
>>> pacman -S zsh \
... bash \
... fish
```

`/etc/pacman.d/hooks/starship-init.hook`

```conf
[Trigger]
Type = Package
Operation = Install
Operation = Upgrade
Target = starship

[Action]
Description = Updating $ZDOTDIR/snippets/starship-init.zsh...
When = PostTransaction
Exec = /usr/bin/zsh -c 'HOME=/home/hyuuko; /usr/bin/starship init zsh --print-full-init | sed "s/^PROMPT2=\"\$(.*\"$/PROMPT2=\"$(/usr/bin/starship prompt --continuation)\"/" >! $HOME/.config/zsh/snippets/starship-init.zsh'
```
