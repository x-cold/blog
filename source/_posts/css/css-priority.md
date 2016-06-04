title: CSS优先级
date: 2015-1-25
tags: css
categories: css
---
+ [1位重要标志位] > [4位特殊性标志] > 声明先后顺序
```Bash
!important > [ id > class > tag ]
```
ps：使用!important可以改变优先级别为最高，其次是style对象，然后是id > class > tag ，另外，另外在同级样式按照申明的顺序后出现的样式具有高优先级。

<!-- more -->

+ 4位特殊性标志 [0.0.0.0]：从左至右，每次给某一个位置+1，前一段对后一段具有无可辩驳的压倒性优势。无论后一位数值有多大永远无法超过前一位的1。
	+ 内联样式 [1.0.0.0]
	A：<span id="demo" style="color:red "></span>
    B：还有就是JS控制的内联样式style对象，document.getElementById("demo").style.color="red";
   	两者属于同一级别，不过一般情况是JS控制的内联样式优先级高，这与先后顺序申明有关系与本质无关，因为往往DOM操作是在DOM树加载完毕之后。
    + ID选择器 [0.1.0.0]
    + 类，属性，伪类 选择器 [0.0.1.0]
    + 元素标签，伪元素 选择器 [0.0.0.1]


+ LVHA伪类,样式按LVHA优先级顺序从右至左覆盖，不同的顺序会产生不同的效果。
    a:link - 默认链接样式
    a:visited - 已访问链接样式
    a:hover - 鼠标悬停样式
    a:active - 鼠标点击样式
