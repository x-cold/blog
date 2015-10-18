title: powershell获取网页源代码
date: 2015-2-15
tags: powershell
categories: powershell
---
![title](/img/title/4.jpg)
### 也许你对浏览器中回去网页的源代码已经熟悉得不能再熟悉了，现在我们可以使用我们的powershell这个强大的工具来实现这个功能。

首先我们需要先创建一个WebClient对象：

```powershell
$web = New-Object System.Net.WebClient
```

设置文本的编码：

```powershell
$web.Encoding = [System.Text.Encoding]::UTF8
```
下载网页代码
```powershell
$str = $web.DownloadString("http://localhost")
$str
```