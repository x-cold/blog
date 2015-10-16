title: powershell学习之道-文件夹共享及磁盘映射
date: 2015-1-19
tags: [powershell,share$]
categories: powershell
---
共享文件夹的应用非常广泛，客户端对服务器端进行文件管理，局域网文件直传等等。

##用powershell脚本/cmd管理共享文件夹:
_适用于 PowerShell 所有版本_

1.利用WMI可以方便的管理共享文件夹：
+ 首先，我们可以通过下面这条powershell命令来获取当前配置的共享文件夹：

```powershell
Get-WmiObject -Class Win32_Share
```

+ 你也可以通过cmd命令来查看当前的共享文件夹：

```Bash
net share
```
<!--more-->

2.利用WMI创建新的本地共享文件夹，下面是创建本地共享文件夹的代码：
+ powershell脚本:

```powershell
$ShareName = 'TestShare'
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

+ 同样我们可以使用cmd命令:

```Bash
::建议先查看当前的共享文件夹再进行创建操作
net share TestShare=D:\SHARE /users:25 /remark:"test share of the a folder"
```

3.如果您有远程机器的管理员权限的话，也利用WMI在远程的机器上创建新的共享文件夹，下面是在远程主机上创建共享文件夹的代码：
+ powershell脚本:

```powershell
$ShareName = 'TestShare'
$Path = 'D:\SHARE'
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
+ cmd实现方法同下面的映射网络驱动器一致。

4.映射网络驱动器到本地：
+ powershell命令:

```powershell
//临时创建映射
(New-Object -ComObject WScript.Network).MapNetworkDrive("Z:", "\\TEST-PC\USERS")

//创建永久映射
//New-PSDrive 加上 -Persist 参数使得驱动器在 PowerShell 之外可见。
//要真正地创建一个永久的网络驱动器，请确保加上 -Scope Global。/
//如果 New-PSDrive 在全局作用域范围之外运行（例如，在一个脚本中运行），该驱动器只会在脚本运行时出现在文件管理器中。
New-PSDrive -Name Z -PSProvider FileSystem -Root \\TEST-PC\USERS -Persist -Scope Global
```

+ cmd命令:

```Bash
::下面这条命令虽然可以在cmd使用此磁盘映射，但是不可利用资源管理器加载。
net use Z: \\TEST-PC\USERS

::这里是将systemroot文件夹映射为z:驱动器，可利用"explorer.exe"加载，可惜不能使用网络路径。
subst Z: $env:systemroot
```

5.删除指定共享名的共享文件夹：
+ 手动打开资源管理器，找到文件夹设置其共享属性；
+ cmd命令:

```Bash
net share TestShare /delete
```

###小结
1.建立共享文件夹需要事先在"控制面板-网络和共享中心-更改高级共享设置"启用网络共享和发现。

2.用资源管理器访问远程主机文件夹时需要身份认证，要使其认证自动化执行，可以参考下面的cmd命令(保存身份凭证)：

```Bash
cmdkey /add:targetname /user:username /pass:password
```

3.管理当前正在使用的共享文件夹(下面的代码转载来自 <http://www.cnblogs.com/sxlfybb/archive/2007/07/12/815701.html> )：
```powershell
//作者:房客 http://sxlfybb.cnblogs.com
//由 MVP Willy Denoyette处获悉
//得到的鱼只是其一,其二是知道了有时候仅靠.net提供的托管对象是不能够解决问题的
using (DirectoryEntry de = new DirectoryEntry("WinNT://csgzb/LanmanServer"))
{
    IADsFileServiceOperations fso = de.NativeObject as IADsFileServiceOperations;
    if(fso!= null)
    {
        //////////////////////////////////////////////////////////////////////////
        //获取连接会话
        //////////////////////////////////////////////////////////////////////////                    
        foreach(IADsSession sess in fso.Sessions())
        {
            string str = "Name :" + sess.Name + "\tUser: " + sess.User + " \tComputer : " + sess.Computer;
            listBox1.Items.Add(str);
        }

        //////////////////////////////////////////////////////////////////////////
        //获取打开的文件
        //////////////////////////////////////////////////////////////////////////     
        IADsCollection resources = fso.Resources() as IADsCollection;
        foreach (IADsResource resource in resources)
        {
            try
            {
                string str ="Path: "+resource.Path+"\tUser: "+resource.User+"\tLockCount: "+resource.LockCount+"\tName:"+resource.Name ;
                listBox1.Items.Add(str);
            }
            catch (System.IO.FileNotFoundException ex)
            {
                // Watch Non-Fileshare resources like named pipes, these are not stored in the ADSI cache
            }
        }
    }
}
```