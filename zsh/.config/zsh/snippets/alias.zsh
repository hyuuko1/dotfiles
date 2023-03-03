alias vim='nvim'
alias pc='proxychains4 -q'
alias sudo='sudo '                  # 这样可以让 sudo 后面跟其他 alias
alias man-cn='LANG=zh_CN.UTF-8 man' # 查看中文手册
alias cat='/usr/bin/bat --style=plain --theme=Coldark-Dark'
alias paru='paru --bottomup'

alias l='/usr/bin/exa -F'
alias l.='/usr/bin/exa -Fd .*'
alias la='/usr/bin/exa -Fa'
alias ll='/usr/bin/exa -Flbh --time-style long-iso'
alias ll.='/usr/bin/exa -Fdlbh --time-style long-iso .*'
alias lla='/usr/bin/exa -Falbh --time-style long-iso'
alias lsa='/usr/bin/ls -lah'
alias lt='/usr/bin/exa -FT'
alias tree='/usr/bin/exa -FT'
alias llt='/usr/bin/exa -FTl --time-style long-iso'

# TIM 有时候会卡死，只好鲨了
alias fuckTIM='kill $(pgrep TIM.exe)'
alias fuckQQ='kill $(pgrep QQ.exe)'

# alias show-v2raya-log='sudo tail -n 30 -f /tmp/v2raya.log | lnav'


# https://wiki.archlinux.org/title/Color_output_in_console
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias dmesg='dmesg --color=always'

alias x11-i3='startx /usr/bin/i3'
alias x11-plasma='startx /usr/bin/startplasma-x11'
alias wayland-sway='/usr/share/sddm/scripts/wayland-session /usr/bin/sway'
alias wayland-plasma='/usr/share/sddm/scripts/wayland-session /usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland'

# 通过 vscode 的插件安装的 zls
alias zls="$HOME/.config/Code/User/globalStorage/augusterame.zls-vscode/zls_install/zls"

# 解压 zip 乱码时使用
alias unar="/usr/bin/unar -e gb18030"
