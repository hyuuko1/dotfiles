# 这里放置一些无论是图形界面或者终端界面都会用到的命令
# login interactive 和 login non-interactive shell 都会在 .zshrc 之前执行 .zprofile

# https://wiki.archlinux.org/title/XDG_Base_Directory#Specification
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
# export XDG_STATE_HOME=$HOME/.local/state
# https://wiki.archlinux.org/title/Flatpak#Adding_Flatpak_.desktop_files_to_your_menu
# export XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/flatpak/exports/share/applications:$HOME/.local/share/flatpak/exports/share/applications

# 使用 Sparse Index（一个 unstable 的功能，需要 nightly-2022-06-20 之后的工具链）
# https://bytedance.feishu.cn/docs/doccn8vZuDB541t8zTJyTUbZZxc#c7jI4q
export CARGO_UNSTABLE_SPARSE_REGISTRY=true

[[ -d /tmp/clash-verge ]] || mkdir -p /tmp/clash-verge/logs

if [[ ! -d /run/user/1000/Code ]]; then
     mkdir -p "/run/user/1000/Code/Cache/"
     mkdir -p "/run/user/1000/Code/GPUCache/"
     mkdir -p "/run/user/1000/Code/DawnCache/"
     mkdir -p "/run/user/1000/Code/Local Storage/leveldb/"
     mkdir -p "/run/user/1000/Code/logs/"
     mkdir -p "/run/user/1000/Code/Session Storage/"
     mkdir -p "/run/user/1000/Code/User/History/"
     mkdir -p "/run/user/1000/Code/User/globalStorage"
     mkdir -p "/run/user/1000/Code/User/workspaceStorage"

     cp ~/.config/Code/User/globalStorage/state.vscdb.backup /run/user/1000/Code/User/globalStorage/state.vscdb

     touch "/run/user/1000/Code/Network Persistent State"
     touch "/run/user/1000/Code/Preferences"
     touch "/run/user/1000/Code/TransportSecurity"

     mkdir -p /run/user/1000/.cache/mesa_shader_cache
     mkdir -p /run/user/1000/edge-cache
fi
