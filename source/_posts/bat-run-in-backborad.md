title: 批处理后台运行
date: 2015-1-28
tags: [bat,cmd]
categories: cmd
---
_ cmd /c 和 cmd /k 以及 VBscript 隐藏控制台窗口 _

```Bash
cmd /c test #后台调用test并关闭当前进程
cmd /k test #后台调用test但不关闭当前进程
```

VBscript代码： 
```vbs
Set ws = CreateObject("Wscript.Shell")
ws.run "cmd /c lol.bat",vbhide
```