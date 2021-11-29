# Proxy
PROXY_SERVER='127.0.0.1'
pon() {
    export all_proxy=socks5://$PROXY_SERVER:20173 \
        http_proxy=http://$PROXY_SERVER:20172 \
        https_proxy=http://$PROXY_SERVER:20172 \
        ftp_proxy=http://$PROXY_SERVER:20172
}
poff() {
    unset all_proxy http_proxy https_proxy ftp_proxy
    echo "代理关闭！"
}
pon

# 定义哈希表 ZINIT，用来自定义 zinit 路径 https://github.com/zdharma-continuum/zinit#customizing-paths
typeset -A ZINIT=(
    BIN_DIR $ZDOTDIR/zinit/zinit.git # zinit 仓库代码位置
    HOME_DIR $ZDOTDIR/zinit          # zinit 的工作目录
    COMPINIT_OPTS -C                 # compinit 调用选项(由 zicompinit 完成的)，-C 选项加速加载
)
source ${ZINIT[BIN_DIR]}/zinit.zsh

zinit wait lucid light-mode multisrc"$ZDOTDIR/snippets/*.zsh" for \
    OMZL::completion.zsh \
    OMZL::directories.zsh \
    OMZP::systemd/systemd.plugin.zsh \
    OMZP::sudo/sudo.plugin.zsh \
    OMZP::cargo/cargo.plugin.zsh \
    OMZP::rustup/rustup.plugin.zsh \
    as="completion" OMZP::docker/_docker \
    as="completion" OMZP::rust/_rust \
    as="completion" OMZP::fd/_fd \
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

zinit light-mode for \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    \
    as"command" from"gh-r" atpull"%atclone" src"init.zsh" \
    atclone"./starship init zsh --print-full-init > init.zsh; ./starship completions zsh > _starship" \
    starship/starship
