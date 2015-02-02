title: 批处理模拟守护进程
date: 2015-1-23
tags: [cmd,bat]
categories: cmd
---
### 原理非常简单，既是在后台监听任务管理器列表中是否存在被守护的进程。

_核心代码_

```Bash
::守护chrome.exe进程
tasklist | findstr "chrome.exe" || start "%ProgramFiles%\Google\Chrome\Applicationchrome\chrome.exe"
```

+ 主要运用到管道符号"|"，配合findstr寻找并判断系统是否运行着"chrome.exe"，"||"连接符表示"finstr"未找到合适的进程，将执行后面的启动"chrome.exe"语句。

<!--more-->

### 下面是一则源码，用于批量打开网页，并且在浏览器关闭后循环这个过程。

```Bash
@echo off
title QAQ
setlocal enabledelayedexpansion
pushd %~dp0
:start
set /a index=0
for /f %%a in (config.ini) do (
	ping %%a -n 1 > nul && (
		start "%ProgramFiles%\Google\Chrome\Applicationchrome\chrome.exe" http://%%a
		echo 	   !date! !time!: sent request to %%a
		echo !date! !time!: sent request to %%a >> log.txt
		set /a index+=1
		ping 127.1 -n 1 > nul
	)
)
echo= >> log.txt

:wait
tasklist | findstr "chrome.exe" > nul || goto start
ping 127.1 -n 5 > nul
goto wait
```