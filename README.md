## Dotfiles

顶层目录下的每个直接目录都是一个 PACKAGE（比如 `alacritty` `starship` 等等，`.vscode` 除外），把各个 PACKAGE 目录都当作 `$HOME` 就行，`stow PACKAGE` 会自动创建软链接。

```bash
❯ bash
❯ git clone --depth 1 https://github.com/hyuuko/dotfiles
❯ git submodule update --init --depth 1 --recursive

# 修改一些环境变量，比如 http_proxy 等等
❯ vim zsh/.config/zsh/.zshrc
# 安装 stow
❯ sudo pacman -S --needed stow
❯ stow zsh
❯ ls -l ~/.zshenv ~/.config/zsh
lrwxrwxrwx 1 hyuuko hyuuko 27 Nov 27 14:38 /home/hyuuko/.config/zsh -> ../dotfiles/zsh/.config/zsh
lrwxrwxrwx 1 hyuuko hyuuko 20 Nov 27 14:53 /home/hyuuko/.zshenv -> dotfiles/zsh/.zshenv
# 启动 zsh
❯ exec zsh
# updates and compiles Zinit
❯ zinit self-update
# build the zinit-module https://github.com/zdharma-continuum/zinit-module
❯ zinit module build

# 测试启动速度
❯ sudo pacman -S --needed hyperfine
❯ hyperfine "zsh -i -c exit" --warmup 10
```

## 参考

- [Aloxaf/dotfiles](https://github.com/Aloxaf/dotfiles)
