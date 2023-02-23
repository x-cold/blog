---
title: '[PowerShell] 入门须知的八个技巧'
urlname: fbfn65
date: '2015-01-28 00:00:00 +0800'
tags:
  - powershell
categories: []
---

### powershell 脚本入门须知的八个技巧

- 脚本文件后缀名为 ".ps1" 的文本文件，包含了一系列的 powershell 命令，每条命令显示为独立的一行；
- 执行策略：about_Execution_Policies，通过下面这条命令查询所有支持的执行策略：

```powershell
[System.Enum]::GetNames([Microsoft.PowerShell.ExecutionPolicy])
```

- 运行脚本：使用绝对路径和相对路径均可运行，与 shell 命令执行如出一辙；
- 管道（"|"）的作用是将前一条命令的输出作为另一个命令的输入；
- 变量用 "$" 进行引用，用 "@" 将列表内容转为数组，命令引用数组变量 "$name" 也可以直接使用 "@name" ；
- "-split" 和 "-join" 拆分和连接字符串，如下面这条命令可以执行 1-100 求和：

```powershell
Invoke-Expression (1..100 -join '+')
```

- 断点：debug 神器，关键字：PSBreakpoint，可以和 PSBreakpoint 一起使用的动词包括 New，Get，Enable，Disable 和 Remove。下面是分别在行和变量中插入断点：

```powershell
New-PSBreakpoint -Script C:\Scripts\Script.ps1 -Line 10
New-PSBreakpoint -Script C:\scripts\Script.ps1 -variables a
```

- Step，调试一个脚本时，有时可能需要逐行运行脚本，这时你可以使用 Step-Into cmdlet 命令，它会使脚本一行一行地执行，不管有没有设置断点，如果你想从这种步进式运行模式退出来，使用 Step-Out cmdlet 命令即可，但需要注意的是，使用 Step-Out cmdlet 命令后，断点仍然有效。顺便说一句，如果你的脚本使用了函数，你可能对 Step-Out cmdlet 更感兴趣，Step-Out 的工作方式和 Step-Into 一样，不过，如果调用了一个函数，Windows 不会逐步执行，整个函数将会一次性执行。
