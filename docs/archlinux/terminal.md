- [ANSI escape code - Wikipedia](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
- [Terminal Colors | Chris Yeh](https://chrisyeh96.github.io/2020/03/28/terminal-colors.html)

| Color               | Foreground | Background |                               |
| ------------------- | ---------- | ---------- | ----------------------------- |
| Black               | \033[30m   | \033[40m   | 1                             |
| Red                 | \033[31m   | \033[41m   | 2                             |
| Green               | \033[32m   | \033[42m   | 3                             |
| Yellow              | \033[33m   | \033[43m   | 4                             |
| Blue                | \033[34m   | \033[44m   | 5                             |
| Magenta             | \033[35m   | \033[45m   | 6                             |
| Cyan                | \033[36m   | \033[46m   | 7                             |
| White               | \033[37m   | \033[47m   | 8                             |
|                     |            |            |                               |
| 默认颜色            | \033[39m   | \033[49m   |                               |
| 默认强烈颜色        |            |            |                               |
|                     |            |            |                               |
| Bright Black (Gray) | \033[90m   | \033[100m  | auto suggesstion 中后面的颜色 |
| Bright Red          | \033[91m   | \033[101m  |
| Bright Green        | \033[92m   | \033[102m  |
| Bright Yellow       | \033[93m   | \033[103m  |
| Bright Blue         | \033[94m   | \033[104m  |
| Bright Magenta      | \033[95m   | \033[105m  |
| Bright Cyan         | \033[96m   | \033[106m  |
| Bright White        | \033[97m   | \033[107m  |

`\033` 是指八进制 33，也就是指十进制 27，相当于 `\x1b` `\u1b` `\U1b`，x 指 hexadecimal， u 是指 Unicode

`\033` 是 C0 控制字符，`\033` 是 `\x1b`，意思是 ESC (Escape)，表示随后是一个特殊命令序列而不是正常文本。

30~37 这些颜色代码是 选择图形再现（SGR）参数

前面的是普通颜色，后面的 Bright 是强烈颜色

konsole 里的暗淡颜色是个啥？

```bash

# 背景为 Light green
printf '\033[102m  '
```

onedarkpro 的

```json
{
  // #232627
  "terminal.ansiBlack": "#3f4451",
  "terminal.ansiRed": "#e05561",
  "terminal.ansiGreen": "#8cc265",
  "terminal.ansiYellow": "#d18f52",
  "terminal.ansiBlue": "#4aa5f0",
  "terminal.ansiMagenta": "#c162de",
  "terminal.ansiCyan": "#42b3c2",
  "terminal.ansiWhite": "#d7dae0",

  // #7f8c8d
  "terminal.ansiBrightBlack": "#4f5666",
  "terminal.ansiBrightRed": "#ff616e",
  "terminal.ansiBrightGreen": "#a5e075",
  "terminal.ansiBrightYellow": "#f0a45d",
  "terminal.ansiBrightBlue": "#4dc4ff",
  "terminal.ansiBrightMagenta": "#de73ff",
  "terminal.ansiBrightCyan": "#4cd1e0",
  "terminal.ansiBrightWhite": "#e6e6e6",

  // 前景 #d7dbe6 强烈前景 #828997（又改成了 #f0f0f0）
  "terminal.foreground": "#abb2bf",
  // 背景 #161925 强烈背景 #282c34
  "terminal.background": "#282c34",
  "terminal.selectionBackground": "#abb2bf30",

  "terminal.border": "#3e4452"
}
```
