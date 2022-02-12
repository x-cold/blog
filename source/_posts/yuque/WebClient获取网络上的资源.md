---
title: WebClient获取网络上的资源
urlname: ynbfpq
date: '2015-02-15 00:00:00 +0800'
tags:
  - powershell
categories: []
---

WebClient 提供向了 URI 标识的资源发送数据和从 URI 标识的资源接收数据的公共方法.

### 下载网页内容

1.创建 WebClient 对象：

```powershell
$web = New-Object System.Net.WebClient
```

2.设置文本的编码：

```powershell
$web.Encoding = [System.Text.Encoding]::UTF8
```

3.下载网页代码

```powershell
$str = $web.DownloadString("http://localhost")
$str
```

### 获取文件资源

```
$url = "http://path.to/file"
$file = "\\localpath\to\file"
$web.DownloadFile($url,$file)
```

WebClient 能够实现一个 HTTP 客户端，进而拓展的应用场景非常丰富，如 web 自动化，网络爬虫，异步下载器等，更多关于 WebClient 的说明请参考：[https://msdn.microsoft.com/zh-cn/library/system.net.webclient(VS.80).aspx](<https://msdn.microsoft.com/zh-cn/library/system.net.webclient(VS.80).aspx>)

相似知识点：`HttpClient`
