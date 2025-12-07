alias vim='nvim'
alias pc='proxychains4 -q'
alias sudo='sudo '                  # 这样可以让 sudo 后面跟其他 alias
alias man-cn='LANG=zh_CN.UTF-8 man' # 查看中文手册
alias cat='/usr/bin/bat --style=plain --theme=Coldark-Dark'
alias paru='paru --bottomup'

alias l='/usr/bin/eza -F'
alias l.='/usr/bin/eza -F -d .*'
alias la='/usr/bin/eza -F -a'
alias ll='/usr/bin/eza -F -lbh --time-style long-iso'
alias ll.='/usr/bin/eza -F -dlbh --time-style long-iso .*'
alias lla='/usr/bin/eza -F -albh --time-style long-iso'
alias lsa='/usr/bin/ls -lah'
alias lt='/usr/bin/eza -F -T'
alias tree='/usr/bin/eza -F -T'
alias llt='/usr/bin/eza -F -T -l --time-style long-iso'

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

# alias rq="/data/os-code/scripts/run-qemu.sh"
alias rq="/data/blog/src/scripts/run-qemu.sh"

# make kernel
alias mk="make LLVM=1 O=out/x86_64 -j$(nproc)"
alias mkv="make LLVM=1 O=out/x86_64 -j$(nproc) vmlinux"
alias mkb="make LLVM=1 O=out/x86_64 -j$(nproc) bzImage"
alias mkm="make LLVM=1 O=out/x86_64 -j$(nproc) menuconfig"
alias mks="make LLVM=1 O=out/x86_64 -j$(nproc) savedefconfig"
alias mko="make LLVM=1 O=out/x86_64 -j$(nproc) olddefconfig"
alias mkc="make LLVM=1 O=out/x86_64 -j$(nproc) compile_commands.json"
alias mki="sudo make LLVM=1 O=out/x86_64 -j$(nproc) INSTALL_MOD_PATH=/data/VMs/fedora_rootfs modules_install"
alias gai="gdb-add-index out/x86_64/vmlinux"

alias clr='printf \\x1bc'

alias qmp='/data/os-code/qemu/scripts/qmp/qmp-shell'

alias gf='git format-patch --diff-algorithm=patience'

function fix_boot_menu() {
  efibootmgr --create --disk $1 --part $2 --loader '\EFI\BOOT\BOOTX64.EFI' --label "Linux Boot Manager"
}

# grep linux git log
function gl() {
  count=${2:-"24"}

  rg --mmap -N -C $count -F "$1" /data/os-code/linux.git.log
}

# pstree -alp
