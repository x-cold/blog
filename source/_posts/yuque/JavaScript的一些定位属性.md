---
title: JavaScript的一些定位属性
urlname: mdfepb
date: '2015-01-20 00:00:00 +0800'
tags:
  - javascript
categories: []
---

### Javascript 定位属性

- clientHeight\clientWidth
  可见窗口除去 margin 和 border 之后的高度\宽度

- offsetHeight\offsetWidth
  clientHeight 的基础上加 border 和滚动条的高度\宽度

<!-- more -->

- scrollHeight\scrollWidth
  元素内容的实际高度（内容多了可能会改变对象的实际宽度）

- clientTop\clientLeft
  子元素 margin 之后父元素 padding 之前的高度\宽度

- offsetTop\offsetLeft
  该元素的上 border 的上边缘到该元素的 offsetParent 的上 border 内边缘的垂直\水平距离

- scrollTop\scrollLeft
  对象的最顶部（左侧）到对象在当前窗口显示的范围内的顶边（左边）的距离，即是在出现了纵向滚动条的情况下，滚动条拉动的距离

关于 offsetParent，不同的浏览器有不同的实现算法，其中一种常见布局在各种浏览器中 offsetParent 是一样的：
外层元素 div 的 position 计算值是 relative、absolute 时，内层元素 div 的 offsetParent 总是外层元素 div。

### 下面是一个简单的 demo 页面

[查看 demo](http://7u2liq.com1.z0.glb.clouddn.com/blog/demo/JS定位属性/)
