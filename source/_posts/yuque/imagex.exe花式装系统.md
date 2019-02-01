
---
title: imagex.exe花式装系统
date: 2015-01-20 00:00:00 +0800
tags: [计算机维护]
categories: 
---

### <a name="wqiyvt"></a>imagex.exe简介

imagex.exe是一款用来捕获、修改和应用基于文件的磁盘映像以进行快速部署。ImageX可以使用 Windows 映像 (.wim) 文件复制到网络，或者还可以使用其他利用 .wim 映像的技术，如 Windows 安装程序、Windows 部署服务 (Windows DS) 以及系统管理服务器 (SMS) 操作系统功能部署包。

<!-- more -->

### <a name="ughyat"></a>帮助文档

```Bash
\> imagex /help		#查看帮助文档
ImageX Tool for Windows
Copyright (C) Microsoft Corp. All rights reserved.
Version: 6.1.7600.16385

IMAGEX [Flags] /Operation [Parameter List]

  Operation [ APPEND  | APPLY   | CAPTURE | DELETE  |
              DIR     | EXPORT  | INFO    | SPLIT   |
              MOUNT   | MOUNTRW | REMOUNT | UNMOUNT |
              CLEANUP | COMMIT ]

For help on a specific operation type:
  IMAGEX /Operation /?

Examples:
  IMAGEX /APPEND /?
  IMAGEX /APPLY /?
  IMAGEX /CAPTURE /?
  IMAGEX /DELETE /?
  IMAGEX /DIR /?
  IMAGEX /EXPORT /?
  IMAGEX /INFO /?
  IMAGEX /SPLIT /?
  IMAGEX /MOUNT /?
  IMAGEX /MOUNTRW /?
  IMAGEX /REMOUNT /?
  IMAGEX /COMMIT /?
  IMAGEX /UNMOUNT /?
  IMAGEX /CLEANUP /?

All operations accept the following flags:
  /SCROLL
  /LOGFILE logfile.log
\>
```

### <a name="srozaf"></a>安装系统需要使用的命令(这里采用wim镜像安装系统)

* 检测wim镜像的完整性，并获取到wim镜像的系统版本系统：

```Bash
> imagex /info install.wim		#查看"install.wim"的相关信息

ImageX Tool for Windows
Copyright (C) Microsoft Corp. All rights reserved.
Version: 6.1.7600.16385

WIM Information:
----------------
Path:        \Windows8.1\sources\install.wim
GUID:        {93bf56b4-8645-44b8-a3d3-b96aa7f508df}
# Image Count 是重要信息
Image Count: 1
Compression: LZX
Part Number: 1/1
Attributes:  0xc
             Integrity info
             Relative path junction


Available Image Choices:
------------------------
<WIM>
  <TOTALBYTES>3457099927</TOTALBYTES>
  <IMAGE INDEX="1">
    <DIRCOUNT>19524</DIRCOUNT>
    <FILECOUNT>92795</FILECOUNT>
    <TOTALBYTES>12855928858</TOTALBYTES>
    <HARDLINKBYTES>5346880387</HARDLINKBYTES>
    <CREATIONTIME>
      <HIGHPART>0x01CF4298</HIGHPART>
      <LOWPART>0x37D85CC6</LOWPART>
    </CREATIONTIME>
    <LASTMODIFICATIONTIME>
      <HIGHPART>0x01CF4298</HIGHPART>
      <LOWPART>0x74FBCEDF</LOWPART>
    </LASTMODIFICATIONTIME>
    <WIMBOOT>0</WIMBOOT>
    <WINDOWS>
      <ARCH>9</ARCH>
      <PRODUCTNAME>Microsoft® Windows® Operating System</PRODUCTNAME>
      <EDITIONID>Professional</EDITIONID>
      <INSTALLATIONTYPE>Client</INSTALLATIONTYPE>
      <SERVICINGDATA>
        <GDRDUREVISION>20140317</GDRDUREVISION>
        <PKEYCONFIGVERSION>6.3.9600.17031;2014-02-22T04:31:55Z</PKEYCONFIGVERSION>
      </SERVICINGDATA>
      <HAL>acpiapic</HAL>
      <PRODUCTTYPE>WinNT</PRODUCTTYPE>
      <PRODUCTSUITE>Terminal Server</PRODUCTSUITE>
      <LANGUAGES>
        <LANGUAGE>zh-CN</LANGUAGE>
        <FALLBACK LANGUAGE="zh-CN">en-US</FALLBACK>
        <DEFAULT>zh-CN</DEFAULT>
      </LANGUAGES>
      <VERSION>
        <MAJOR>6</MAJOR>
        <MINOR>3</MINOR>
        <BUILD>9600</BUILD>
        <SPBUILD>17031</SPBUILD>
        <SPLEVEL>0</SPLEVEL>
      </VERSION>
      <SYSTEMROOT>WINDOWS</SYSTEMROOT>
    </WINDOWS>
    <NAME>Windows 8.1 Pro</NAME>
    <DESCRIPTION>Windows 8.1 Pro</DESCRIPTION>
    <FLAGS>Professional</FLAGS>
    <DISPLAYNAME>Windows 8.1 专业版</DISPLAYNAME>
    <DISPLAYDESCRIPTION>Windows 8.1 专业版</DISPLAYDESCRIPTION>
  </IMAGE>
</WIM>

\>
```

* Image Count 即是该镜像包含的的系统各版本的计数，如旗舰版、专业版等。我们需要在后面的XML里面找到自己需要安装的系统版本对应的Count记录下来。
* 解压install.wim镜像内的系统文件到对应的路径，既是完成安装系统文件的过程。

```Bash
\> imagex /apply install.wim 1 c:	#其中数字"1"就是刚刚记录下的Count
```

* 备份系统同样也能完成：

```Bash
#增量备份，即在“windows.wim”里添加子映像
\> imagex /append C: D:\windows.wim "windows(2)"
```

* 完成了以上工作，基本的操作系统文件已经完成了复制过程，接下来我们则需要给新装的系统添加引导。只需要一条简单的命令，当然你也可以通过easybcd等工具来完成此过程。

```Bash
\> bcdboot c:\windows
```

### <a name="r7u2cu"></a>小结

1. imagex工具备份和还原的速度快，体积非常小。
2. imagex工具在命令行下的语法多样，可以进行各种灵活的操作。
3. 使用此方法非常适合直接在常用的操作系统上安装第二操作系统，并且速度十分可观，配合VHD安装多系统更是巧妙。


