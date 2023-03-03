依赖关系 gnupg <- gpgme <- kwallet <- kwallet-pam <- plasma-meta

edge 需要 kwallet 来存储密码，kwallet 需要 gnupg

kwalletmanager 是 kwallet 的可选依赖，可以不安装，安装好后系统设置里会多出一个 KDE 密码库的界面

- [KDE Wallet - ArchWiki](https://wiki.archlinux.org/title/KDE_Wallet)
  - [pam_autologin - ArchWiki](https://wiki.archlinux.org/title/Pam_autologin)

## 错误的！kwallet-pam 与 GnuPG keys 不兼容！

1. 先 `gpg --gen-key` 生成密钥。
   密码就填当前用户的密码吧（据说这样的话就可以在 login 时自动 unlock kde wallet，不需要每次使用 edge->kwallet 的时候输密码；自动 login 好像是由 pam_autologin 完完成的？）
   密钥默认有效期是两年，如果不想用默认设置，就 `gpg --full-generate-key`
2. 启动 edge
   1. edge 会调用 kwallet 来请求新建一个名为 kdewallet 的密码库，以便安全地存储敏感数据。（会保存在 `~/.local/share/kwalletd/`）
   2. 让我们选择新密码库的类型，此处选择 `GPG 加密方式`
   3. 之后让我们从下面的列表中选择一个签名密钥，此处选择我们之前用 `gpg --gen-key` 创建的密钥
   4. 完成
3. 启动 vscode，登录账号

```bash
❯ gpg --gen-key

gpg: 目录‘/home/hyuuko/.gnupg’已创建
gpg: 钥匙箱‘/home/hyuuko/.gnupg/pubring.kbx’已创建
注意：使用 “gpg --full-generate-key” 以获得一个全功能的密钥生成对话框。
GnuPG 需要构建用户标识以辨认您的密钥。
真实姓名： hyuuko
电子邮件地址： 751533978@qq.com
您选定了此用户标识：    “hyuuko <751533978@qq.com>”

更改姓名（N）、注释（C）、电子邮件地址（E）或确定（O）/退出（Q）？ O
我们需要生成大量的随机字节。在质数生成期间做些其他操作（敲打键盘、移动鼠标、读写硬盘之类的）将会是一个不错的主意；这会让随机数发生器有更好的机会获得足够的熵。
我们需要生成大量的随机字节。在质数生成期间做些其他操作（敲打键盘、移动鼠标、读写硬盘之类的）将会是一个不错的主意；这会让随机数发生器有更好的机会获得足够的熵。
gpg: /home/hyuuko/.gnupg/trustdb.gpg：建立了信任度数据库
gpg: 目录‘/home/hyuuko/.gnupg/openpgp-revocs.d’已创建
gpg: 吊销证书已被存储为‘/home/hyuuko/.gnupg/openpgp-revocs.d/41C7028ECAE8733D4FC53F1331AAF1EEC6FB1BA6.rev’
公钥和私钥已经生成并被签名。
pub   rsa3072 2023-04-24 [SC] [有效至：2025-04-23]
      41C7028ECAE8733D4FC53F1331AAF1EEC6FB1BA6
uid                      hyuuko <751533978@qq.com>
sub   rsa3072 2023-04-24 [E] [有效至：2025-04-23]
```

## 正确的做法

1. edge 会调用 kwallet 来请求新建一个名为 kdewallet 的密码库，以便安全地存储敏感数据。（会保存在 `~/.local/share/kwalletd/`）
2. 让我们选择新密码库的类型，此处选择传统的 blowfish 加密方式
3. 输入密码，完成
