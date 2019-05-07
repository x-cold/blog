
---

title: Javascript 设计模式之单例模式

date: 2017-09-10 23:28:00 +0800

tags: javascript,设计模式

---
单例模式是一个非常典型的设计模式，保证一个类只有唯一实例，并且提供单一的访问点。单例的对象不同于静态类，我们可以延迟单例对象的初始化，通常这种情况发生在我们需要等待加载创建单例的依赖。

<a name="x86ogl"></a>
#### [](#x86ogl)单例的特性

- 全局唯一实例

- 单一的访问入口


<!-- more -->

<a name="b3t1da"></a>
#### [](#b3t1da)如何创建一个单例？

接下来我将以设计一个全局的Loading状态的实例以渐入佳境。

> 你不是真正的单例？


```javascript
var createLoading = function(){
	var LOADING_TPL =
    '<div class="loading-container">' +
    '<div class="loading">' +
    '</div>' +
    '</div>';
	var loading = document.createElement('div');
   loading.innerText = LOADING_TPL;
   
   return document.body.appendChild(loading);	// 创建一个loading实例
}
```

Excuse me？这就是传说中的单例模式吗？

<a name="6hokkg"></a>
#### [](#6hokkg)典型应用场景

- 惰性单例：在合适的时候才创建对象，如缓存对象等。

- 单例服务：Angular 1.x 的服务实例

- 单例组件：全局唯一的遮罩层、弹窗等


<a name="pdxpeh"></a>
#### [](#pdxpeh)小结

单例模式能够我们能在全局的上下文环境下获取唯一的对象，这种特性适用于多次调用的对象。

