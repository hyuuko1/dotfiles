pacman -S

## pacman 用法

- [pacman (简体中文) - ArchLinux wiki](<https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)
- [pacman (简体中文)/Tips and tricks (简体中文)](<https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)/Tips_and_tricks_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)>)

### 更新

- `pacman -Syu`：对整个系统进行更新
- `pacman -Syuu` 降级一些过于新的软件包

如果你已经使用`pacman -Sy`将本地的包数据库与远程的仓库进行了同步，也可以只执行：`pacman -Su`

### 安装包

- `sudo pacman -S 包名`：例如，执行 pacman -S firefox 将安装 Firefox。你也可以同时安装多个包，只需以空格分隔包名即可。添加`--needed`选项可以忽略已经安装的软件。
- `pacman -Ss '^包名-'`：有时，**-s 的内置正则会匹配很多不需要的结果**，所以应当指定仅搜索包名（`'^包名-'`），而非描述或其他子段
- `sudo pacman -Sy 包名`：与上面命令不同的是，该命令将在同步包数据库后再执行安装。
- `sudo pacman -Sv 包名`：在显示一些操作信息后执行安装。
- `sudo pacman -U 文件`：安装本地包，其扩展名为 pkg.tar.gz。
- `sudo pacman -U http://www.example.com/repo/example.pkg.tar.xz`：安装一个远程包

### 删除包

- `sudo pacman -R 包名`：该命令将只删除包，保留其全部已经安装的依赖关系
- `sudo pacman -Rs 包名`：在删除包的同时，删除其所有没有被其他已安装软件包使用的依赖关系
- `sudo pacman -Rn 包名`：避免备份配置文件

### 搜索查询包

- [查询包数据库 - ArchWiki](<https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E6%9F%A5%E8%AF%A2%E5%8C%85%E6%95%B0%E6%8D%AE%E5%BA%93>)

pacman 使用 `-Q` 参数查询本地软件包数据库，`-S` 查询同步数据库，以及 `-F` 查询文件数据库。

### 其他用法

- `sudo pacman -Sw 包名`：只下载包，不安装。
- `sudo pacman -Sc`：清理所有的缓存文件和无用的软件库。`/var/cache/pacman/pkg/` 和 `/var/lib/pacman/`
- `paru -c` 或 `sudo pacman -Rns $(pacman -Qdtq)` 清除系统中无用的包
- `paru -Scd`: -d option **delete** cached AUR packages and any untracked files in the cache
- `paru -D --asdeps 包名` 将包的安装原因修改为 'installed as dependency'

如果你要查找包含特定文件的包：

```bash
# 同步数据库
pacman -Fy
# 查找包含该文件的包
pacman -F file_name
# 查看该包包含的文件
pacman -F packge_name
```

## 文件清理

- [How to clean Arch Linux | Average Linux User](https://averagelinuxuser.com/clean-arch-linux/)

```bash
# 通过文件属性来检查文件修改
pacman -Qkk $(pacman -Qqe) > 文件变化.txt 2>&1
pacman -Qkk $(pacman -Qqe) 2>修改过的文件.txt

# 检查文件的大小、权限、修改时间，paccheck 来自 pacutils，加上 --md5sum 选项更加精确
sudo paccheck --quiet --require-mtree --files --file-properties --backup --noextract --noupgrade --db-files
# 会搜索所有的 pacnew 和 pacsave 文件并询问要执行的操作
pacdiff
# TODO 检查多余的文件（只检查 /etc /usr /opt）
```

## Tips and tricks

- [pacman/Tips and tricks - ArchWiki](https://wiki.archlinux.org/title/Pacman/Tips_and_tricks)
  介绍了一些技巧，比如
  - 查询不属于某些组的软件包
  - 查找不属于任何软件包的文件 `sudo pacreport --unowned-files`
  - 备份和恢复已安装软件包

`-Q` 列出安装的软件包的信息

```bash
# 注：许多选项是可以叠加的，比如在 -Qq 中的 q 不显示软件包版本号

# 列出所有安装的软件包（包括作为依赖安装的）
pacman -Q
# 列出所有外部包（比如 aur、手动安装的、已经从仓库中移除的）
pacman -Qm
# 列出所有本地包（从同步数据库安装）
pacman -Qn
# -e，--explicit，显式安装的，不包含作为依赖安装的 -Qen -Qem 同理
pacman -Qe
# -t，--unrequired，不被任何软件包依赖的
pacman -Qent
# -i，--info，查看所有软件包信息，也可指定软件包
pacman -Qi

# 按大小排序
LC_ALL=C pacman -Qei | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -h

# -Qq 中的 q 选项会不显示软件包版本号
# 列出所有显式安装的软件包
pacman -Qqe > Qqe.txt
# 列出所有显式安装的本地包
pacman -Qqen > Qqen.txt
# 列出所有显式安装的外部包
pacman -Qqem > Qqem.txt
# 查看软件包名带 xorg plasma 的
grep 'xorg\|plasma' Qqe.txt
# 排除 base-devel xorg plasma kde-applications texlive-most texlive-lang 组的显式安装的软件包
sed ":a;N;s/\n$(pacman -Sgq base-devel xorg plasma kde-applications texlive-most texlive-lang | sed ':a;N;s/\n/\\n\\|\\n/g;ba')\n/\n/g;ba" Qqe.txt
# :a;N;s/模式/模式/g;ba 是为了能够匹配模式里的 \n
# 中间的 \n$(pacman -Sgq base-devel xorg plasma kde-applications texlive-most texlive-lang | sed ':a;N;s/\n/\\n\\|\\n/g;ba')\n
# 得到的是类似于 \n包名\n\|\n包名\n\|\n包名\n 这样的结果
# sed ":a;N;s/\n包名\n\|\n包名\n\|\n包名\n/\n/g;ba" Qqe.txt 将 \n包名\n 替换成 \n

# 查询不属于某些组的软件包
comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base-devel xorg plasma kde-applications texlive-most texlive-lang fcitx5-im | sort)
```

```bash
# 列出在某 group 中的所有软件包
pacman -Sg <group>
```

### pactree

```bash
# 列出软件包的依赖树
pactree 包名
# 加上 --graph 输出 dot 格式的矢量图，然后生成 png
pactree 包名 -d3 --graph | dot -Tpng >pactree.png
```

### pacvis

- [PacVis: 可視化 pacman 本地數據庫 - Farseerfc 的小窩](https://farseerfc.me/pacvis.html#id23)

```bash
# 在浏览器中查看所有包的依赖关系图
pacvis --browser
```

## 日志

`code /var/log/pacman.log`
