
---

title: Javascript之window对象

urlname: gh8736

date: 2015-03-01 00:00:00 +0800

tags: [javascript]

categories: []

---

说到window对象我们不得不提及BOM，BOM是browser object model的缩写，正如其名为浏览器对象模型。BOM提供了独立于内容而与浏览器窗口进行交互的对象，BOM由一系列相关的对象组成，其中最主要对象为window，下面我们将分类讲解window对象。

<a name="i5qgoi"></a>
### 概述

window对象是BOM顶层(核心对象)，其他对象均为window对象延伸拓展，成为其子对象。直接调用其子对象可以不指明window对象，其子对象或者函数的作用域为全局（我们可以在局部的作用域定义window.variable将变量提升为全局变量）。接下来我们将从其子对象和函数两方面刨析。

<!-- more -->

[w3school对window对象的叙述](http://www.w3school.com.cn/jsref/dom_obj_window.asp)

```javascript
// true
window.navigator === navigator;
```

<a name="3ibpel"></a>
### self对象

self对象与window对象完全一致，self通常用于确认在当前窗口内。

```javascript
// true
window.self === window;
// true
self.self === self;
```

<a name="h3rstg"></a>
### 子对象(下面对于子对象函数的描述均省略显示使用window对象)

![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530282924354-52404bad-0b55-42bf-b181-09641b534884.png#width=525)


1、window.frames[]<br />如果文档包含框架（frame 或 iframe 标签），浏览器会为 HTML 文档创建一个 window 对象，并为每个框架创建一个额外的 window 对象。通过frames[name][或frames.name](http://xn--frames-o06l.name)（name为框架的name）获取框架的window对象。

_注释：没有应用于 window 对象的公开标准，不过所有浏览器都支持该对象。_

test.html

```html
<html>
<head>
	<title>test</title>
</head>
<body>
	<p>test</p>
	<iframe src="./test.html" name="myFrame"></iframe>
	<script type="text/javascript">
		window.onload = function () {
			console.log(frames["myFrame"]);
		}
	</script>
</body>
</html>
```

获取框架数量

```javascript
// 无框架则为0
window.length
```

返回父对象

```javascript
// true
frames["myFrame"].parent === window;
```

返回顶层元素

```javascript
// true
frames["myFrame"].top === window;
```

2、window.navigator(只读引用)

Navigator 对象包含有关浏览器的信息。

属性 | 描述<br />appCodeName | 返回浏览器的代码名。<br />appName | 返回浏览器的名称。<br />userAgent | 返回由客户机发送服务器的 user-agent 头部的值。<br />appVersion | 返回浏览器的平台和版本信息。<br />platform | 返回运行浏览器的操作系统平台。<br />appMinorVersion	| 返回浏览器的次级版本。<br />browserLanguage | 返回当前浏览器的语言。<br />cookieEnabled | 返回指明浏览器中是否启用 cookie 的布尔值。<br />cpuClass | 返回浏览器系统的 CPU 等级。<br />onLine | 返回指明系统是否处于脱机模式的布尔值。<br />systemLanguage | 返回 OS 使用的默认语言。<br />userLanguage | 返回 OS 的自然语言设置。

---add-in<br />geolocation | 返回地理位置信息

3、window.screen(只读引用)

Screen 对象中存放着有关显示浏览器屏幕的信息。JavaScript 程序将利用这些信息来优化它们的输出，以达到用户的显示要求。

属性 | 描述<br />availHeight | 返回显示屏幕的高度 (除 Windows 任务栏之外)。<br />availWidth | 返回显示屏幕的宽度 (除 Windows 任务栏之外)。<br />bufferDepth | 设置或返回调色板的比特深度。<br />colorDepth | 返回目标设备或缓冲器上的调色板的比特深度。<br />deviceXDPI | 返回显示屏幕的每英寸水平点数。<br />deviceYDPI | 返回显示屏幕的每英寸垂直点数。<br />fontSmoothingEnabled | 返回用户是否在显示控制面板中启用了字体平滑。<br />height | 返回显示屏幕的高度。<br />logicalXDPI | 返回显示屏幕每英寸的水平方向的常规点数。<br />logicalYDPI | 返回显示屏幕每英寸的垂直方向的常规点数。<br />pixelDepth | 返回显示屏幕的颜色分辨率（比特每像素）。<br />updateInterval | 设置或返回屏幕的刷新率。<br />width | 返回显示器屏幕的宽度。

4、window.location<br />Location 对象包含有关当前 URL 的信息。

属性 | 描述<br />hash | 设置或返回从井号 (#) 开始的 URL（锚）。<br />host | 设置或返回主机名和当前 URL 的端口号。<br />hostname | 设置或返回当前 URL 的主机名。<br />href | 设置或返回完整的 URL。<br />pathname | 设置或返回当前 URL 的路径部分。<br />port | 设置或返回当前 URL 的端口号。<br />protocol | 设置或返回当前 URL 的协议。<br />search | 设置或返回从问号 (?) 开始的 URL（query部分）。

属性 | 描述<br />assign() | 加载新的文档。<br />reload() | 重新加载当前文档。<br />replace() | 用新的文档替换当前文档。

5、window.history(只读引用)<br />History 对象包含用户（在浏览器窗口中）访问过的 URL。_是一个类似于栈的数据结构_

属性 | 描述<br />length | 返回浏览器历史列表中的 URL 数量。

函数 | 描述<br />back() | 后退(history列表上一个URL)<br />forward() | 前进(history列表下一个URL)<br />go() | 加载history列表中某个一个URL<br />6、window.document

<a name="14gbaw"></a>
### 函数

1、窗体控制函数

- moveBy()<br />可相对窗口的当前坐标把它移动指定的像素。

- moveTo()<br />把窗口的左上角移动到一个指定的坐标。


```javascript
// 右移x，下移y
window.moveBy(x,y);

// 直接到(x, y)坐标
window.moveTo(x,y);
```

- resizeBy()<br />按照指定的像素调整窗口的大小。

- resizeTo()<br />把窗口的大小调整到指定的宽度和高度。


```javascript
// 窗口宽度增加width，高度增加height
resizeBy(width,height);
// 窗口宽度设置为width，高度设置为height
resizeTo(width,height);
```

2、滚动轴控制函数

- scrollTo()<br />按照指定的像素值来滚动内容。

- scrollBy()<br />把内容滚动到指定的坐标。


```javascript
// 向右滚动xs，向下滚动ys
scrollBy(xs, ys);
// 滚动到(xs，ys)
scrollTo(xs, ys);
```

3、窗体焦点控制函数<br />_腾讯的在线笔试似乎就是用这个防止作弊的(切换窗口)_

- focus()<br />将键盘焦点赋予某一窗口。

- blur()<br />把键盘焦点从顶层窗口移开。


4、 新建窗体函数

- open()<br />open() 方法用于打开一个新的浏览器窗口或查找一个已命名的窗口。[参考文档](http://www.w3school.com.cn/jsref/met_win_open.asp)

- close()<br />close() 方法用于关闭浏览器窗口。


```javascript
// 打开窗口
var testWin = window.open("http://www.w3school.com.cn","_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=400, height=400");

// 关闭窗口
testWin.close;
```

5、对话框函数

- alert()<br />显示带有一段消息和确认按钮的警告框。

- confirm()<br />显示带有一段消息以及确认按钮和取消按钮的对话框。返回值为（确认按钮 ？ true : false）

- prompt()<br />显示带有一段消息以及输入框、确认按钮和取消按钮的对话框。<br />_返回值为：输入的字符串或者null（取消按钮）_


```javascript
// alert()
alert('hello');

// confirm()
confirm('确认吗？') ? console.log('您点击了确认') : console.log('您点击了取消');

// prompt
var string = prompt('请输入学号');
string !== null ? console.log('学号是' + string) : console.log('您点击了取消'');
```

6、时间等待和间隔函数

- setTimeout()/clearTimeout()<br />按照指定的周期（以毫秒计）来调用函数或计算表达式 / 取消前者设定的计时器

- setInterval/clearInterval()<br />在指定的毫秒数后调用函数或计算表达式 / 取消前者设定的计时器


<a name="bz4aqn"></a>
### 其他属性

1、状态栏属性

- window.defaultStatus<br />设置或返回窗口状态栏中的默认文本。

- window.status<br />设置窗口状态栏的文本。


2、窗口大小

- innerHeight<br />页面可视化区域的高度（包含滚动条）

- innerWidth<br />页面可视化区域的宽度（包含滚动条）

- outerHeight<br />窗口可视化区域的高度（包含页面可视化区域和浏览器状态栏、工具栏等，即屏幕高度减去任务栏的高度）

- outerWidth<br />窗口可视化区域的宽度（解释同上）


3、位置偏移

- pageXOffset<br />设置或返回当前页面相对于窗口显示区左上角的 X 位置。

- pageYOffset<br />设置或返回当前页面相对于窗口显示区左上角的 Y 位置。

- screenLeft / screenTop / screenX / screenY


_只读整数。声明了窗口的左上角在屏幕上的的 x 坐标和 y 坐标。IE、Safari 和 Opera 支持 screenLeft 和 screenTop，而 Firefox 和 Safari 支持 screenX 和 screenY_

4、opener<br />返回对创建此窗口的窗口的引用。

5、窗口关系

- name<br />设置或返回窗口的名称。

- parent<br />返回父窗口。

- top<br />返回顶层的先辈窗口。

- closed<br />返回一个窗口是否关闭。


<a name="diclku"></a>
### 事件

另开一篇文章详述javascript的事件，关于window的事件不再重复赘述。

