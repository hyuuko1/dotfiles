ZDOTDIR=$HOME/.config/zsh

# load the zinit-module，用来自动编译被 source 的脚本 https://github.com/zdharma-continuum/zinit-module
module_path+=("$ZDOTDIR/zinit/module/Src")
zmodload zdharma_continuum/zinit

. $ZDOTDIR/zshrc.zsh
