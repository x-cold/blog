
---
title: VHD安装系统【概念】
date: 2015-01-22 00:00:00 +0800
tags: [计算机维护]
categories: 
---

### <a name="ic0loc"></a>VHD简介

```
VHD，全称 Virtual Hard Disk ，正如其中文翻译，即是虚拟硬盘[powered by微软]。
简而言之，就是用一个硬盘上的文件来模拟和管理一个全新的物理磁盘，是虚拟化技术的一大利器。
```

### <a name="8ks4ee"></a>分类(win7下只有固定VHD和动态VHD两种)

```
固定VHD：对已分配的大小不会更改。
动态VHD：大小与写入的数据大小相同，并随着数据的写入而相应增加直到达到大小上限。动态VHD上限为2,040 GB。
差异 VHD ：与动态VHD 类似，但只包含所关联父VHD修改后的磁盘块。差异VHD的上限为2,040 GB。[1]
链接硬盘VHD：文件本身指向一个磁盘或者一个分区。
```

<!-- more -->

### <a name="8o3gle"></a>功能广泛

* 安装无盘操作系统，是公共场合（如网吧）非常适合使用这项技术。特点是维护方便，因为在虚拟硬盘的操作系统进行的操作几乎不会对计算机本身造成影响，而且这意味这客户端机子可以不需要配备硬盘而是直接通过NETBIOS等手段从服务器端进行引导。
* 安装多个操作系统，从其他计算机直接克隆操作系统。由于是用一个或者多个文件来管理一整个硬盘，因此对硬盘的整体转移和克隆变得非常地简单，甚至可以说移植一个VHD的操作系统只需要拷贝这个磁盘文件（占用空间略大），然后进行引导修复便可。
* 给虚拟机使用并可以作为一个独立的系统测试空间，例如一些高危的病毒文件行为分析，便可以通过使用此VHD的虚拟机进行测试，然后通过物理机直接读取日志。

### <a name="nvzubu"></a>安装系统

* 可以采用传统的各种方式来安装操作系统，不过在这之前需要提前装载好磁盘。
* 添加引导文件的时候需要注意系统所在分区（或者引导分区）所在的路径，格式为(hd(n,m)[n为硬盘序号，m为分区序号])，当然你也可以直接用bcd添加已经装载此磁盘的盘符进行引导添加，这将会自动拓展到一个完整的分区路径(hd(n,m))。
* 硬盘分区表格式需要和计算机自带的硬盘格式一致，如果你的计算机是GPT分区+UEFI，那么你最好选择把虚拟硬盘的格式设置为GPT格式。

### <a name="gc9qxq"></a>管理工具DISKPART

```Bash
>\ diskpart

::创建VHD
>\ create vdisk file=D:\win7.vhd maximum=15000 type=fixed

::选择VHD
>\ select vdisk file=D:\win7.vhd

::装载VHD
>\ attach vdisk

::建立分区
>\ create partition primary

::给分区分配盘符
>\ assign letter=v

::格式化分区
>\ format quick lable=vhddWin

::无损扩容
>\ diskpart
>\ sel vdisk file=D:\win7.vhd
>\ expand vdisk maximum=20000
>\ list vol
>\ sel vol 4
>\ extend

::退出diskpart
>\ exit
```


