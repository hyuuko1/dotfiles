- [zdharma-continuum/zinit](https://github.com/zdharma-continuum/zinit)
- [Zinit Wiki](https://zdharma-continuum.github.io/zinit/wiki/)
- [zsh 启动速度慢的终极解决方案 - Aloxaf 的文章 - 知乎](https://zhuanlan.zhihu.com/p/98450570)

Note

1. `multisrc"$ZDOTDIR/snippets/*.zsh"` 用来 source `$ZDOTDIR/snippets` 目录下所有的 .zsh 文件。
2. `rustup/cargo.plugin.zsh` 需要检查到有 rustup/cargo 命令时，才会添加补全
3. `blockf` 用来阻断传统的添加补全的方式，zinit 会使用它自己的方式（基于符号链接而不是往 `$fpath` 里加一堆目录），
   `atpull"zinit creinstall -q ."` 用来在更新 zsh-completions 时安装补全
4. precmd 钩子会在第一个命令提示符出现之前被调用，但 zsh-autosuggestions 插件在第一个命令行出现之后才会被加载，也就是说 precmd 钩子被调用时，`_zsh_autosuggest_start` 函数还没有被添加进 `$precmd_functions`，没有被调用，所以需要 `atload"_zsh_autosuggest_start"`
5. 关于补全 <https://github.com/zdharma-continuum/zinit/tree/main#calling-compinit-with-turbo-mode>。最好是在最后一个与补全相关的插件加载完后进行 `zicompinit; zicdreplay`，此处 fast-syntax-highlighting 是最后一个加载的，所以可以 `atinit"zicompinit; zicdreplay"`

## 更新

```bash
# 更新插件
zinit update

# 更新 zinit
zinit self-update
# 如果出现错误：fatal：无法快进，终止。将 submodule 删除，然后重试：
# git submodule update --init --depth 1 zsh/.config/zsh/zinit/zinit.git
# rm -rf zsh/.config/zsh/zinit/zinit.git  .git/modules/zsh
# zinit self-update

# 提交更新
git add zsh/.config/zsh/zinit/zinit.git
git commit -m "update submodule zsh/.config/zsh/zinit/zinit.git"
```
