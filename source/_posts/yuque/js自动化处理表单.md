
---

title: js自动化处理表单

date: 2015-01-07 00:00:00 +0800

tags: [javascript,自动化]

---
我们在浏览网页时偶尔会碰到一些需要重复选择各种选项的尴尬局面，我们希望可以有一种工具可以帮助我们自动完成填表或者选择选卡项目。

<a name="ane9es"></a>
### [](#ane9es)实现原理

调用浏览器的控制台运行js脚本，从而达到自动填写表单和选择勾选项，以及自动提交等功能。

<!-- more -->

<a name="wccbgv"></a>
### [](#wccbgv)实现方法（例子）

- 获取到表单元素，首先需要浏览到你需要操作的网页，通过浏览器的审查元素或者查看源代码可以获取到按钮/选项/输入框在文档中的位置。


```javascript
//获取表单对象
var form = document.getElementsByTagName('form')[0];
var btn = document.getElementById('btn1');
//获取选项列表
var selList = form.getElementsByTagName('select');
var username = document.getElementById('username');
var password = document.getElementById('password');
```

- 利用js进行自动选择选项和提交功能。(自动填表也可以如法炮制)


```javascript
//遍历，填写选项
for (var i = 0, len = selList.length; i < len; i++) {
	selList[i].options[1].selected = 'selected';
	if (1 == i) {
		selList[i].options[2].selected = 'selected';
	};
};
//自动填表
username.value = 'test';
password.value = 'test';
//自动点击按钮
btn.click();
}
```

<a name="veydur"></a>
### [](#veydur)小结

- 需要对html有基本的了解，才能快速地通过审查元素找到需要操作的DOM对象

- 在一些带有iframe框架的网页，可以使用下面这条js语句获取iframe


```javascript
var frame = window.frames["zhuti"].document.getElementById('divJs');
```

- 在demo网页上通过浏览器控制台运行可以的显示效果


```javascript
(function juadge(num) {
	//获取表单对象
	var form = document.getElementsByTagName('form')[0];
	var btn = document.getElementById('btn1');
	//获取选项列表
	var selList = form.getElementsByTagName('select');
	var username = document.getElementById('username');
	var password = document.getElementById('password');

	if (1 == num) {
	   for (var i = 0, len = selList.length; i < len; i++) {
	   		//下标i为第i个选项，后面的下标1则是需要选取第几个选项
	    	selList[i].options[1].selected = 'selected';
	   }

	   //自动填表，设置用户名和密码
	   username.value = 'test';
	   password.value = 'test';

	   //自动点击按钮提交
	   btn.click();
	} else {
	   for (var i = 0, len = selList.length; i < len; i++) {
	      selList[i].options[0].selected = 'selected';
	   }
	   username.value = "";
	   password.value = "";
	}
})(num);
//num填写1为自动处理
//num填写0为清除表单
```

[查看demo](http://7u2liq.com1.z0.glb.clouddn.com/blog/demo/js自动处理表单/)

<a name="v540ts"></a>
### [](#v540ts)demo源代码

```html
<!DOCTYPE html>
<html>
   <head>
      <title>js自动处理表单</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
         <h1>js自动处理表单</h1>
         <form role="form">
            <div class="form-group">
               <p>选项1</p>
               <select class="form-control input-sm">
                  <option value="">默认选择</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
               </select>
            </div>
            <div class="form-group">
               <p>选项2</p>
               <select class="form-control input-sm">
                  <option value="">默认选择</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
               </select>
            </div>
            <div class="form-group">
               <p>选项3</p>
               <select class="form-control input-sm">
                  <option value="">默认选择</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
               </select>
            </div>
            <div class="form-group">
               <p>选项4</p>
               <select class="form-control input-sm">
                  <option value="">默认选择</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
               </select>
            </div>
            <div class="form-group">
               <p>选项5</p>
               <select class="form-control input-sm">
                  <option value="">默认选择</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
               </select>
            </div>

            <div class="form-group">
               <label for="firstname" class="col-sm-1 control-label">用户名:</label>
               <div class="col-sm-11">
                  <input type="text" class="form-control" id="username"
                     placeholder="请输入用户名">
               </div>
            </div> 

            <div class="form-group">
               <label for="lastname" class="col-sm-1 control-label">密码：</label>
               <div class="col-sm-11">
                  <input type="password" class="form-control" id="password" placeholder="请输入密码">
               </div>
            </div> 

            <div class="form-group">
               <button type="button" class="btn btn-primary" id="btn1" onclick="javascript:sub()">提交</button>
               <button type="button" class="btn btn-success" id="btn2" onclick="javascript:juadge(1)">自动填表</button>
               <button type="button" class="btn btn-warning" id="btn3" onclick="javascript:juadge(0)">恢复默认</button>
            </div>
         </form>
      </div>
      <script type="text/javascript">
         function sub() {
            alert("Submit");
         }

         function juadge(num) {
            //获取表单对象
            var form = document.getElementsByTagName('form')[0];
            var btn = document.getElementById('btn1');
            //获取选项列表
            var selList = form.getElementsByTagName('select');
            var username = document.getElementById('username');
            var password = document.getElementById('password');

            if (1 == num) {
               for (var i = 0, len = selList.length; i < len; i++) {
                  selList[i].options[1].selected = 'selected';
                  if (1 == i) {
                     selList[i].options[2].selected = 'selected';
                  };
               }

               //自动填表
               username.value = "test";
               password.value = "test";
               //自动点击按钮
               btn.click();
            } else {
               for (var i = 0, len = selList.length; i < len; i++) {
                  selList[i].options[0].selected = 'selected';
               }
               username.value = "";
               password.value = "";
            }
         };

      </script>

   </body>
</html>
```


