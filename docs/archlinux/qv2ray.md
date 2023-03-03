**Qv2ray 目前已经停止维护**

## Qv2ray

- [Qv2ray 文档](https://qv2ray.net/)

```bash
pacman -S v2ray qv2ray
# 按需安装插件 qv2ray-plugin-ssr-dev-git qv2ray-plugin-trojan-dev-git ...
```

- [v2ray-rules-dat-updater](https://github.com/hyuuko/PKGBUILDs/tree/main/v2ray-rules-dat) 每天自动更新加强版路由规则
  ```bash
  ❯ makepkg -si
  # 定时触发 v2ray-rules-dat-updater.service
  ❯ sudo systemctl enable --now v2ray-rules-dat-updater.timer
  Created symlink /etc/systemd/system/timers.target.wants/v2ray-rules-dat-updater.timer → /usr/lib/systemd/system/v2ray-rules-dat-updater.timer.
  # 等不急了，立即触发
  ❯ sudo systemctl start v2ray-rules-dat-updater.service
  ```

1. 首选项->常规设置。如果是暗色主题，则勾选适应主题的那两项，否则不勾选；行为那里的复选框全部勾选，记忆上次的链接；延迟测试方案勾选`TCPing`
2. 内核设置。v2ray 核心可执行文件路径改成`/usr/bin/v2ray`；然后点击`检查V2Ray核心设置`和`联网对时`（如果系统时间不对，v2ray 无法正常工作）
3. 入站设置。监听地址设置为`0.0.0.0`可以让同一局域网的其他设备连接；设置好端口并且勾选`设置系统代理`
4. 连接设置。勾选`绕过中国大陆`
5. 高级路由设置。域名策略选择`IPIfNonMatch`；域名阻断填入`geosite:category-ads-all`以屏蔽广告；windows 用户建议在域名直连填入`geosite:microsoft@cn`
6. 最后，点确定按钮以保存设置

点击`分组`按钮，填好订阅和过滤，更新订阅（如果无法更新订阅，可能是订阅链接被墙了，建议先建一个非订阅分组，然后添加 ssr 链接，连接上，并且在首选项里让 qv2ray 代理自己，然后再填订阅连接，更新）

### Qv2ray 透明代理

- [透明代理 - 百度百科](https://baike.baidu.com/item/%E9%80%8F%E6%98%8E%E4%BB%A3%E7%90%86)
- [springzfx/cgproxy - GitHub](https://github.com/springzfx/cgproxy)
- [使用 Qv2ray+cgproxy 配置透明代理（仅限 Linux）](https://kagarinokiriestudio.github.io/ArchLinuxTutorial/#/advanced/transparentProxy)

- qv2ray 的设置，首选项
  - 入站设置
    - 可以不用勾选`设置系统代理`了
    - 勾选`透明代理设置`；IPv6 监听地址填 `::1`；网络选项勾选 `TCP` 和 `UDP`；其他默认即可。

```bash
sudo pacman -S cgproxy-git
# 启用 cgproxy 服务
sudo systemctl enable --now cgproxy.service
# 如果启用了 udp 的透明代理（dns 也是 udp），则给 v2ray 二进制文件加上相应的特权
sudo setcap "cap_net_admin,cap_net_bind_service=ep" /usr/bin/v2ray
```

`sudo vim /etc/cgproxy/config.json`，编辑配置文件：

```json
{
  "comment": "For usage, see https://github.com/springzfx/cgproxy",

  "port": 12345,
  "program_noproxy": ["v2ray", "qv2ray"],
  "program_proxy": [],
  "cgroup_noproxy": ["/system.slice/v2ray.service"],
  "cgroup_proxy": ["/"],
  "enable_gateway": false,
  "enable_dns": true,
  "enable_udp": true,
  "enable_tcp": true,
  "enable_ipv4": true,
  "enable_ipv6": true,
  "table": 10007,
  "fwmark": 39283
}
```

编辑配置文件后需要重启 cgproxy 服务：

```bash
sudo systemctl restart cgproxy.service
```

最好退出 qv2ray，再重新打开，最后进行测试（注：没有设置 http_proxy 等环境变量）：

```bash
$ curl -vI https://www.google.com
*   Trying 31.13.68.1:443...
* Connected to www.google.com (31.13.68.1) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: none
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
...
```

而且 qv2ray 里的 vCore 日志中会有：

```
2020/10/06 16:56:31 192.168.114.514:58429 accepted udp:223.5.5.5:53 [outBound_DIRECT]
2020/10/06 16:56:31 192.168.114.514:45470 accepted tcp:31.13.68.1:443 [outBound_PROXY]
```
