# 开启代理
pon() {
    local proxy=http://${1-'127.0.0.1'}:${2-'7890'}
    export all_proxy=$proxy http_proxy=$proxy https_proxy=$proxy ftp_proxy=$proxy
}
# 关闭代理
poff() {
    unset all_proxy http_proxy https_proxy ftp_proxy
    echo "代理关闭！"
}
# pon

# 调整亮度
brightness() {
    # typeset -F b=$1
    # (( b >= 0.3 && b <= 1.2 )) &&
    #     xrandr --output "$(xrandr | grep -w connected | cut -f '1' -d ' ')" --brightness $b ||
    #     echo 'usage: brightness num, 0.3 <= num <= 1.2'

# https://github.com/jonls/redshift/blob/master/README-colorramp
# kelvins 正常 6500
# 我能接受的最低是 3000，step 是 100

    typeset -F o=$1
    typeset -F b=$2
    (( o >= 3000 && o <= 6500 )) && (( b >= 0.3 && b <= 1 )) &&
        /usr/bin/redshift -P -O $o -b $b:$b ||
        echo 'usage: brightness TEMPERATURE BRIGHTNESS , 3000 <= TEMPERATURE <= 6500, 0.3 <= BRIGHTNESS <= 1.0'
}
# brightness 0.5

append_path() {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

remove_path() {
    # Delete path by parts so we can never accidentally remove sub paths
    if [[ "$PATH" == "$1" ]] ; then PATH="" ; fi
    PATH=${PATH//":$1:"/":"} # delete any instances in the middle
    PATH=${PATH/#"$1:"/} # delete any instance at the beginning
    PATH=${PATH/%":$1"/} # delete any instance in the at the end
}

append_path "$HOME/.local/bin"

# Rust
# export CARGO_HOME="$HOME/.cargo" RUSTUP_HOME="$HOME/.rustup"
append_path "$HOME/.cargo/bin"
# Rust 工具链 mirror
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
# 补全
update_rust_completion() {
    # ~/dotfiles/zsh/.config/zsh/zinit/completions/ 里的两个文件指向 ~/.config/zsh/completions/ 里的两个文件
    # ，这是通过 zinit creinstall $HOME/.config/zsh/completions 完成的
    rustup completions zsh >! $HOME/.config/zsh/completions/_rustup
    rustup completions zsh cargo >! $HOME/.config/zsh/completions/_cargo
}
# fpath+=$HOME/.config/zsh/completions
# 或者：
# 这条命令是生成该目录下所有的文件的软链接，放进 $HOME/.config/zsh/zinit/completions (这个目录在 fpath 里)里
# zinit creinstall $HOME/.config/zsh/completions

# 系统默认编辑器
export EDITOR='nvim'
export VISUAL='nvim'

# 关闭 .net 遥测
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Java
export JAVA_HOME=/usr/lib/jvm/default
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib

#export OPENSSL_LIB_DIR="/usr/lib/openssl-1.0"
#export OPENSSL_INCLUDE_DIR="/usr/include/openssl-1.0"

#PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

# anaconda
# . /opt/anaconda/bin/activate root

# Haskell
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# 使用 [fnm](https://github.com/Schniz/fnm) 管理 node 版本
# 需要先 paru -S fnm
# dist mirror 是 https://npmmirror.com/mirrors/node/
# registry mirror 是 https://registry.npmmirror.com
if (( ${+commands[fnm]} )); then
    [[ -n $FNM_MULTISHELL_PATH ]] && remove_path $FNM_MULTISHELL_PATH/bin

    # `fnm env` 会在 /run/user/1000/fnm_multishells/ 创建软链接，
    # 并且输出一些 export 语句，eval 会将其执行，效果是将路径添加进 path
    eval "$(fnm env --shell zsh --use-on-cd --node-dist-mirror https://npmmirror.com/mirrors/node/)"

    _fnm_clean_multishell_path() {
        rm $FNM_MULTISHELL_PATH
    }
    add-zsh-hook zshexit _fnm_clean_multishell_path
fi

# 这个会影响 less
# man 默认会使用 less 作为 pager
# 代码不会高亮
export LESS='-R --use-color -Dd+g$Du+b'

# 配置 man-pages 使用 bat 作为 pager（但 man 2 openat 时 O_APPEND 这种并没有高亮）
# export MANPAGER='sh -c "col -bx | bat -pl man --theme=Coldark-Dark"'
# export MANROFFOPT='-c'

# 默认使用 system-level 的 libvirtd
export LIBVIRT_DEFAULT_URI="qemu:///system"

# TODO
#############   插件 larkery/zsh-histdb 需要的设置   #############
#### [larkery/zsh-histdb: A slightly better history for zsh](https://github.com/larkery/zsh-histdb)

# HISTDB_FILE=$ZDOTDIR/.zsh-history.db
# # return the latest used command in the current directory
# _zsh_autosuggest_strategy_histdb_top_here() {
#     (($ + functions[_histdb_query])) || return
#     local query="
# SELECT commands.argv
# FROM   history
#     LEFT JOIN commands
#         ON history.command_id = commands.rowid
#     LEFT JOIN places
#         ON history.place_id = places.rowid
# WHERE commands.argv LIKE '${1//'/''}%'
# -- GROUP BY 会导致旧命令的新记录不生效
# -- GROUP BY commands.argv
# ORDER BY places.dir != '${PWD//'/''}',
# 	history.start_time DESC
# LIMIT 1
# "
#     typeset -g suggestion=$(_histdb_query "$query")
# }
#############

# TODO
# 跳转到近期目录的功能

# TODO
# systemd 的 environment.d
# https://axionl.me/p/linux-%E7%94%A8%E6%88%B7%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F%E8%AE%BE%E7%BD%AE/
