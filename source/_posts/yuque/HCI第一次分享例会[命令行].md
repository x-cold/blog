
title: HCI第一次分享例会[命令行]
date: 2015-10-25 00:00:00 +0800
tags: [cmd,linux,hci]
categories: 
---

欢迎来访HCI第一次例会分享，今天小编（HCI-鹏飞）需要分享的是linux和windows命令行的基本命令以及技巧。

### <a name="bovtlm"></a>关于linux知多少

概要：开源、多用户多任务、支持多线程多CPU的操作系统（基于POSIX和UNIX），以网络为核心而设计，可以运行UNIX工具、应用程序和网络协议。Linux内核版本已经升级到4.3。(内核源代码Git仓库：[https://git.kernel.org/](https://git.kernel.org/))。
特性：强大的控制台和Linux终端环境以及桌面环境如GNOME, KDE, XFCE和 LXDE，稳定性高安全性较高。

<!-- more -->

应用场景：




![image.png | left | 442x693](https://cdn.yuque.com/yuque/0/2018/png/103147/1530282614096-ab87ccb8-d840-4f46-8e0b-d854f6f28999.png "")


### <a name="np1gov"></a>言归正传，下面开始进入正题。开始讲解linux(局部windows的命令行)

* 用户管理

```Bash
查看当前登录的用户名：who am i \ who mom likes
添加用户：adduser hci
修改密码：passwd
用户组查询：groups [root](cat /etc/group)
添加到组：usermod -G sudo hci
删除用户：deluser hci --remove-home
```

* 文件管理

> 文件权限：

```Bash
查看文件权限：ls -l
```



![image.png | left | 747x141](https://cdn.yuque.com/yuque/0/2018/png/103147/1530282638549-5e6ff30a-676f-4162-a8af-fb1b07a735cc.png "")



![image.png | left | 528x363](https://cdn.yuque.com/yuque/0/2018/png/103147/1530282646577-acd64bd4-6eaa-41dc-a9e4-5c4627293458.png "")


```Bash
更改所有者：chown
更改文件权限：chmod (直接赋值和加减权限)
chmod go-rw hci
# 'g''o'还有'u'，分别表示group，others，user，'+'，'-' 就分别表示增加和去掉相应的权限

```



![image.png | left | 747x245](https://cdn.yuque.com/yuque/0/2018/png/103147/1530282661213-c3bd0152-16ce-4546-9a6c-4a0b1cb83833.png "")


[ps: 三组权限：拥有者、所属用户组、其他用户]
> 操作文件：

```Bash
切换目录：cd\pushd
新建文件：touch
新建目录：mkdir
查看目录：ls
删除文件、目录：rm\rm -rf
复制文件：cp
移动文件：mv
重命名：rename
查看文件：cat\tac\ln
查看文件首尾：head\tail
逐行显示：more\less
查看文件类型：file
```

* 文本处理
    主要工具vi\vim：屏幕编辑和行编辑模式
* 环境变量
    运行环境的变量。

```Bash
定义变量：declare
删除变量：unset
立即生效：source .bashrc
用户Bash环境变量文件：~/.bashrc(根据终端环境如zsh的.zshrc)
系统环境变量：/etc/profile(/etc/bashrc)
```

* 其他技巧

```Bash
回显筛选：grep
查找文件：where(qs)\locate(qm)\whic(sr)\find
查看进程：ps
任务管理器：top
重启：reboot
关机：poweroff\shutdown\init
创建归档：tar(-c -x)
下载文件：wget
挂载文件系统：mount\unmount
帮助文档：man\info
```


