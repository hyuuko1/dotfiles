# 调整外接显示屏的亮度
brightness() {
    [[ $1 > 0.29 ]] && [[ $1 < 1.01 ]] &&
        xrandr --output $(xrandr | grep -w connected | cut -f '1' -d ' ') --brightness $1 ||
        echo 'usage: brightness num, 0.29 < num < 1.01'
}

append_path() {
    case ":$PATH:" in
    *:"$1":*) ;;

    *)
        PATH="${PATH:+$PATH:}$1"
        ;;
    esac
}

# Rust
export RUSTUP_HOME='/usr/local/rustup'
export CARGO_HOME='/usr/local/cargo'
# Rust 国内镜像，https://blog.csdn.net/xiangxianghehe/article/details/105874880
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# 系统默认编辑器
export EDITOR='nvim'

# 关闭 .net 遥测
export DOTNET_CLI_TELEMETRY_OPTOUT=1

export JAVA_HOME=/usr/lib/jvm/default
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib

# 有时编译一些东西需要用到 openssl-1.0
#export OPENSSL_LIB_DIR="/usr/lib/openssl-1.0"
#export OPENSSL_INCLUDE_DIR="/usr/include/openssl-1.0"

#PATH="/home/hyuuko/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="/home/hyuuko/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="/home/hyuuko/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"/home/hyuuko/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/home/hyuuko/perl5"; export PERL_MM_OPT;

append_path "$HOME/.local/bin"
append_path "$CARGO_HOME/bin"

# source /opt/anaconda/bin/activate root

# eval "$(fnm env --node-dist-mirror https://npm.taobao.org/mirrors/node)"

alias ls='/usr/bin/ls -hF --color'
alias la='ls -a'
alias ll='ls -al'
alias cat='bat --style=plain'
alias vim='nvim'
alias pc='proxychains4 -q'
alias sudo='sudo '                  # 这样可以让 sudo 后面跟其他 alias
alias man-cn='LANG=zh_CN.UTF-8 man' # 查看中文手册
alias paru='paru --aururl "https://aur.tuna.tsinghua.edu.cn"'

# TIM 有时候会卡死，只好鲨了
alias fuckTIM='kill $(pgrep TIM.exe)'
