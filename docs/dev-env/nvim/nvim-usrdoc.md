# neovim 用户文档

```bash
# 快速索引。快捷键和选项、命令的
:help quickref.txt


```

`CTRL-w o` close other windows

## usr_01.txt About the manuals

01.1 Two manuals
The Vim documentation consists of two parts:

1. The User manual
   Task oriented explanations, from simple to complex. Reads from start to end like a book.
2. The Reference manual
   Precise description of how everything in Vim works.

Press `CTRL-]` to jump to a subject under the cursor.
Press `CTRL-O` to jump back (repeat to go further back).

01.2 Vim installed
To create an empty vimrc:

```vim
:call mkdir(stdpath('config'),'p')
:exe 'edit' stdpath('config').'/init.vim'
:write
```

01.3 Using the Vim tutor

01.4 Copyright

## usr_02.txt The first steps in Vim

The Vim editor is a modal editor.
In Normal mode the characters you type are commands.
In Insert mode the characters are inserted as text.

u undo
CTRL-r redo

By default, the help system displays the normal-mode commands. For example, `:help CTRL-H`.
To identify other modes, use a mode prefix. For example, `:help i_CTRL-H`.

## usr_03.txt Moving around

fx -- earch line forward for 'x'
Fx -- earch line backward for 'x'
tx -- earch line forward before 'x'
Tx -- earch line backward before 'x'
These four commands can be repeated with ";". "," repeats in the other direction.

CTRL-E (scroll up) 文本和光标都向上滚动一行
CTRL-Y (scroll down)

zt 滚动，使将光标所在行滚动到最顶部
zz 中间
zb 底部

we can use single-qutoe `'` or backtick \` to jump to a mark.
Generally, every time you do a command that can move the cursor further than within the same line, this is called a jump.
"j" and "k" are not considered to be a jump, even when you use a count to make them move the cursor quite a long way away.
`'` and \` is not only a command, but also a mark, which refers to the previous position you jumped.
Thus, you can use `''`, '\` and other combination to jump back and forth, between two points.

To place your own marks, use command `m{a-z}`. For example, use `ma`, then jump to another line and use `'a` to move to the beginning of the line containing the mark, \`a is diffrent, it can move you to the marked column.

You can use this command to get a list of marks: `:marks`

You will notice a few special marks. These include:

        '       The cursor position before doing a jump
        "       The cursor position when last editing the file
        [       Start of the last change
        ]       End of the last change

The CTRL-O command jumps to older positions (Hint: O for older).
CTRL-I then jumps back to newer positions (Hint: for many common keyboard layouts, I is just next to O).

## usr_04.txt Making small changes

`:help motion`

| operator | motion |
| -------- | ------ |
| d        | w      |
| c        | e      |
|          | b      |
|          | $      |
|          |        |
|          |        |

The operator `c` acts just like the `d` operator, except it leaves you in Insert mode.

There is an exception that `cw` actually works like `ce`, change to end of word.

`dd` and `cc` deletes a whole line.

Some operator-motion commands are used so often that they have been given a single-letter command:

        x  stands for  dl  (delete character under the cursor)
        X  stands for  dh  (delete character left of the cursor)
        D  stands for  d$  (delete to end of the line)
        C  stands for  c$  (change to end of the line)
        s  stands for  cl  (change one character)
        S  stands for  cc  (change a whole line)

The "r" command is not an operator. It waits for you to type a character, and will replace the character under the cursor with it.

The "." command repeats the last change.

Press "v" to start visual mode, then select the text you want to work on, finally type the operator command.
Press CTRL-V to start blockwise Visual mode.
When using blockwise selection, you have four corners. "o" only takes you to one of the other corners, diagonally. Use "O" to move to the other corner in the same line.

`p` and `P` paste the text you deleted.

`y` copy text
`yy` `Y` copy the entire line

在这些命令前面加上 `"*` 就可以赋值/粘贴 clipboard

"aw" is a text object. "aw" stands for "A Word". Thus "daw" is "Delete A Word"

| operator | text object         |
| -------- | ------------------- |
| d        | aw (A Word)         |
| c        | is (Inner Sentence) |
|          | as (A Sentence)     |
|          |                     |
|          |                     |

`R` command causes Vim to enter replace mode.
You can switch between Insert mode and Replace mode with the <Insert> key.

## usr_05.txt Set your settings

        ~/.config/nvim/init.vim         (Unix and OSX)
        ~/AppData/Local/nvim/init.vim   (Windows)

There are two types of plugins:

    global plugin: Used for all kinds of files
    filetype plugin: Only used for a specific type of file

## usr_06.txt Using syntax highlighting

## usr_07.txt Editing more than one file

## usr_08.txt Splitting windows

## usr_09.txt Using the GUI

## usr_10.txt Making big changes

## usr_11.txt Recovering from a crash

## usr_12.txt Clever tricks
