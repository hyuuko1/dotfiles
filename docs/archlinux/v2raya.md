- [v2rayA | v2ray for Arch (x](https://t.me/v2raya_cn)

## 安装

```bash
sudo pacman -Ss --needed v2raya
sudo systemctl enable --now v2raya.service
```

## 设置

- 透明代理
  - **关闭**：关闭透明代理
  - 代理所有流量：全部代理
  - 大陆白名单模式：匹配成功的直连，否则代理
  - GFWList 模式：匹配成功的代理，否则直连
  - 与规则端口所选模式一致（使用`规则端口的分流模式`这一选项中的分流规则）
- 透明代理实现方式
  - redirect
- 规则端口的分流模式
  - **RoutingA**：自己配置
- 防止 DNS 污染
  - **关闭**
  - 仅防止 DNS 劫持(快速)
  - 自定义高级配置
    域名查询服务器
    `https://223.5.5.5:443/dns-query->direct` 或 `tcp://223.5.5.5:53->direct`
    国外域名查询服务器
    `https://8.8.8.8:443/dns-query->direct` 或 `tcp://8.8.8.8:53->direct`
- 特殊模式
  - 关闭
  - supervisor：监控污染，提前拦截，利用 v2ray-core 的 sniffing 解决污染
- TCPFastOpen
  - 保持系统默认
- 多路复用
  - 关闭
- 自动更新订阅
  - 每隔一段时间更新订阅（单位：小时）
    - 24
- 解析订阅链接/更新时优先使用
  - 跟随透明代理

注意：

- 如果要开启透明代理，记得要关闭系统设置中和终端中的代理设置

## 路由规则

- [RoutingA 自定义路由规则](https://github.com/v2rayA/v2rayA/wiki/RoutingA)
  - [路由配置 · Project V 官方网站](https://www.v2ray.com/chapter_02/03_routing.html)
- [透明代理](https://guide.v2fly.org/app/transparent_proxy.html)

默认端口：

- 2017: v2rayA 后端端口
- 20170: SOCKS 协议（直接 proxy）
- 20171: HTTP 协议（直接 proxy）
- 20172: 带分流规则的 HTTP 协议（通过分流规则决定 proxy/direct/block）

自定义端口：

- 20173：我在 RoutingA 里设置的带分流规则的 socks 端口

其他端口：

- 32345: tproxy，透明代理所需
- 32346: 插件协议端口，如 trojan、ssr 和 pingtunnel

## 我的 RoutingA 配置

注意：经过测试，`ip(geoip:!cn)`里有些不太准，建议别用

```r
# 让 20173 端口的 socks 参与分流
inbound: sockslocalin=socks(address: 127.0.0.1, port: 20173)

domain(domain:tamacom.com,domain:github1s.com,domain:vscode-webview.net,domain:vscode-unpkg.net,domain:makelinux.net,domain:homelinux.net,domain:searchvity.com)->proxy

domain(ext:"LoyalsoldierSite.dat:category-ads-all")->block
domain(ext:"LoyalsoldierSite.dat:cn", geosite:geolocation-!cn@cn)->direct
domain(ext:"LoyalsoldierSite.dat:geolocation-!cn", geosite:geolocation-!cn)->proxy

# 若默认的 inbound 还未匹配成功，则走直连
default: direct
# （这个要放最后面）若自定义的 sockslocalin inbound 还未匹配成功，则走直连
inboundTag(sockslocalin)->direct
```

- 系统代理和 .zshrc 中 socks 端口设置成 20173
- telegram 的代理使用端口 20170（因为 telegram 是直接通过 ip 地址连接服务器，分流规则识别起来挺难的，不如直接连接不带分流规则的 socks 端口）
- `domain(ext:"LoyalsoldierSite.dat:geolocation-!cn")->proxy` 会使用自定义规则文件

## 调试 & 日志

- 在终端打开设置好环境变量，`curl -vI https://www.google.com`
- `journalctl -u v2raya --since today`，`shift G` 跳转到末尾
