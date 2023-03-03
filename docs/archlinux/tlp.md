- 🌟 [笔记本电脑一直插着电会损伤电池吗？是真的咩 | 爱范儿](https://www.ifanr.com/app/1434428)
  边充边用会损坏笔记本电脑的电池么？答案是不会。笔记本使用时，一共有三种状态：
  - 笔记本未插电使用。笔记本电脑会消耗自带电池的电量，使用时会计入电池充电循环。
  - 笔记本非满电情况下插电使用。笔记本电脑在插电时，使用的是电源适配器提供的电力，并不会经过电脑内置的电池。所以根本不存在「边充边玩」的情况。不过，这时电池是充电的，依然会计入充电循环。
  - 笔记本满电时插着电源使用。电源适配器将继续为电脑供电，而充满电的内置电池则不会继续工作（不论是充电还是放电），所以不会计入充电循环。
- 🌟 [BU-808: How to Prolong Lithium-based Batteries - Battery University](https://batteryuniversity.com/article/bu-808-how-to-prolong-lithium-based-batteries)
  根据这篇文章里的几张图，可知：**通过将锂离子电池充电至 75% 并放电至 65%，可实现最小的容量损失**。
- [功耗控制 | archlinux 简明指南](https://arch.icekylin.online/guide/advanced/power-ctl.html)
- [TLP - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/TLP)
- [How to set battery charging limit in kde? - Support / KDE Plasma - Manjaro Linux Forum](https://forum.manjaro.org/t/how-to-set-battery-charging-limit-in-kde/75189/4)
  对于某些 lenovo 电脑，kde 设置界面里的高级电源设置就可以设置充电阈值。
  可能需要在 bios 里设置才行？？
- [Battery Care Vendor Specifics — TLP 1.5 documentation](https://linrunner.de/tlp/settings/bc-vendors.html)
  TLP 文档
- 🌟 [TLP-1.4-Test_Battery-Care_Overview.md](https://gist.github.com/linrunner/2ead4b591eed33055cf86a38ccc73949)
  非 ThinkPad 笔记本的充电保护教程。
  - 🌟 [TLP-1.4-Test_Battery-Care_Lenovo.md](https://gist.github.com/linrunner/4a6876648765fac5e141f15d0582a945)

```bash
❯ paru -s tlp
# 图形设置界面，不安装也行
❯ paru -s tlpui

# 电池充电阈值控制需要这两个包
# 实际完全不需要安装！见后文
❯ paru -s tp_smapi acpi_call

# 启用并启动，如果修改了配置，就 systemctl restart
❯ sudo systemctl enable --now tlp.service
```

我没安装 tlp-rdw（用来切换无线网络的？），而且在 tlp 设置界面把 `音频` `网络` 里的全部取消勾选。因此**不需要** enable NetworkManager-dispatcher.service 并 mask systemd-rfkill.service systemd-rfkill.socket

ThinkPad 电池那一栏，只勾选 `STOP_CHARGE_THRESH_BAT0=1`，保存，STOP_CHARGE_THRESH_BAT0 会被改成 5，需要手动 `sudo vim /etc/tlp.conf` 改为 1。
（其实也可 `sudo vim /etc/tlp.d/my.conf` 填入 `STOP_CHARGE_THRESH_BAT0=1`）
设置成 1 是因为 [TLP-1.4-Test_Battery-Care_Lenovo.md](https://gist.github.com/linrunner/4a6876648765fac5e141f15d0582a945) 在 battery conservation mode 必须设置成 1。
使用 ideapad_laptop 驱动的联想系列笔记本（非 thinkpad 系列的）有一个叫做 battery conservation mode 的功能，充电阈值固定在 60%
经过测试，这个值实际上是 80%。貌似是低于 60% 后就会充电到 80%。

```bash
❯
--- TLP 1.5.0 --------------------------------------------

+++ Battery Care
Plugin: lenovo
Supported features: charge threshold
Driver usage:
* vendor (ideapad_laptop) = active (charge threshold)
Parameter value range:
* STOP_CHARGE_THRESH_BAT0: 0(off), 1(on) -- battery conservation mode

/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode = 1 (60%)

+++ Battery Status: BAT0
/sys/class/power_supply/BAT0/manufacturer                   = Sunwoda
/sys/class/power_supply/BAT0/model_name                     = L22D4PC0
/sys/class/power_supply/BAT0/cycle_count                    =      3
/sys/class/power_supply/BAT0/energy_full_design             =  80000 [mWh]
/sys/class/power_supply/BAT0/energy_full                    =  83200 [mWh]
/sys/class/power_supply/BAT0/energy_now                     =  66570 [mWh]
/sys/class/power_supply/BAT0/power_now                      =      0 [mW]
/sys/class/power_supply/BAT0/status                         = Not charging  # 不再充电

Charge                                                      =   80.0 [%]
Capacity                                                    =  104.0 [%]
```

`/etc/tlp.d/my.conf`

```conf
# 电池
STOP_CHARGE_THRESH_BAT0=1

# 不管理硬盘，我怕不小心给我断电导致数据丢失
DISK_DEVICES=""
# auto 代表 enabled (关闭闲置设备的电源)
# on 代表 disabled (设备永久供电)
AHCI_RUNTIME_PM_ON_AC=on
AHCI_RUNTIME_PM_ON_BAT=on
```

```bash
# 查看 disk
❯ sudo tlp-stat -d
--- TLP 1.5.0 --------------------------------------------

+++ Disks
Devices = (disabled)
```
