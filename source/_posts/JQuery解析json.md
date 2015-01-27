title: JQuery解析json
date: 2015-1-26
tags: [js,jquery]
categories: js
---
json文件是一种轻量级的数据交互格式。一般在jquery中使用getJSON()方法读取。

```js
$.getJSON(url,[data],[callback])
// url：加载的页面地址
// data: 可选项，发送到服务器的数据，格式是key/value
// callback:可选项，加载成功后执行的回调函数
```
<!--more-->
### 实现过程
<a class="btn" href="http://7u2liq.com1.z0.glb.clouddn.com/blog/demo/json解析/html">查看demo</a>

+ 新建一个JSON格式的文件data.json 保存用户信息。如下:

```js
/** /js/data.json **/
[{
	"name": "xxxx",
	"phone": 18814111110,
	"email": "tt@admin.com",
	"qq": 123456789
}, 
{
	"name": "yyyy",
	"phone": 18814111110,
	"email": "tt@admin.com",
	"qq": 123456789
}, 
{
	"name": "zzzz",
	"phone": 18814111110,
	"email": "tt@admin.com",
	"qq": 123456789
}, 
{
	"name": "aaaa",
	"phone": 18814111110,
	"email": "tt@admin.com",
	"qq": 123456789
}, 
{
	"name": "bbbb",
	"phone": 18814111110,
	"email": "tt@admin.com",
	"qq": 123456789
}, 
{
	"name": "cccc",
	"phone": 18814111110,
	"email": "tt@admin.com",
	"qq": 123456789
}, 
{
	"name": "dddd",
	"phone": 18814111110,
	"email": "tt@admin.com",
	"qq": 123456789
}, 
{
	"name": "eeee",
	"phone": 18814111110,
	"email": "tt@admin.com",
	"qq": 123456789
}
]
```
+ 通过js获取JSON文件里的用户信息数据

```js
/** /js/state.js **/
(function getJson() {
	// 从JSON文件获取JSON对象
	$.getJSON("/js/data.json", function(data) {
		var content = document.getElementById('content-box');
		for (var i = 0; i < data.length; i++) {
			tr = document.createElement('tr');
			tr.innerHTML = '<td>' + (i + 1) + '</td>' 
				+ '<td>' + data[i].name + '</td>' 
				+ '<td>' + data[i].phone + '</td>' 
				+ '<td>' + data[i].email + '</td>' 
				+ '<td>' + data[i].qq + '</td>';
			content.appendChild(tr);
		};
	})
})();
```
+ 通过网页进行展示

```html
<!DOCTYPE html>
<!DOCTYPE html>
<html>
   <head>
      <title>JSON解析</title>
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
         <h1 class="text-center"><button class="btn btn-primary" onclick="getJson()">加载JSON</button></h1>
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

### 备注

1. JSON文件保存的字符串必需严格遵守json对象的格式
2. chrome不支持本地ajax，因此在运行时需要添加参数"chrome.exe --allow-file-access-from-files"