title: js-class
date: 2015-09-19 19:15:18
tags: Javascript
categories: [Javascript, js进阶]
---
![title](/img/title/1.jpg)
### 众所周知，Javascript是一门非常灵活语言，在js的高级特性中，不乏有类似其他高于语言（如C++、Java）中涉及到的类。

### Javacript关键字new

js作为一门若变量类型的语言，在js中，一切的变量和函数都是对象的表现，拥有对象的属性、方法、原型链拓展的权限。

举个简单的例子：

```Javascript
var arr = new Array();
arr.push(1);
arr.push('test');
arr.push({data: 'data'});
console.log(arr);
// 输出[1, "test", Object]
console.log(arr.length);
// 输出3，集成length属性
arr = arr.toString();
console.log(arr);
//输出1,test,[object Object]，继承了Object类中的toString方法.
```

这里通过new Array() 创建了一个名字为arr的数组(类)的对象，arr对象继承了Array对象的属性和方法。


### 设计一个Javascript的类

```Javascript
// 构造方法
function Position (x, y, z) {
	this.x = x;
	this.y = y;
	this.z = z;
}
(function newPos() {
	var res = Position(1, 2, 3);
	var pos = new Position(1, 2, 3);
	console.log(res);
	// 输出undefinded
	console.log(pos);
	// 输出Position {x: 1, y: 2, z: 3}
}());
```

上面的函数定义了一个名字为Position类的构造函数，注意里面的this关键字，详情参考[]()，创建实例时，我们使用了new关键字，这时候Javascript的解析引擎申请了一块堆内存，并将this指向该对象;

### 添加一个方法

```Javascript
// 构造方法
function Position (x, y, z) {
	this.x = x;
	this.y = y;
	this.z = z;
	this.map = function() {
		console.log('Here is {x: ' + this.x + ', y: ' + this.y + ', z: ' + this.z + '}');
	}
}
var pos = new Position(3, 4, 5);
pos.map();
```





