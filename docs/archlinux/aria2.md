- [P3TERX/aria2.conf: Aria2 配置文件](https://github.com/P3TERX/aria2.conf)
  - [Aria2 完美配置 - 可能是最好的 Aria2 配置文件方案 - P3TERX ZONE](https://p3terx.com/archives/aria2_perfect_config.html)
  - [Arch Linux 的 Aria2 食用指南 • Hoar](https://blog.allwens.work/archlinuxAria2/)

```bash
paru aria2

git clone --depth 1 https://github.com/P3TERX/aria2.conf .aria2
cd .aria2
touch aria2.session

/root/ 全部换成 /home/hyuuko/

mkdir -p ~/.config/systemd/user

# 不要 sudo
systemctl --user enable --now aria2.service
```

- [AriaNg](http://ariang.mayswind.net/zh_Hans/)
- [AriaNg 的第三方扩展](http://ariang.mayswind.net/zh_Hans/3rd-extensions.html)
  - [Aria2 for Chrome](https://alexhua.github.io/Aria2-for-chrome/index.cn.html)

Aria2 默认的模式是每次下载都需要手动运行一次 aria2 ，下载完成后自动关闭。而开启 rpc 后，aria2 将作为后台应用持续运行，我们可以随时请求后台的 aria2 进行下载。
