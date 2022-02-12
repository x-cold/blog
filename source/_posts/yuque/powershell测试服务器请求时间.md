---
title: powershell测试服务器请求时间
urlname: yxbpzt
date: '2015-02-12 00:00:00 +0800'
tags:
  - powershell
categories: []
---

### 1、使用基本的 cmdlet

- Invoke-WebRequest 进行 HTTP 请求测试

```powershell
# 关于Invoke-WebRequest基本用法
PS > Invoke-WebRequest -Uri "http://www.baidu.com"
```

<!-- more -->

- Measure-Command 对上面的命令进行"计时"

```powershell
PS > Measure-Command -Expression {Invoke-WebRequest -Uri "http://www.baidu.com"}
```

### 2、源代码：

```powershell
$url = "http://www.baidu.com"
# 追踪执行命令耗时
$timeTaken = Measure-Command -Expression {
  # 保留请求信息，可用于网络爬虫的实现
  $site = Invoke-WebRequest -Uri $url
}

# 获取毫秒数
$milliseconds = $timeTaken.TotalMilliseconds
$milliseconds = [Math]::Round($milliseconds, 1)

Write-Host "It took $milliseconds ms!"
```

### 3、小结

PowerShell 获取网页信息个人建议的三种解决方案：

- WebClient

- Invoke-WebRequest

- COM 组件"InternetExplorer.Application"
