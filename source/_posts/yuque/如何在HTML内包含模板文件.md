---
title: 如何在HTML内包含模板文件
urlname: yg79mz
date: '2015-08-09 00:00:00 +0800'
tags:
  - html
  - javascript
categories: []
---

## 题记

最近项目开发使用了全新的架构（RequireJS+AngularJS+IonicUI），类似的前端 MVVM 框架已经深入人心，因此也试着在项目之余写一点小代码实现部分功能。下面我们将用原生的 Javascript 实现一个在 HTML 内引入 HTML 文件的简单小组件。

言归正传，我们要实现的功能就是在一个 HTML 内引用其他的 HTML 模板文件。例如以下场景：应用的多个页面需要复用一个 header，而我们希望只对其进行一次编辑和修改就可以应用于所有页面，因为我们可以将 header 的内容作为一个模板，其他页面只需要调用这个模板。

<!-- more -->

_在后端的模板引擎内我们可以直接使用`include`类似的语句包含其他的模板，在一些 SPA(Single Page APP)也是利用了类似于`ng-include`的写法复用 HTML 模板_

### 设计思路：

- HTML 标签：添加`include-html`属性，用于置入引用的 HTML 模板的 URL

```html
<div include-html="./header.html"></div>
```

- 获取所有 URL 的值

```javascript
var dom = document.getElementsByTagName("*");
for (var i = 0; i < dom.length; i++) {
  var bakNode = dom[i];
  url = bakNode.getAttribute("include-html");
  if (!check(url)) continue;
}
```

- 发送 GET 请求获取 URL 指向的模板页面并进行处理

```javascript
/**
 *	html文件包含器
 *	调用方式：DOM内插入属性'include-html="路径"'
 */
var includeHandle = function () {
  var dom, // DOM节点
    url; // 文件路径
  dom = document.getElementsByTagName("*");
  for (var i = 0; i < dom.length; i++) {
    var bakNode = dom[i];
    url = bakNode.getAttribute("include-html");
    if (!check(url)) continue;
    var node = bakNode;
    node.removeAttribute("include-html");
    loadHTML("GET", url, true, function (result) {
      node.innerHTML = result;
      // 递归调用
      // includeHandle();
    });
  }
};

/**
 *	XMLHttpRequest Get Html Content
 *	@param	{String} method - 方法
 *	@param	{String}	url	- 路径
 *	@param	{Bool}	async	- 异步选项
 */
var loadHTML = function (method, url, async, callback) {
  var result = "";
  if (!check(method)) var method = "GET";
  if (!check(async)) var async = false;
  var xhttp; // HTTPRequest
  if (window.XMLHttpRequest) {
    xhttp = new XMLHttpRequest();
  } else {
    xhttp = new ActiveXObject("Microsoft.XMLHTTP");
  }
  xhttp.onreadystatechange = function () {
    if (xhttp.readyState === 4 && xhttp.status === 0) {
      result = xhttp.responseText;
      callback(result);
    }
  };
  xhttp.open(method, url, async);
  xhttp.send();
};
```

- 递归调用 => 嵌套调用

这里还需要进行算法优化，借着午后小憩的时间暂且先完成此 DEMO，后继完善。

### 完整 DEMO

1. index.html

```html
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  </head>
  <body>
    <div include-html="test.html"></div>
    <section>test</section>
    <script type="text/javascript" src="demo.js"></script>
  </body>
</html>
```

1. index.html

```html
<!DOCTYPE html>
<header>
  <ul class="menu">
    <li>1111</li>
    <li>2222</li>
    <li>3333</li>
  </ul>
</header>
```

1. demo.js

```javascript
/**
 *  数据校验
 */
var check = function (data) {
  if (
    typeof data === undefined ||
    data === null ||
    data === "" ||
    data === undefined
  )
    return false;
  return true;
};

/**
 *	XMLHttpRequest Get Html Content
 *	@param	{String} method - 方法
 *	@param	{String}	url	- 路径
 *	@param	{Bool}	async	- 异步选项
 */
var loadHTML = function (method, url, async, callback) {
  var result = "";
  if (!check(method)) var method = "GET";
  if (!check(async)) var async = false;
  var xhttp; // HTTPRequest
  if (window.XMLHttpRequest) {
    xhttp = new XMLHttpRequest();
  } else {
    xhttp = new ActiveXObject("Microsoft.XMLHTTP");
  }
  xhttp.onreadystatechange = function () {
    if (xhttp.readyState === 4 && xhttp.status === 0) {
      result = xhttp.responseText;
      callback(result);
    }
  };
  xhttp.open(method, url, async);
  xhttp.send();
};

/**
 *	html文件包含器
 *	调用方式：DOM内插入属性'include-html="路径"'
 */
var includeHandle = function () {
  var dom, // DOM节点
    url; // 文件路径
  dom = document.getElementsByTagName("*");
  for (var i = 0; i < dom.length; i++) {
    var bakNode = dom[i];
    url = bakNode.getAttribute("include-html");
    if (!check(url)) continue;
    var node = bakNode;
    node.removeAttribute("include-html");
    loadHTML("GET", url, true, function (result) {
      node.innerHTML = result;
      // 递归调用
      // includeHandle();
    });
  }
};
includeHandle();
```
