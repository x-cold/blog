---
title: '[PowerShell] 文件夹共享及磁盘映射'
urlname: qeqnq1
date: '2015-01-19 00:00:00 +0800'
tags:
  - powershell
categories: []
---

在 Linux 环境下，我们很轻易就能得心应手地通过命令操作一切事物，在 Windows 下，Powershell 也算是后起之秀，提供大量的 cmdlet 以及 c#的横向拓展。下面将由小编带领大家通过 Powershell 实现文件夹共享，当然文中也不会冷落 cmd 这枚老将。

### 文件夹共享概述

共享文件夹的应用非常广泛，客户端对服务器端进行文件管理，局域网文件直传等等，在 linux 下，可以简单的安装 smaba 协议，简单的配置之后即可使用。在 windows 下，可以通过图形化的操作开启这项功能，当然带着一点极客风格，我们通过 powershell（少量出现 cmd）来对其进行管理。

<!-- more -->

### 操作步骤

#### 查看共享列表

在 powershell 内，我们可以通过执行以下 cmdlet 获取共享信息：

```powershell
λ Get-WmiObject -Class Win32_Share

Name                                      Path                                      Description
----                                      ----                                      -----------
ADMIN$                                    C:\Windows                                远程管理
C$                                        C:\                                       默认共享
D$                                        D:\                                       默认共享
E$                                        E:\                                       默认共享
IPC$                                                                                远程 IPC
Users                                     C:\Users
```

同理，在 cmd 下，也可以

```powershell
λ net share

共享名       资源                            注解

-------------------------------------------------------------------------------
C$           C:\                             默认共享
D$           D:\                             默认共享
E$           E:\                             默认共享
IPC$                                         远程 IPC
ADMIN$       C:\Windows                      远程管理
Users        C:\Users
命令成功完成。
```

#### 创建一个共享文件夹

**疯狂的 Powershell**

```powershell
# 共享名
$ShareName = 'TestShare'
# 共享路径
$Path = 'D:\SHARE'

If (!(Get-WmiObject -Class Win32_Share -Filter "name='$ShareName'"))
{
	$Shares = [WMICLASS]"WIN32_Share"
	$Shares.Create($Path,$ShareName,0).ReturnValue
}
else
{
	Write-Warning "$ShareName has been sharing!!"
}
```

如果如果您有远程机器的管理员权限的话，也利用 WMI 在远程的机器上创建新的共享文件夹，下面是在远程主机上创建共享文件夹的代码：

```powershell
# 共享名
$ShareName = 'TestShare'
# 共享路径
$Path = 'D:\SHARE'
# 远程主机名
$Server = 'Server'

If (!(Get-WmiObject -Class Win32_Share -Filter "name='$ShareName'"))
{
	$Shares = [WMICLASS]"\\$Server\root\cimv2:WIN32_Share"
	$Shares.Create($Path,$ShareName,0).ReturnValue
}
else
{
	Write-Warning "$ShareName has been sharing!!"
}
```

**低调的 cmd**

```bash
::建议先查看当前的共享文件夹再进行创建操作
net share TestShare=D:\SHARE /users:25 /remark:"test share of the a folder"
```

我们很轻易地就能将一个文件夹的共享状态开启，我们可以通过 UNC 路径对其进行访问。创建完文件共享之后，我们来看看怎么使用吧。

#### 驱动器映射和共享访问

接下来，我们摒弃图形化界面的操作（如果你非喜欢那么做的话，可以通过网上邻居【“网络”】进行查看，或者在计算机图标下右键选择映射网络驱动器），我们来通过命令去启用吧。

**强悍的 Powershell**

临时创建一个网络驱动器映射：

```powershell
(New-Object -ComObject WScript.Network).MapNetworkDrive("Z:", "\\TEST-PC\USERS")
```

创建一个持久化的网络驱动器映射：

```powershell
# New-PSDrive 加上 -Persist 参数使得驱动器在 PowerShell 之外可见。
# 要真正地创建一个永久的网络驱动器，请确保加上 -Scope Global。/
# 如果 New-PSDrive 在全局作用域范围之外运行（例如，在一个脚本中运行），该驱动器只会在脚本运行时出现在文件管理器中。
New-PSDrive -Name Z -PSProvider FileSystem -Root \\TEST-PC\USERS -Persist -Scope Global
```

**小巧的 cmd**

```bash
::下面这条命令虽然可以在cmd使用此磁盘映射，但是不可利用资源管理器加载。
net use Z: \\TEST-PC\USERS

::这里是将systemroot文件夹映射为z:驱动器，可利用"explorer.exe"加载，可惜不能使用网络路径。
subst Z: $env:systemroot
```

完成如上的工作之后，不出意外，你的资源管理器会出现你想要访问的网络路径的图标。

#### 删除共享

如果不需要再使用此共享文件夹了，可以卸载掉网络驱动器，并在共享的主机上删除该共享。

**Powershell**

```powershell
$Shares = Get-WMIObject Win32_Share | Where {$_.Name -eq ""}

Foreach ($Share in $Shares) {
   $Share.Delete()
}
```

**cmd**

```bash
net share TestShare /delete
```

### 小结

1. 建立共享文件夹需要事先在启用网络共享和发现。
2. 需要提前做好文件夹权限控制以及共享的权限控制。
3. 通过配置 cmdkey 可以免去身份认证 `cmdkey /add:targetname /user:username /pass:password`

Powershell 管理共享的相关链接：[https://msdn.microsoft.com/en-us/library/aa394435(v=vs.85).aspx](<https://msdn.microsoft.com/en-us/library/aa394435(v=vs.85).aspx>)
