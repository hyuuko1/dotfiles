## Dotfiles

顶层目录下的每个直接目录都是一个 PACKAGE（比如 `alacritty` `starship` 等等，`.vscode` 除外），把各个 PACKAGE 目录都当作 `$HOME` 就行，`stow PACKAGE` 会自动创建软链接。

```bash
❯ bash
❯ cd ~
❯ git clone --depth 1 https://github.com/hyuuko/dotfiles && cd dotfiles
❯ git submodule update --init --depth 1 --recursive

# 修改一些环境变量，比如 http_proxy 等等
❯ vim zsh/.config/zsh/.zshrc
# 安装 stow
❯ sudo pacman -S --needed stow
❯ stow zsh -t /home/hyuuko
❯ ls -l ~/.zshenv ~/.config/zsh
lrwxrwxrwx 1 hyuuko hyuuko 27 Nov 27 14:38 /home/hyuuko/.config/zsh -> ../dotfiles/zsh/.config/zsh
lrwxrwxrwx 1 hyuuko hyuuko 20 Nov 27 14:53 /home/hyuuko/.zshenv -> dotfiles/zsh/.zshenv
# 启动 zsh
❯ exec zsh
# updates and compiles Zinit
❯ zinit self-update
# build the zinit-module https://github.com/zdharma-continuum/zinit-module
❯ zinit module build

❯ sudo pacman -S --needed hyperfine
# 测试 zsh 的启动速度
❯ hyperfine "zsh -i -c exit" --warmup 10 -N
Benchmark 1: zsh -i -c exit
  Time (mean ± σ):       4.5 ms ±   0.6 ms    [User: 3.0 ms, System: 1.3 ms]
  Range (min … max):     2.2 ms …   5.9 ms    627 runs
```

## 参考

- [Aloxaf/dotfiles](https://github.com/Aloxaf/dotfiles)

注意：`systemd/.config/systemd/user/default.target.wants/unblockneteasemusic.service` 里有 QQ cookie。。

## 注意

- [etc](./etc/) 是放在根目录里的
