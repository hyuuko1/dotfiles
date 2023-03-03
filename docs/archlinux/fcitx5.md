- [Fcitx5 (简体中文) - ArchWiki](<https://wiki.archlinux.org/index.php/Fcitx5_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

```bash
pacman -S --needed fcitx5-{im,material-color,chinese-addons} fcitx5-pinyin-{zhwiki,moegirl}
```

`vim ~/.xprofile`，添加：

```conf
export INPUT_METHOD=fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=\@im=fcitx5
```

- 配置文件目录 `~/.config/fcitx5/`
- 数据目录为 `/usr/share/fcitx5/` 和 `~/.local/share/fcitx5/`
  - `~/.local/share/fcitx5/pinyin/` 是拼音的数据目录
  - `~/.local/share/fcitx5/rime/` 是 Rime 输入法的数据目录
  - `~/.local/share/fcitx5/table/` 是自然码、五笔、晚风、双拼、二笔、电报码、仓颉等的数据目录
  - `~/.local/share/fcitx5/themes/` 是主题

```bash
# 查看 fcitx5 的 desktop 文件是否在 /etc/xdg/autostart 中
ls /etc/xdg/autostart/org.fcitx.Fcitx5.desktop
# 如果不在，就需要将其复制到 ~/.config/autostart/ 这样才能自启
# cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
```

注销，重新登录，fcitx5 就会自动运行

- 打开 Fcitx 5 配置
  - 输入法只留下`键盘-英语（美国）`和`Pinyin`
  - Pinyin 设置
    - 页大小预测个数`10`；云拼音位置`2`；除了启用预测，其他的复选框都勾选；删除按笔画过滤的快捷键；快速输入的触发键双击即可改为空；取消勾选 `使用 V 来触发快速输入`
    - 词典->导入->在线浏览搜狗细胞词典，添加`计算机名词、计算机词汇大全`
  - 配置全局选项
    - `切换启用/禁用输入法`将 `Ctrl 空格` 改为 `左 Shfit`
    - `共享输入状态`：`所有`
  - 配置附加组件
    - Classic User Interface。字体大小 11；主题选择 `Material-Color-Blue`。固定 Wayland 的字体 DPI：`120`
    - Cloud Pinyin。最小拼音长度`2`；后端`Baidu`
    - Punctuation。Toggle Key `Ctrl .` 删除掉

另外可以看看这个[深蓝词库转换软件](https://github.com/studyzy/imewlconverter)

英文状态下，快捷键 Ctrl Alt H 可以切换到单词补全提示模式

## 词库

- [Fcitx5 (简体中文) - ArchWiki](<https://wiki.archlinux.org/title/Fcitx5_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E8%87%AA%E5%AE%9A%E4%B9%89%E8%AF%8D%E5%BA%93>)

添加词库：

- 打开 Fcitx 5 配置
  - Pinyin 设置
    - 词典->导入->在线浏览搜狗细胞词典，添加`计算机名词、计算机词汇大全`。词库文件会保存在 `~/.local/share/fcitx5/pinyin/dictionaries/`
    - https://github.com/wuhgit/CustomPinyinDictionary/releases

```bash
# 将用户词库转为文本文件
❯ libime_pinyindict -d ~/.local/share/fcitx5/pinyin/user.dict user.dict.txt
# 例如：
# libime_pinyindict -d /usr/share/fcitx5/pinyin/dictionaries/zhwiki.dict /tmp/zhwiki.dict.txt
# libime_pinyindict -d ~/.local/share/fcitx5/pinyin/dictionaries/CustomPinyinDictionary_Fcitx.dict /tmp/CustomPinyinDictionary_Fcitx.dict.txt
# libime_pinyindict -d ~/.local/share/fcitx5/pinyin/dictionaries/计算机专业词库.dict /tmp/计算机专业词库.dict.txt



# 将格式为 `汉字 拼音 频率` 的文本文件转换为词库
❯ libime_pinyindict 文本文件.txt 词库.dict

# 导出输入历史
❯ libime_history ~/.local/share/fcitx5/pinyin/user.history user.history.txt
```

英语，还剩两个字符的时候才会拼出来

## Rime

- [ssnhd/rime: Rime Squirrel 鼠须管配置文件（朙月拼音、小鹤双拼、自然码双拼）](https://github.com/ssnhd/rime)
- [Rime Squirrel 鼠须管输入法配置详解 - 三十年河東(SSNHD.COM)](https://ssnhd.com/2022/01/06/rime/)
- [Configuration · rime/home Wiki](https://github.com/rime/home/wiki/Configuration)
- [RimeWithSchemata · rime/home Wiki](https://github.com/rime/home/wiki/RimeWithSchemata)
- [CustomizationGuide · rime/home Wiki](https://github.com/rime/home/wiki/CustomizationGuide)

删除错词
将光标（↑ ↓ 或 ← →）移到要删除的词组上，按 Shift+Fn+Delete 键（第三方键盘按 Control+Delete）。只能从用户词典中删除词组，词库里词组只会取消其调频顺序。
