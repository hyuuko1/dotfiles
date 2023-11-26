```bash
❯ nmcli -f NAME,DEVICE,FILENAME c show
# 查看 -f 选项可以显示的字段
❯ nmcli -f x con | /usr/bin/cat
错误：无效字段 "x"；allowed fields: NAME,UUID,TYPE,TIMESTAMP,TIMESTAMP-REAL,AUTOCONNECT,AUTOCONNECT-PRIORITY,READONLY,DBUS-PATH,ACTIVE,DEVICE,STATE,ACTIVE-PATH,SLAVE,FILENAME。
```

connection 配置文件在

- `/etc/NetworkManager/system-connections/`
- `/run/NetworkManager/system-connections/`
