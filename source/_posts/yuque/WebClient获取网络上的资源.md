
title: WebClient获取网络上的资源
date: 2018-06-29T14:42:24.000Z
tags: []
categories: 
---
WebClient提供向了 URI 标识的资源发送数据和从 URI 标识的资源接收数据的公共方法.

### <a name="kczgdx"></a>下载网页内容

1.创建WebClient对象：

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

### <a name="0a7vym"></a>获取文件资源

```
$url = "http://path.to/file"
$file = "\\localpath\to\file"
$web.DownloadFile($url,$file)
```

WebClient能够实现一个HTTP客户端，进而拓展的应用场景非常丰富，如 web自动化，网络爬虫，异步下载器等，更多关于WebClient的说明请参考：[https://msdn.microsoft.com/zh-cn/library/system.net.webclient(VS.80).aspx](https://msdn.microsoft.com/zh-cn/library/system.net.webclient(VS.80).aspx)

相似知识点：`HttpClient`

