# This script should be executed after the first prompt.

setopt INTERACTIVE_COMMENTS     # 允许在 interactive shell 中使用 # 注释

# 默认情况下 *?_-.[]~=/&;!#$%^(){}<> 都被视作 word 的一部分
# See https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell
WORDCHARS=''
# WORDCHARS='_-'

. $ZDOTDIR/snippets/env.zsh
# TODO [joshskidmore/zsh-fzf-history-search: A simple zsh plugin that replaces Ctrl+R with an fzf-driven select which includes date/times.](https://github.com/joshskidmore/zsh-fzf-history-search)
. /usr/share/fzf/completion.zsh
. /usr/share/fzf/key-bindings.zsh

# 定义哈希表 ZINIT，用来自定义 zinit 路径 https://github.com/zdharma-continuum/zinit#customizing-paths
# -g 全局变量；-A 关联数组（哈希表）
typeset -gA ZINIT=(
    BIN_DIR             $ZDOTDIR/zinit/zinit.git # zinit 仓库代码位置
    HOME_DIR            $ZDOTDIR/zinit           # zinit 的工作目录
    ZCOMPDUMP_PATH      $ZDOTDIR/.zcompdump      # 用于 zsh 补全优化的文件
    COMPINIT_OPTS       -C  # compinit 的选项，-C 加速加载
    OPTIMIZE_OUT_DISK_ACCESSES  1
)
. ${ZINIT[BIN_DIR]}/zinit.zsh

zinit light-mode blockf for                                                     \
        OMZP::systemd/systemd.plugin.zsh                                        \
        OMZP::sudo/sudo.plugin.zsh                                              \
    as="completion"                                                             \
        OMZP::rust/_rustc                                                       \
    atload"_zsh_autosuggest_start"                                              \
        zsh-users/zsh-autosuggestions                                           \
        zdharma-continuum/fast-syntax-highlighting                              \
    atpull"zinit creinstall -q ."                                               \
        zsh-users/zsh-completions                                               \

# 对 fpath 的修改应该在此行之前完成比较好？
zicompinit; zicdreplay

. $ZDOTDIR/snippets/completion.zsh
# . $ZDOTDIR/snippets/completion.old.zsh
. $ZDOTDIR/snippets/alias.zsh
. $ZDOTDIR/snippets/directory.zsh
