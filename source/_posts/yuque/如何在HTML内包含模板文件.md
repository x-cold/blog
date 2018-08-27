
title: 如何在HTML内包含模板文件
date: 2018-08-27T14:01:41.000Z
tags: []
categories: 
---
## <a name="1dtfnz"></a>题记

最近项目开发使用了全新的架构（RequireJS+AngularJS+IonicUI），类似的前端MVVM框架已经深入人心，因此也试着在项目之余写一点小代码实现部分功能。下面我们将用原生的Javascript实现一个在HTML内引入HTML文件的简单小组件。

言归正传，我们要实现的功能就是在一个HTML内引用其他的HTML模板文件。例如以下场景：应用的多个页面需要复用一个header，而我们希望只对其进行一次编辑和修改就可以应用于所有页面，因为我们可以将header的内容作为一个模板，其他页面只需要调用这个模板。

<!-- more -->

<em>在后端的模板引擎内我们可以直接使用</em><em><code>include</code></em><em>类似的语句包含其他的模板，在一些SPA(Single Page APP)也是利用了类似于</em><em><code>ng-include</code></em><em>的写法复用HTML模板</em>

### <a name="onvkyr"></a>设计思路：

* HTML标签：添加`include-html`属性，用于置入引用的HTML模板的URL

```html
<div include-html="./header.html"></div>
```

* 获取所有URL的值

```js
var dom = document.getElementsByTagName('*');
for (var i = 0; i < dom.length; i++) {
	var bakNode = dom[i];
	url = bakNode.getAttribute('include-html');
	if (!check(url)) continue;
}
```

* 发送GET请求获取URL指向的模板页面并进行处理

```js
/**
 *	html文件包含器
 *	调用方式：DOM内插入属性'include-html="路径"'
 */
var includeHandle = function() {
	var dom, // DOM节点
		url; // 文件路径
	dom = document.getElementsByTagName('*');
	for (var i = 0; i < dom.length; i++) {
		var bakNode = dom[i];
		url = bakNode.getAttribute('include-html');
		if (!check(url)) continue;
		var node = bakNode;
		node.removeAttribute('include-html');
		loadHTML('GET', url, true, function(result) {
			node.innerHTML = result;
			// 递归调用
			// includeHandle();
		});
	}
}

/**
 *	XMLHttpRequest Get Html Content
 *	@param	{String} method - 方法
 *	@param	{String}	url	- 路径
 *	@param	{Bool}	async	- 异步选项
 */
var loadHTML = function(method, url, async, callback) {
	var result = '';
	if (!check(method)) var method = 'GET';
	if (!check(async)) var async = false;
	var xhttp; // HTTPRequest
	if (window.XMLHttpRequest) {
		xhttp = new XMLHttpRequest();
	} else {
		xhttp = new ActiveXObject('Microsoft.XMLHTTP')
	}
	xhttp.onreadystatechange = function() {
		if (xhttp.readyState === 4 && xhttp.status === 0) {
			result = xhttp.responseText;
			callback(result);
		}
	}
	xhttp.open(method, url, async);
	xhttp.send();
}
```

* 递归调用 => 嵌套调用

这里还需要进行算法优化，借着午后小憩的时间暂且先完成此DEMO，后继完善。

### <a name="551zyg"></a>完整DEMO

1. index.html

```html
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
		<li>1111</li><li>2222</li><li>3333</li>
	</ul>
</header>
```

1. demo.js

```js
/**
 *  数据校验
 */
var check = function(data) {
	if (typeof(data) === undefined || data === null || data === '' || data === undefined) return false;
	return true;
}

/**
 *	XMLHttpRequest Get Html Content
 *	@param	{String} method - 方法
 *	@param	{String}	url	- 路径
 *	@param	{Bool}	async	- 异步选项
 */
var loadHTML = function(method, url, async, callback) {
  var result = '';
  if (!check(method)) var method = 'GET';
  if (!check(async)) var async = false;
  var xhttp; // HTTPRequest
  if (window.XMLHttpRequest) {
    xhttp = new XMLHttpRequest();
  } else {
    xhttp = new ActiveXObject('Microsoft.XMLHTTP')
  }
  xhttp.onreadystatechange = function() {
    if (xhttp.readyState === 4 && xhttp.status === 0) {
      result = xhttp.responseText;
      callback(result);
    }
  }
  xhttp.open(method, url, async);
  xhttp.send();
}

/**
 *	html文件包含器
 *	调用方式：DOM内插入属性'include-html="路径"'
 */
var includeHandle = function() {
	var dom, // DOM节点
		url; // 文件路径
	dom = document.getElementsByTagName('*');
	for (var i = 0; i < dom.length; i++) {
		var bakNode = dom[i];
		url = bakNode.getAttribute('include-html');
		if (!check(url)) continue;
		var node = bakNode;
		node.removeAttribute('include-html');
		loadHTML('GET', url, true, function(result) {
			node.innerHTML = result;
			// 递归调用
			// includeHandle();
		});
	}
}
includeHandle();
```


