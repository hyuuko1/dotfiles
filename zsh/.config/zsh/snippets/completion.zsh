# https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh
# https://thevaluable.dev/zsh-completion-guide-examples/

# zmodload zsh/complist



#
# Options
#

# lets files beginning with a . be matched without explicitly specifying the dot
# 让以 . 开头的文件在没有明确指定 . 的情况下进行匹配
# 例如 ls zsh 可以直接匹配到 .zshrc
setopt GLOB_DOTS
# 也可通过修改 _comp_options 来完成，不过需要放在 compinit 后面，因为 _comp_options 在 compinit 时才被定义
# /usr/share/zsh/functions/Completion/compinit:138
# _comp_options+=(globdots) # With hidden files

# 单词中也进行补全
setopt COMPLETE_IN_WORD # Complete from both ends of a word.
setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.

# unsetopt MENU_COMPLETE      # Do not autoselect the first completion entry.
# unsetopt FLOW_CONTROL       # Disable start/stop characters in shell editor.

#
# setopt NO_BEEP            # Do not beep on error in ZLE.




# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Completion-System-Configuration
# zstyle <pattern> <style> <values>
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# 禁用旧补全系统
zstyle ':completion:*' use-compctl false

# 来自 grml 的，用来自动 rehash。_force_rehash 要放在其他 completer 前面
_force_rehash () {
    (( CURRENT == 1 )) && rehash
    # Because we didn't really complete anything
    return 1
}

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _force_rehash _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"


# 按 tab 时，无条件地启动选择菜单
zstyle ':completion:*' menu true select
# 显示选项和选项的详细描述，默认为 true，用 false 只显示选项
zstyle ':completion:*' verbose true

# Formatting The Display
# %F{前景颜色} 内容 %f
# %K{背景颜色} 内容 %k
# %B 粗体 %b
# %U 下划线 %u
# %d 指 descriptions

# zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
# corrections 是 _approximate 和 _correct completers 使用的
zstyle ':completion:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
# zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# 候选项分组，并且将 tag 名作为 group name
zstyle ':completion:*' group-name ''
# 分组的顺序，-command- 指任何在 command position 的 word
zstyle ':completion:*' group-order original corrections
# group name 见 /usr/share/zsh/functions/Completion/Zsh/_command_names
zstyle ':completion:*:*:-command-:*:*' group-order reserved-words parameters aliases builtins functions commands


# 列出文件详细信息
# zstyle ':completion:*' file-list all


# 默认情况下会补全 // 中间的目录
# 这个选项将 // 视作 /
# zstyle ':completion:*' squeeze-slashes true

# cd -TAB 显示 directory stack entry
zstyle ':completion:*' complete-options true


# zstyle ':completion:*' list-grouped false
# zstyle ':completion:*' list-separator ''
# zstyle ':completion:*:matches' group 'yes'
# zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
# zstyle ':completion:*:messages' format '%d'
# zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# zstyle ':completion:*:descriptions' format '[%d]'


# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true


# =========================================

# 不显示特殊目录 . 和 ..
zstyle ':completion:*' special-dirs false

# Standard style used by default for 'list-colors'
LS_COLORS=${LS_COLORS:-'di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'}
# 文件颜色
# zstyle ':completion:*' list-colors ''
# 这里建议加双引号，因为 ${(s.:.)LS_COLORS} 可能是空的
# zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# LS_COLORS 指的应该就是 ls 命令输出的文件色彩


# =========================================
