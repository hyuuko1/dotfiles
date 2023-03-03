#
# Options
#

# # Changing/making/removing directory
# setopt auto_pushd
# setopt pushd_ignore_dups

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt PUSHD_MINUS          # pushd -/+ 的功能倒转
# 用了这个选项后， cd -TAB 侯选项里的 directory stack 排到最后了
# setopt CD_ABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.

#
# Aliases
#

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# alias -- -='cd -'
# for index ({1..9}) alias "$index"="cd -${index}"; unset index


alias md='mkdir -p'
alias rd=rmdir

d() {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d
