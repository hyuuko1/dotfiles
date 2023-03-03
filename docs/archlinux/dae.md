- [daeuniverse/dae: A Linux high-performance transparent proxy solution based on eBPF.](https://github.com/daeuniverse/dae)
  - [Quick Start Guide | Dae](https://dae.v2raya.org/docs/current/quick-start)
- [ ] [daeuniverse/daed: \[WIP\] daed, A Modern Dashboard For dae](https://github.com/daeuniverse/daed)
      dae 的图形界面

```bash
# archlinuxcn 有已构建好的包
❯ paru -S dae
❯ sudo systemctl enable --now dae

# 用法介绍
# 查看每个子命令用法
❯ dae help 目录
# 在前台运行 dae
❯ dae run
# 重新加载配置，不断开已存在的连接
❯ dae reload
# 暂停 dae，可通过 dae reload 恢复
❯ dae suspend
# 检查 /etc/dae/config.dae 是否有误
❯ sudo dae validate -c /etc/dae/config.dae
```

```yaml
global {

  log_level: info

  tcp_check_url: 'http://www.gstatic.com/generate_204'
  check_interval: 120s
  # Group will switch node only when new_latency <= old_latency - tolerance.
  check_tolerance: 50ms

  # The LAN interface to bind. Use it if you want to proxy LAN.
  # Multiple interfaces split by ",".
  #lan_interface: docker0

  # The WAN interface to bind. Use it if you want to proxy localhost.
  # Multiple interfaces split by ",". Use "auto" to auto detect.
  wan_interface: auto

  # Allow insecure TLS certificates. It is not recommended to turn it on unless you have to.
  allow_insecure: false

  dial_mode: domain+

  sniffing_timeout: 100ms

  # Disable waiting for network before pulling subscriptions.
  disable_waiting_network: false

  # Automatically configure Linux kernel parameters like ip_forward and send_redirects. Check out
  # https://github.com/daeuniverse/dae/blob/main/docs/getting-started/kernel-parameters.md to see what will dae do.
  auto_config_kernel_parameter: true
}

# Subscriptions defined here will be resolved as nodes and merged as a part of the global node pool.
# Support to give the subscription a tag, and filter nodes from a given subscription in the group section.
subscription {
    # 这个配置文件里的是 clash 的格式？会解析错误。应该用 v2ray 的格式？
    # nanoPort: 'file://../../home/hyuuko/.config/clash-verge/profiles/nanoPort.yaml'

    # nanoPort 是一个 tag
    nanoPort: 'https://subv5.nanoport.xyz/api/v1/client/subscribe?token=xxx'
}

# Nodes defined here will be merged as a part of the global node pool.
node {
    # Add your node links here.
    # Support socks5, http, https, ss, ssr, vmess, vless, trojan, trojan-go

    # 'socks5://localhost:1080'
    # mylink: 'ss://LINK'
    # node1: 'vmess://LINK'
    # node2: 'vless://LINK'
}

# See https://github.com/daeuniverse/dae/blob/main/docs/dns.md for full examples.
# dae will intercept all UDP traffic to port 53 and sniff DNS.
# dae 会拦截所有到端口53的UDP流量并嗅探 DNS
# XXX DNS嗅探是啥
dns {
  # 自己定义的 DNS upstream
  # 内置的有 asis, reject
  # XXX asis 是啥
  upstream {
    # 格式为 scheme://host:port
    # Scheme list: tcp, udp, tcp+udp. 还在开发的: https, tls, quic.
    # 如果域名有 IPv4 和 IPv6 record，则根据 group policy (比如最小延迟) 来选择。
    # 如果 dial_mode 被设置为 "ip"，那么 upstream DNS answer 不应该被污染（因此不推荐国内的）
    alidns: 'udp://dns.alidns.com:53'
    googledns: 'tcp+udp://dns.google.com:53'
  }
  routing {
    # 选择用于 dns query request 的 DNS upstream
    request {
      # 如果仍未被匹配成功，fallback 到 alidns
      fallback: alidns
    }
    # 根据 dns query 的响应，决定 accept 或者使用其他的 DNS upstream 再次 request
    # Built-in outbounds in 'response': accept, reject.
    response {
      # 如果 request 被发给 googledns，则 accept response. 这是为了避免因为下一条规则而 loop
      upstream(googledns) -> accept
      # 如果 DNS request 的不是中国的域名，并且响应结果包含 private IP 则说明已经被污染了，因此将 DNS request 发送给 googledns
      !qname(geosite:cn) && ip(geoip:private) -> googledns
      #
      fallback: accept
    }
  }
}

# 可以创建多个 group
group {
  # proxy 是一个 group 名字
  proxy {
    # 从 global node pool 过滤 nodes
    filter: name(keyword: '港') && !name(keyword: '10x', keyword: '20x', keyword: '30x', keyword: '40x', keyword: '50x', keyword: '官网', keyword: '群组')
    # filter: name(keyword: '日本')
    # filter: name(keyword: '狮城')

    # Filter nodes from the global node pool defined by the subscription and node section above.
    # subtag(..) 是根据订阅tag 来过滤？比如这里会匹配到 tag 为 my_abc 和 another_sub 的订阅。然后节点名字带有 ExpireAt: 的节点被过滤掉
    #filter: subtag(regex: '^my_', another_sub) && !name(keyword: 'ExpireAt:')
    # 根据 node tag 来过滤
    #filter: name(node1, node2)

    #policy: min_moving_avg
    policy: min_avg10
  }

  group2 {
    # 没有 filter，意味着这个 group 包含所有节点

    # Randomly select a node from the group for every connection.
    #policy: random

    # Select the first node from the group for every connection.
    #policy: fixed(0)

    # Select the node with min last latency from the group for every connection.
    #policy: min

    # Select the node with min moving average of latencies from the group for every connection.
    policy: min_moving_avg
  }
}

# See https://github.com/daeuniverse/dae/blob/main/docs/routing.md for full examples.
# Built-in outbounds: block, direct, must_rules
routing {
  # 这几个进程必须直连。to avoid false negative network connectivity check when binding to WAN.
  # XXX 我试了下不用这条规则也没出现啥问题
  pname(NetworkManager, systemd-resolved, dnsmasq) -> must_direct
  # Put it in the front to prevent broadcast, multicast and other packets that should be sent to the LAN from being forwarded by the proxy.
  dip(224.0.0.0/3, 'ff00::/8') -> direct

  dip(geoip:private) -> direct

  ### Write your rules below.

  # 这个必须要，否则：本来是国内的 ip，结果被代理了。
  dip(geoip:cn) -> direct
  domain(geosite:cn) -> direct

  fallback: proxy
}
```

## routing

Built-in outbounds: block, direct

对于单个规则，groupname 和 must_groupname 的区别是，groupname 会 DNS 劫持并且进行 DNS request（for traffic split use 用于流量拆分使用？），但是 must_groupname 不会。
must_groupname 可以写成 groupname(must)

当 DNS request 存在 traffic loop 时，must_direct 很有用。

must_rules 意味着匹配成功后不会将 DNS 流量重定向到 dae，并且不会结束匹配，而是继续匹配后面的规则。

```c

### , 是 or 的关系
domain(keyword: google, suffix: www.twitter.com, suffix: v2raya.org) -> my_group
dip(geoip:cn, 223.5.5.5) -> direct
sip(192.168.0.6, 192.168.0.10) -> direct

### 'And' rule
dip(geoip:cn) && dport(80) -> direct

### 'Not' rule
domain(geosite:google-scholar,
       geosite:category-scholar-!cn,
       geosite:category-scholar-cn
) -> my_group

### Little more complex rule
domain(geosite:geolocation-!cn)
&& !domain(geosite:google-scholar,
            geosite:category-scholar-!cn,
            geosite:category-scholar-cn)
-> my_group

### Customized DAT file
domain(ext:"yourdatfile.dat:yourtag")->direct
dip(ext:"yourdatfile.dat:yourtag")->direct
```

##

sniff (嗅探) DNS 的意思就是会捕获 DNS response，通过这样才程序就可以根据规则来决定 accept 或 reject 或 re-lookup

- [ ] 浏览器会先 DNS query，得到 ip 后建立 TCP 连接。
      clash TUN 使用 Fake IP 时：可以通过 Fake IP 和域名的映射来确定这个 TCP 连接中对应的域名。好处是 返回 fake ip 非常快，浏览器 DNS query 时不需要查询实际的 ip。
      dae 呢？和 clash TUN 不使用 fakeip 时一样吧。浏览器建立 TCP 连接时，dae 获取 HTTP 报文里面的域名。

[浅谈在代理环境中的 DNS 解析行为 | Sukka's Blog](https://blog.skk.moe/post/what-happend-to-dns-in-proxy/)
