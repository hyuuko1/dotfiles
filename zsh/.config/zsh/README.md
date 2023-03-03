```bash
# 平均启动只需要 4.3 ms
❯ hyperfine "zsh -i -c exit" --warmup 3 --shell=none
Benchmark 1: zsh -i -c exit
  Time (mean ± σ):       4.3 ms ±   0.9 ms    [User: 2.7 ms, System: 1.4 ms]
  Range (min … max):     2.2 ms …   6.3 ms    723 runs
```

- zsh 框架大全 [unixorn/awesome-zsh-plugins: A collection of ZSH frameworks, plugins, themes and tutorials.](https://github.com/unixorn/awesome-zsh-plugins)
- [zdharma-continuum/zinit](https://github.com/zdharma-continuum/zinit)
- [Zinit Wiki](https://zdharma-continuum.github.io/zinit/wiki/)
- zinit 配置样例 [zdharma-continuum/zinit-configs: Real-world configuration files (basically zshrc-s) holding Zinit (former Zplugin) invocations](https://github.com/zdharma-continuum/zinit-configs)
- zinit 配置样例 [Github Binary Recipes · zdharma-continuum/zinit Wiki](https://github.com/zdharma-continuum/zinit/wiki/Github-Binary-Recipes)
- [zsh 启动速度慢的终极解决方案 - Aloxaf 的文章 - 知乎](https://zhuanlan.zhihu.com/p/98450570)
- [加速你的 zsh —— 最强 zsh 插件管理器 zplugin/zinit 教程 - Aloxaf's Blog](https://www.aloxaf.com/2019/11/zplugin_tutorial/)
- [ ] [cantino/mcfly: Fly through your shell history. Great Scott!](https://github.com/cantino/mcfly)
- [ ] [ellie/atuin: 🐢 Magical shell history](https://github.com/ellie/atuin)
      Atuin 使用 SQLite 数据库取代了你现有的 shell 历史，并为你的命令记录了额外的内容。此外，它还通过 Atuin 服务器，在机器之间提供可选的、完全加密的历史记录同步功能。

Note

1. `blockf` 用来阻断传统的添加补全的方式，zinit 会使用它自己的方式（基于符号链接而不是往 `$fpath` 里加一堆目录）
2. `multisrc"$ZDOTDIR/snippets/*.zsh"` 用来 source `$ZDOTDIR/snippets` 目录下所有的 .zsh 文件。
3. `OMZP::rust/rust.plugin.zsh` 需要检查到存在 rustup 和 cargo 时，才会添加补全
4. `atpull"zinit creinstall -q ."` 用来在更新 zsh-completions 时安装补全
5. precmd 钩子会在第一个命令提示符出现之前被调用，但 zsh-autosuggestions 插件在第一个命令行出现之后才会被加载，也就是说 precmd 钩子被调用时，`_zsh_autosuggest_start` 函数还没有被添加进 `$precmd_functions`，没有被调用，所以需要 `atload"_zsh_autosuggest_start"`
6. 关于补全 <https://github.com/zdharma-continuum/zinit/tree/main#calling-compinit-with-turbo-mode>。最好是在最后一个与补全相关的插件加载完后进行 `zicompinit; zicdreplay`，此处 fast-syntax-highlighting 是最后一个加载的，所以可以 `atload"zicompinit; zicdreplay"`。如果不生效建议 `autoload -Uz compinit; compinit; zinit cdreplay -q`

## 更新

```bash
# 更新 zinit 和插件
zinit update

# 更新 zinit
zinit self-update
# 如果出现错误：fatal：无法快进，终止。将 submodule 删除，然后重新下载该 submodule：
# rm -rf zsh/.config/zsh/zinit/zinit.git .git/modules/zsh
# git submodule update --init --depth 1 zsh/.config/zsh/zinit/zinit.git
# zinit self-update

# 更新 zinit-module
zinit module build

# 提交更新
git add zsh/.config/zsh/zinit/zinit.git
git commit -m "update submodule zsh/.config/zsh/zinit/zinit.git"
```

## 历史记录设置

```bash
# [zshoptions(1): zsh options - Linux man page](https://linux.die.net/man/1/zshoptions)
# 记录时间戳
setopt extended_history
# 当文件大小大于 HISTSIZE 时，首先移除重复历史
setopt hist_expire_dups_first
# 忽略重复
# 如果与文件中的旧命令行重复，文件中的旧命令行会被删除
#setopt hist_ignore_all_dups
setopt hist_ignore_dups
#
setopt hist_save_no_dups
# 忽略空格开头的命令
setopt hist_ignore_space
# 展开历史时不执行
setopt hist_verify
# 按执行顺序添加历史，并且是立即写入
# setopt inc_append_history
# 更佳性能
setopt hist_fcntl_lock
# 实例之间即时共享历史，也会立即写入
# setopt share_history
# 移除不必要的空格
setopt hist_reduce_blanks
```

## zinit 命令

- [zinit-commands](https://github.com/zdharma-continuum/zinit/tree/main#zinit-commands)

zi 是 zinit 的别名

```bash
# 列出正在使用的补全
zi clist
# 清理无效的补全，即清理 zinit/completions/ 目录中的空链接
zi cclear
# 补全安装（在 zinit/completions 里创建一个 _命令 的符号链接）
zi creinstall 插件名
# 安装 zinit 自身的补全
zinit creinstall _local/zinit

# 列出插件加载时间，按加载顺序排序
zi times
# zinit 的整体状态
zi zstatus
# 列出所有插件的报告
zi report
# 以格式化和彩色的方式列出 snippets
zi ls

# https://github.com/zdharma-continuum/zinit-module#measuring-time-of-sources
# 查看每个脚本的执行时间
zpmod source-study -l
```

## 补全

- [A Guide to the Zsh Completion with Examples](https://thevaluable.dev/zsh-completion-guide-examples/)

```bash

# 如果没有延迟加载与补全相关的插件，可以简单地在配置末尾添加来手动初始化补全
autoload -Uz compinit; compinit; zinit cdreplay -q
# 如果补全相关的插件被延迟加载了，则在最后一个插件 compinit 这个
# 有时候这玩意没用，需要手动 compinit 一下
zicompinit; zicdreplay

zicompinit 相当于 autoload -Uz compinit; compinit -d /home/hyuuko/.config/zsh/.zcompdump -C

这两个有何区别，-Uz 选项是啥

# FUNCTION: zicdreplay. [[[
# A function that can be invoked from within `atinit', `atload', etc.
# ice-mod.  It works like `zinit cdreplay', which cannot be invoked
# from such hook ices.
zicdreplay() { .zinit-compdef-replay -q; }
# ]]]

# FUNCTION: zicompinit. [[[
# A function that can be invoked from within `atinit', `atload', etc.
# ice-mod.  It runs `autoload compinit; compinit' and respects
# ZINIT[ZCOMPDUMP_PATH] and ZINIT[COMPINIT_OPTS].
zicompinit() { autoload -Uz compinit; compinit -d ${ZINIT[ZCOMPDUMP_PATH]:-${ZDOTDIR:-$HOME}/.zcompdump} "${(Q@)${(z@)ZINIT[COMPINIT_OPTS]}}"; }
# ]]]


zinit cdreplay 不能在 zinit ice 这样的 hook 里调用，即不能延迟调用
```

补全文件，有两种加载方式：

1. 使用 svn 修饰词直接加载目录，zinit 会自动识别并加载补全。
2. 直接加载补全文件，此时需要使用 `as="completion"` 这个修饰词，它会让 zinit 将下一行命令加载的文件作为补全安装到指定目录

##

性能总结：

1. 优先使用 for 循环，而且 wait 尽量写外面
2. zinit 命令尽可能少地使用
3. 插件尽可能少（如果能合并就好了）

## TODO

- [grml.org - Zsh](https://grml.org/zsh/)
  - [grml/grml-etc-core: Grmls core configuration files for zsh, vim, screen…](https://github.com/grml/grml-etc-core)
    据说挺返璞归真（简陋）的
- [sorin-ionescu/prezto: The configuration framework for Zsh](https://github.com/sorin-ionescu/prezto) 与 omz 类似的插件。
- 了解以下 zsh 补全配置的机制，看看 history.zsh 和 key-bindings.zsh 能否延迟
- [zsh: 9.3.1 Hook Functions](https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions)

preexec 在一个命令被执行前被执行。
precmd 在每个 prompt 出现之前被执行。
在 preexec 和 precmd 的 hook 里记录时间戳，就可以得到命令执行所花的时间。

PROMPT 是 pwd 等信息
RPROMPT 是右边的
PROMPT2 是续行什么的？

PROMPT 是 PS1 的代名词

PS1 像是被覆盖了

### VSCode Shell Integration

- [Shell Integration Manual installation | Visual Studio Code](https://code.visualstudio.com/docs/terminal/shell-integration#_manual-installation)

设 `terminal.integrated.shellIntegration.enabled` 为 `false`，然后添加

```bash
# VSCode Terminal Shell Integration
# https://code.visualstudio.com/docs/terminal/shell-integration#_manual-installation
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    # shellIntegration-rc.zsh 必须在 starship 后面运行
    . /opt/visual-studio-code/resources/app/out/vs/workbench/contrib/terminal/browser/media/shellIntegration-rc.zsh
    # 原因类似于 starship/starship 必须要 prompt_starship_precmd 一样
    __vsc_precmd
fi
```

###

全部直接加载 42.2 ms（可延迟的大概 40ms）fpath 没问题

如果 wait 一个已存在的 plugin，将其他延迟的插件放在一个延迟执行的脚本中，没问题。
原因在于 `_local/lazy-load`，通过插件进行延迟加载后，对 fpath 的修改并没有生效

该了一下语法，将 wait 和 load 的分开，fpath 的问题虽然解决了，但是补全仍然有问题。

新问题：

TRAPEXIT 在启动时执行两次，在退出时执行一次

- 和 source ${ZINIT[BIN_DIR]}/zinit.zsh 无关
- 和 source $ZDOTDIR/snippets/a.zsh 无关（可延迟的部分）
- 和 zinit 完全无关
- 和 starship 的加载有关
  - 如果 TRAPEXIT 定义在 source starship-init.zsh
    - 前面，启动输出 3 个
    - 后面，启动输出 2 个。每次按回车都会出现 2 个
      - 已知：
        - 如果命令行为空，那么按回车时，不会执行 preexec，会执行 precmd
      - 调试
        - 修改脚本，看看 TRAPEXIT 的执行时机
      - 调试结果
        - 在 precmd 执行结束之后，TRAPEXIT 执行两次
        - 在 PROMPT 执行结束后 TRAPEXIT 执行一次
        - 在 RPROMPT 执行结束后 TRAPEXIT 执行一次
- 范围继续缩小，和 `setopt promptsubst` 有关
  - 可能的原因 1
    - `setopt promptsubst` 会新起一个 shell 执行 `PROMPT` 这个命令，shell 执行该命令后退出，触发 TRAPEXIT
  - 继续测试：在 `PROMPT` 里判断是否为 interactive shell（不只是执行 .zshenv 还会执行 .zshrc）
  - 结果：输出 `569Xis` i 代表 interactive shell
  - 所以说是 zsh fork 了一个进程来执行命令吗，然后进程结束，触发了 TRAPEXIT。
    - 但是这样不应该触发 TRAPEXIT 啊，因为我们正常情况下，运行一个命令，也不会触发 触发了 TRAPEXIT 嘛
    - 为什么 `PROMPT` 不是像普通的命令那样执行的呢？
  - 通过输出
  - 解决办法 1
    - `PROMPT='$(exec echo $- "❯ ")' `
      - https://www.mankier.com/1/zshmisc#Precommand_Modifiers-exec
      - exec 会让命令在当前进程执行，而不会 fork，而且也不会触发 TRAPEXIT
      - 缺点：需要修改，太麻烦
  - 解决办法 2
    - 观察到 `PROMPT` 的执行 `569Xis` 没有 `m`

here

- `zsh b.zsh`
- non-login
  - interactive
    - 569BNXZghims
  - non-interactive
    - 569X
- login
  - interactive
    - 569XZilms
  - non-interactive
    - 569Xl

569Xis 是个啥？
每个字符都代表一个选项
https://zsh.sourceforge.io/Doc/Release/Options.html#Default-set
-X
LIST_TYPES
-i
INTERACTIVE
-s
SHIN_STDIN

ilprst 代表 shell 的状态

在状态为 569XZims 的 interactive shell 中

##

zsh -i -c exit 在开始执行延迟加载的脚本之前就执行了 exit 命令。
所以并没有执行 fnm，但因为是 interactive shell，所以还是会触发 TRAPEXIT，
导致删除了父环境中的 node 的符号链接。所以需要判断 -o shinstdin

可能还会存在其他 bug，所以建议：
在非延迟加载的地方，fnm 定义一个变量表示 fnm 还未初始化，
fnm 执行后，unset 该变量。
在 TRAPEXIT 中，如果该变量被定义，则说明 fnm 未初始化。

##

```bash
# 这个函数的定义不要延迟执行！
# 因为延迟执行的脚本实际上都运行在函数中（退出函数时 TRAPEXIT 就会被调用）
if [[ $+commands[fnm] ]]; then
    TRAPEXIT() {
        # monitor 避免主题里的 PROMPT 和 RPROMPT 执行完成后触发 TRAPEXIT 时执行以下代码
        # 由于有 -z $fnm_uninitialize 判断 fnm 是否初始化，zsh -i -c exit 不会执行该分支
        # 注意，由于 zsh -i -c exit 会触发 TRAPEXIT，如果执行了该分支的代码，测得的速度还慢 3ms
        if [[ -z $fnm_uninitialize && -o monitor ]]; then
            local curr_node=$(type node | awk '{print $3}' | sed 's/\/bin\/node//')
            # 如果 curr_node 的路径以 /run/ 开头
            [[ $curr_node == /run/* ]] \
                && echo "Exit zsh. Delete the symbolic link" $curr_node "created by fnm" \
                && rm $curr_node
        fi
    }
fi
```

## hook

[zsh: 26 User Contributions](https://zsh.sourceforge.io/Doc/Release/User-Contributions.html)

chpwd, periodic, precmd, preexec, zshaddhistory, zshexit, or zsh_directory_name

```bash
# 查看 chpwd_functions 的 hooks
echo $chpwd_functions
# 也可这样查看
add-zsh-hook -L chpwd
# 添加 函数 到 chpwd_functions
add-zsh-hook chpwd 函数
# 将 函数 从 chpwd_functions 中删除
add-zsh-hook -d chpwd 函数
```
