---
title: 深入 node node.js 到 windows 环境变量
urlname: ha07x2
date: '2017-08-19 00:00:00 +0800'
tags:
  - javascript
  - node.js
  - windows
  - 环境变量
categories: []
---

## 导读

兴许所有程序员都有命名困难症，在考虑变量、常量、方法、类、文件等命名时，总会千方百计尝试一些语义化的方式去实现。

曾经有那么一段时间，一些 node 初学的同学遇到了同样的问题：Hello World 跑不动！！！

## 0. 谜之 Hello World

问题的起源非常简单，当我们在编写一个入门程序时，就会迅速想起那句脍炙人口的语句：

```javascript
console.log("Hello World");
```

于是乎，顺手保存为 node.js，紧接着尝试以`node node.js`来运行该示例程序。毫无疑问，在 cmd 环境下，会遇到如下的报错：

<!-- more -->

![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530283568108-6e8cae58-4157-416f-a72f-3ab1e987d86d.png#width=565)

（PS：实际上无论是 Mac、Linux 用户，亦或是 WIndows 中使用 Powershell 或其他终端环境的同学都无法与此问题完美邂逅）

## 1. 初步分析

此时此刻，心中一阵失落，居然连入门的示例程序都无法运行，不禁一阵瞎想：是否该放弃 node.js 了？

言归正传，细心的同学会发现，报错的源头来自`Windows Script Host`，下简称`WSH`，我们不难查到它是 Windows 操作系统脚本语言程序（script，即：脚本）的运行环境。

## 2. 执行了什么？

简单分析一下`node node.js`这条命令，我们会很自然地认定为：执行 node.exe 程序，参数为 node.js。

然而实际上，真正执行的程序却变成`WSH`，前面执行的命令`node node.js`并没有任何跟调起`WSH`相关的逻辑，因此为何调起了`WSH`成为了解谜的关键。

顺蔓摸瓜，由于`WSH`正好是执行脚本的服务，而 js 恰恰又是脚本的一种，不妨假设`node.js`这个脚本文件就是罪魁祸首。然后创建一个`test.js`的副本，尝试执行它：

![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530283579297-58c3fa0b-a64b-48c6-b48e-2d2d95788c1b.png#width=573)

### 2.1 执行程序的路径

根据试验的结果不难猜出`node node.js`命令实际执行了`node.js`这个脚本文件，从而调起`WSH`服务，进而出现上图的报错。

顺水推舟可确定`node node.js`等价于`.\node.js node.js`，即命令执行的文件完整的路径为：`E:\test\node.js`。

（PS：各位看官切莫介怀''作为路径分隔符，毕竟在 cmd 下'/'担任参数分隔符的要职）

### 2.2 补全程序的路径

先讲讲通用的说法，无论是 \* nix 、OS/2 、DOS 亦或是 windows，其 terminal 都可以通过一个特殊的环境变量`PATH`进行“补全”（关于环境变量的详细内容本文不作介绍）。

接下来我们通过 ping 命令先做简要说明：

#### 2.2.1 定位程序的路径

![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530283587792-4ced2a94-ce79-49de-8ff3-2fc6864b9c1d.png#width=462)

很明显，在任何一台正常的机器上，这条命令执行后都能得到期待的结果。此时我们可以看到该 cmd 进程下的`PATH`环境变量中包含`C:\WINDOWS\system32`，通过对`PATH`中的元素(文件夹路径)即可将 ping 程序的路径补全为：`C:\WINDOWS\system32\ping`。（在 \* nix 系统下依然通用）

![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530283599104-8cb6d3a0-8146-4013-8050-c72dc48774a3.png#width=747)

#### 2.2.2 补全后缀名(仅 windows、dos)

由于 windows 的可执行的概念和 \* nix 略有不同，因此在 windows 平台下还需要对程序进行后缀名的补全。

其中在 \* inx 下，只需保证文件的结构符合规范，并且拥有可执行权限，就可以执行；而在 windows 下，还需要考虑其后缀名及执行方式（实际上是一种打开方式的策略）。

```
E:\test>echo %PATHEXT%
.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.PY;.PYW;.CPL
```

最终我们补全的程序路径为：`C:\WINDOWS\system32\ping.exe`，

#### 2.2.3 特别注意(仅 windows、dos)

针对于 cmd 环境，当前目录也会作为路径补全的一部分，并且优先级最高。在当前目录下，我们创建一个`ping.bat`的脚本，并填充以下内容：

```bash
@echo off
:: 输出完整的路径和文件名及后缀
echo %~dpnx0
```

执行结果如下图，原来的`ping.exe`的动作明显被覆盖了。

![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530283614729-6819eb33-989b-4506-8bed-b1adbcf1e8fe.png#width=569)

#### 2.2.4 小结

我们也额外地发现 windows 的默认可执行的后缀名包含`.JS`，由此可推断最初的那条`node node.js`命令最终补全的程序路径为：`E:\test\node.js`

## 3 打开方式？

从 2.2.4 的结论中能显而易见的推导出命令执行的程序为`node.js`脚本文件，那么它为什么是通过`WSH`去执行的呢？

答案其实很明显，有个通俗易懂的概念，叫做打开方式，而 windows 的打开方式由`assoc`和`ftype`确定。

### 3.1 后缀名与打开方式

尝试性的跑一跑`assoc`命令，发现其控制着后缀名与打开方式`ftype`的关系。

```bat
assoc | findstr .js
```

运行结果：

```bat
.js=JSFile
.json=VisualStudio.json.14.0
.jsonld=VisualStudio.jsonld.14.0
.jsx=VisualStudio.jsx.14.0
.jsxbin=JSXBINFile
.jsxinc=JSXINCFile
```

不难看出`.js`文件将会通过`JSFile`这个打开方式去执行。

### 3.2 打开方式与执行程序

类似的，我们也可以运行一下 ftype 命令，其定义了可执行程序以及调用的参数。

```bat
ftype | findstr "JS"
```

运行结果：

```
JSEFile=C:\Windows\System32\WScript.exe "%1" %*
JSFile=C:\Windows\System32\WScript.exe "%1" %*
JSXFile="C:\Program Files (x86)\Adobe\Adobe Utilities - CS6\ExtendScript Toolkit CS6\ExtendScript Toolkit.exe" -run "%1"
```

其中最关键的信息为`JSFile=C:\Windows\System32\WScript.exe "%1" %*`，含义是通过`WScript.exe`执行 js 脚本，并将原来的参数传递过去。

最终`node node.js`等价于`E:\test\node.js node.js`。

### 3.3 怎么破？

- 发动想象力吧，别再叫`node.js`了~

- 是时候切换到 \* inx 或者升级到 powershell 了~

- 如果不介意使用绝对路径的话……

## 4. 扩展学习

操作系统层面通过`PATH`等环境变量进行资源定位的思路实际上也被广泛应用在各种场景下，下面也举两个常见的栗子说明一下。

### 4.1 npm 包定位

CommonJS 规范中通过`require`去加载模块时，通过路径补全的策略（详情推荐阅读《深入浅出 Node.js》），可以省略模块的路径，后缀名，甚至连/index 也能自动补全。

### 4.2 webpack 资源定位

嘿，resolve 中的 extensions、alias 等思路是否也如出一辙呢？

## 5. 总结

全文原创·此文为随走随记，全文思维略带感情请勿拍砖。
