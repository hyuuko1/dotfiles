# Proxy
PROXY_SERVER='127.0.0.1'
pon() {
    export all_proxy=socks5://${PROXY_SERVER}:20173 http_proxy=http://${PROXY_SERVER}:20172 https_proxy=http://${PROXY_SERVER}:20172 ftp_proxy=http://${PROXY_SERVER}:20172
}
poff() {
    unset all_proxy http_proxy https_proxy ftp_proxy
    echo "代理关闭！"
}
pon

# load the zinit-module，用来自动编译被 source 的脚本 https://github.com/zdharma-continuum/zinit-module
module_path+=("$ZDOTDIR/zinit/module/Src")
zmodload zdharma_continuum/zinit

# 定义哈希表 ZINIT，用来自定义 zinit 路径 https://github.com/zdharma-continuum/zinit#customizing-paths
typeset -A ZINIT=(
    BIN_DIR $ZDOTDIR/zinit/zinit.git # zinit 仓库代码位置
    HOME_DIR $ZDOTDIR/zinit          # zinit 的工作目录
    COMPINIT_OPTS -C                 # compinit 调用选项(由 zicompinit 完成的)，-C 选项加速加载
)
source ${ZINIT[BIN_DIR]}/zinit.zsh

# multisrc"$ZDOTDIR/snippets/*.zsh" 用来 source $ZDOTDIR/snippets 目录下所有的 .zsh 文件。
#
# 注意：rustup/cargo.plugin.zsh 需要检查到有 rustup/cargo 命令时，才会添加补全
zinit wait lucid is-snippet multisrc"$ZDOTDIR/snippets/*.zsh" for \
    OMZL::completion.zsh \
    OMZL::directories.zsh \
    OMZP::systemd/systemd.plugin.zsh \
    OMZP::sudo/sudo.plugin.zsh \
    OMZP::cargo/cargo.plugin.zsh \
    OMZP::rustup/rustup.plugin.zsh

zinit wait lucid as="completion" for \
    OMZP::docker/_docker \
    OMZP::rust/_rust \
    OMZP::fd/_fd

# blockf 用来阻断传统的添加补全的方式，zinit 会使用它自己的方式（基于符号链接而不是往 $fpath 里加一堆目录），
# atpull"zinit creinstall -q ." 用来在更新 zsh-completions 时安装补全
#
# precmd 钩子会在第一个命令提示符出现之前被调用，但 zsh-autosuggestions 插件在第一个命令行出现之后才会被加载，
# 也就是说 precmd 钩子被调用时，_zsh_autosuggest_start 函数还没有被添加进 $precmd_functions，没有被调用，
# 所以需要 atload"_zsh_autosuggest_start"
#
# 关于补全 https://github.com/zdharma-continuum/zinit/tree/main#calling-compinit-with-turbo-mode
# 最好是在最后一个与补全相关的插件加载完后进行 zicompinit; zicdreplay
# 此处 fast-syntax-highlighting 是最后一个加载的，所以可以 atinit"zicompinit; zicdreplay"
zinit wait lucid light-mode for \
    \
    zdharma-continuum/history-search-multi-word \
    \
    blockf atpull"zinit creinstall -q ." \
    zsh-users/zsh-completions \
    \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    \
    atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

# 不知为何，这几个不能延迟加载
zinit is-snippet for \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh

# starship 命令提示符 https://starship.rs/guide/
zinit ice \
    as"command" from"gh-r" atpull"%atclone" src"init.zsh" \
    atclone"./starship init zsh --print-full-init > init.zsh; ./starship completions zsh > _starship"
zinit light starship/starship
