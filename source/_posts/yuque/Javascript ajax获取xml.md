
title: Javascript ajax获取xml
date: 2015-02-12 00:00:00
tags: [javascript,xml]
categories: 
---

### <a name="drxfnz"></a>ajax简介

* AJAX = 异步 JavaScript 和 XML
* AJAX 是一种在无需重新加载整个网页的情况下，能够更新部分网页的技术
* AJAX 是一种用于创建快速动态网页的技术

<!-- more -->

### <a name="lucpnp"></a>ajax操作xml可以快速建立轻量级的动态网站,下面是实例：

[查看demo](http://7u2liq.com1.z0.glb.clouddn.com/blog/demo/ajax/html/)

* /js/state.js

```js
function loadXMLDoc(url) {
	var xmlhttp;
	var content,tr,temp,data;
	// 创建请求对象
	if (window.XMLHttpRequest) {
		// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp = new XMLHttpRequest();
	} else {
		// code for IE6, IE5
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	// 处理返回的请求，其中返回的格式为XML
	xmlhttp.onreadystatechange = function() {
		// 注意当xml为本地文件时，xmlhttp.status一直保持为0
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			var List = xmlhttp.responseXML.documentElement.getElementsByTagName("CONTACT");
			for (var i = 0; i < List.length ; i++) {
				content = document.getElementById('content-box');
				tr = document.createElement('tr');
				temp = "<td>" + (i+1) + "</td>";
				data = List[i].getElementsByTagName("NAME");
				{
					try {
						temp += "<td>" + data[0].firstChild.nodeValue + "</td>";
					} catch (er) {
						temp += "<td> </td>";
					}
				}
				data = List[i].getElementsByTagName("PHONE");
				{
					try {
						temp += "<td>" + data[0].firstChild.nodeValue + "</td>";
					} catch (er) {
						temp += "<td> </td>";
					}
				}
				data = List[i].getElementsByTagName("EMAIL");
				{
					try {
						temp += "<td>" + data[0].firstChild.nodeValue + "</td>";
					} catch (er) {
						temp += "<td> </td>";
					}
				}
				data = List[i].getElementsByTagName("QQ");
				{
					try {
						temp += "<td>" + data[0].firstChild.nodeValue + "</td>";
					} catch (er) {
						temp += "<td> </td>";
					}
				}
				tr.innerHTML = temp;
				content.appendChild(tr);
			}

		}
	}
	xmlhttp.open("GET", url, true);
	xmlhttp.send();
}

```

* /html/index.html

```html
<!DOCTYPE html>
<html>
   <head>
      <title>AJAX解析</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <!-- 引入 Bootstrap -->
      <link href="http://apps.bdimg.com/libs/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet">

      <!-- HTML5 Shim 和 Respond.js 用于让 IE8 支持 HTML5元素和媒体查询 -->
      <!-- 注意： 如果通过 file://  引入 Respond.js 文件，则该文件无法起效果 -->
      <!--[if lt IE 9]>
         <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
         <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
      <![endif]-->
   </head>
   <body>
      <div class="container">
         <h1 class="text-center"><button class="btn btn-primary" onclick="loadXMLDoc('../xml/data.xml')">加载AJAX</button></h1>
         <!-- main body start -->
         <div class="col-md-12">
            <table class="table table-striped table-bordered">
               <thead>
                 <tr>
                   <th>#</th>
                   <th>姓名</th>
                   <th>手机号</th>
                   <th>邮箱</th>
                   <th>QQ</th>
                 </tr>
               </thead>
               <tbody id="content-box">
               </tbody>
            </table>
         </div>
      </div>
      <!-- jQuery (Bootstrap 的 JavaScript 插件需要引入 jQuery) -->
      <script src="https://code.jquery.com/jquery.js"></script>
      <!-- 包括所有已编译的插件 -->
      <script src="../js/state.js"></script>
   </body>
</html>
```

* /xml/data.xml

```xml
<!--  Contacts List -->
<LIST>
	<CONTACT>
		<NAME>qqqq</NAME>
		<PHONE>13322332233</PHONE>
		<EMAIL>qq@admin.com</EMAIL>
		<QQ>123456</QQ>
	</CONTACT>
	<CONTACT>
		<NAME>tttt</NAME>
		<PHONE>13322332233</PHONE>
		<EMAIL>qq@admin.com</EMAIL>
		<QQ>123456</QQ>
	</CONTACT>
	<CONTACT>
		<NAME>gggg</NAME>
		<PHONE>13322332233</PHONE>
		<EMAIL>qq@admin.com</EMAIL>
		<QQ>123456</QQ>
	</CONTACT>
	<CONTACT>
		<NAME>aaaa</NAME>
		<PHONE>13322332233</PHONE>
		<EMAIL>qq@admin.com</EMAIL>
		<QQ>123456</QQ>
	</CONTACT>
	<CONTACT>
		<NAME>xxxx</NAME>
		<PHONE>13322332233</PHONE>
		<EMAIL>qq@admin.com</EMAIL>
		<QQ>123456</QQ>
	</CONTACT>
	<CONTACT>
		<NAME>zzzz</NAME>
		<PHONE>13322332233</PHONE>
		<EMAIL>qq@admin.com</EMAIL>
		<QQ>123456</QQ>
	</CONTACT>
</LIST>
```


