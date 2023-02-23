---
title: 使用树莓派搭建 NAS 服务
urlname: cgm3ug
date: '2015-10-18 19:25:42 +0800'
tags:
  - linux
categories: []
---

初探树莓派，便可知道其用途广泛，本篇博文将介绍如何使用树莓派搭建基于 Linux 和 SMB 协议的 NAS 服务器。

### 树莓派简介

树莓派（Raspberry pi，简写为 RPi，或者 RasPi/RPi）是目前比较常见的卡片电脑，为学生计算机编程教育而设计。其系统基于 Linux(或者最新发布的 Windows 10 IoT)。仅有巴掌大小的 PCB 板可谓麻雀虽小五脏俱全，可以像普通的 PC 那样工作。树莓派型号目前分为 A\B 型，其中 A 型的配置较低，不适合生产环境，本人以 B+ model 为例讲解后面的内容。树莓派目前主要被用于一些简单的 WEB 服务以及智能设备、由于 Python 强大的底层库支持，树莓派也常常被用极客们用于改装各种电子元件。

<!-- more -->

_基本配置：5V2A Micro USB 接口、512MB 内存、HDMI 视频输出口、音频输出、26 针 GPIO_

推荐链接：[树莓派入门须知](http://www.shumeipai.net/thread-21180-1-1.html?_dsign=81e52e75)

### 系统安装

略。

### 入门基础

首先，你必须学会使用简单的 linux 命令以及工具，从上面的系统安装教程我们可以了解到树莓派一般都会带上一个 debian 系列的 linux 系统。下面是常用的 linux 命令和工具：

- ssh：(Secure Shell)顾名思义，在缺少一套完整的键盘鼠标和 HDMI 显示器的条件下，我们只能通过 SSH（当然其他 RPC 也是被支持的，如 telnet，不过树莓派官方提供的系统已自动为我们启动 ssh 的服务）连接并操作树莓派。
- 简单的文件操作命令：`mkdir`,`rmdir`,`rm`,`cd`,`ls`,`cp`,`mv`等
- 终端文本编辑器：`vi`,`vim`等
- 基本的系统指令：`exit`,`reboot`,`init 0`,`ps`,`ifconfig`等
- 包管理（debian 系统为例）：apt-get
- 如果需要远程桌面图形化操作，请安装 VNC

### NAS 构架简介

- 简介

NAS（Network Attached Storage：网络附属存储）即是在网络上提供数据储存的装置，因此也称为“网络存储器”。它是一种专用数据存储服务器。它以数据为中心，将存储设备与服务器彻底分离，集中管理数据，从而释放带宽、提高性能、降低总拥有成本、保护投资。本次设计的 NAS 主要用于公司内文件共享以及定时备份到远端服务器。

- 硬件架构
  1.  树莓派 B+\*1
  2.  立式硬盘盒子\*1
  3.  1TB HDD 3.5inch\*1
- 软件和网络环境
  1.  os：debian
  2.  基于协议：SMB
  3.  依赖服务：smaba
  4.  基本模块：ntfs-3g、rsync、ssh、crontab
  5.  网络环境：内网静态 IP、可访问远端备份服务器

### 初始化硬盘

查看设备列表

```
df -h
```

解除挂载（如已挂载，否则跳过此步骤）

```
sudo umount /dev/hd-x /home/pi
```

切换到 root 用户

```
sudo -i（sudo su）
```

格式化硬盘

```
mkfs.ext4 /dev/hd-x
```

完成硬盘格式的转换，然后挂载到指定目录即可

```
sudo mount /dev/hd-x  /home/pi
```

### 启动 Samba 服务

升级和安装 Samba 软件包。

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install samba
```

创建一个我们将共享的文件夹， 通过运行以下命令创建此文件夹

```
mkdir -p /home/pi/shared
```

修改 samba 配置文件 **/etc/samba/smb.conf**，新增以下配置

```
[myshare]
# 可匿名访问
path = /home/pi/shared
writeable=Yes
create mask=0777
directory mask=0777
public=yes
browseable=yes
```

设置 Samba 共享设置的用户，然后重启服务。

```
# 设创建共享账户并设置密码
sudo smbpasswd -a pi
# 重启 Samba 服务
sudo systemctl restart smbd
```

至此，可以通过 Windows 文件资源管理器，映射网络驱动器连接到树莓派提供的 NAS 服务，访问对应共享的目录。
