---
title: Terminal前后端任务切换
urlname: scqgbg
date: '2015-01-16 00:00:00 +0800'
tags:
  - linux
  - shell
categories: []
---

我们在使用 Linux 的终端执行一些调用程序的命令时，经常需要用到进程前后端转换

### 例：

```bash
$ firefox http://google.com  # 调用火狐浏览器打开页面
$ gedit grub.cfg  # 经典的gedit用法
```

这时候我们的程序实际是在前台执行的，这时候对程序的操作能在当前的 Terminal 查看，这意味着当你关闭 Terminal 时，你所调用的程序也会自动结束，或者说当你想在当前的 Terminal 执行其他命令时，企图按下最常用的 Ctrl+C 结束当前的命令调用，可是此时你所调用的程序依然会自动结束进程。

<!-- more -->

### 解决方案：

1.在调用命令执行某个程序时，按下 Ctrl+Z 而不是 Ctrl+C，这个时候将进程交还给 Terminal 以执行其他的命令，但是这时候所执行的程序会处于就绪态(Stopped)，我们无法对其进行操作。

2.执行命令后面加上"&"

```bash
$ gedit grub.cfg &
```

这时候 Terminal 依旧会监视程序的一举一动，但是这时候再按下 Ctrl+C 试试吧。

3.执行 jobs 命令进行前后端进程的调度

```bash
$ jobs -l  #列出当前Terminal调用的任务
[1]-  2382 Stopped                 gedit
[2]+  2393 Stopped                 firefox
[3]   2466 Running                 firefox &
$ fg 1  # 将序号为1的任务，即gedit切换到前台运行
$ bg 2  # 将firefox切换到后台运行
$ kill 3  # 类似"kill pid"，此处是任务的序号
```

### 小结：

- 前台执行的任务即使是通过 Ctrl+Z 也会将任务调度到就绪状态(Stopped)

- 在命令后附加"&"实际上相当于执行任务调度"bg n"

- 前台程序可以先通过 Ctrl+Z 转换到就绪态,再通过"bg n"命令调度到后台运行

- 后天程序可以转到前台，方便 Terminal 监视程序的变化
