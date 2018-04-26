title: 你可能不知道的 Date 类
author: 小冷
date: 2017-12-17 13:36:58
tags:
  - javascript
  - Date
categories:
  - javascript

---
Date 是 JS 中的重要的一个内置对象，其实例主要用于处理时间和日期，其时间基于 1970-1-1 (世界标准时间)起的毫秒数，时间戳长度为 13 位（不同于 Unix 时间戳的长度 10 位）。对于日期和时间，我们有无数的使用场景，因此需要特别注意一些细节和约定。

<!-- more -->


### 1. 构造函数


通过 new Date() 可以进行实例化，得到一个 Date 对象实例，值得注意的是如果直接执行 `Date()` ，将得到一个时间字符串。


```js
new Date();
new Date(value);
new Date(dateString);
new Date(year, month[, day[, hour[, minutes[, seconds[, milliseconds]]]]]);
```

其中对构造函数的参数说明(参考 MDN )：

* 如果没有输入任何参数，则Date的构造器会依据系统设置的当前时间来创建一个Date对象。

* 如果提供了至少两个参数，其余的参数均会默认设置为1（如果没有提供day参数）或者0。

* JavaScript的时间是由世界标准时间（UTC）1970年1月1日开始，用毫秒计时，一天由86,400,000毫秒组成。Date对象的范围是-100,000,000天至100,000,000天（等效的毫秒值）。

* JavaScript的Date对象为跨平台提供了统一的行为。时间属性可以在不同的系统中表示相同的时刻，而如果使用了本地时间对象，则反映当地的时间。

* JavaScript 的Date对象提供了数个UTC时间的方法，也相应提供了当地时间的方法。UTC，也就是我们所说的格林威治时间，指的是time中的世界时间标准。而当地时间则是指执行JavaScript的客户端电脑所设置的时间。

* 以一个函数的形式来调用JavaScript的Date对象（i.e., 不使用 new 操作符）会返回一个代表当前日期和时间的字符串。


### 2. 空值处理


```js
// 以chrome为例
new Date();
// Mon Oct 23 2017 23:38:02 GMT+0800 (CST)

new Date(false);
// Thu Jan 01 1970 08:00:00 GMT+0800 (CST)

new Date(0);
// Thu Jan 01 1970 08:00:00 GMT+0800 (CST)

new Date(null);
// Thu Jan 01 1970 08:00:00 GMT+0800 (CST)

new Date('');
// Invalid Date

new Date(undefined);
// Invalid Date
```


### 3. 特别提示

[Firefox]

不支持带 '-' 的完整时间，比如 new Date('2012-07-08 00:00:00') 为无效的值，而 new Date('2012-07-08') 是正确的值。


[month]

* new Date(year, month, ……) 中的month从0开始计算


### 4. 值的边界


不同执行环境下的边界值有差异， Chrome 下甚至连负值都能支持。在实际生产环境中，不仅需要考虑时间的展示，还需要考虑其存储、计算等，因此在特定的场景下，我们需要尽可能考虑到数据库和浏览器中 Date 的有效范围。

以数据库 `Derby` 存储时间为例，其边界为：


| 说明 | 边界值 |
| :--- | :--- |
| 最小的日期 | 0001-01-01 |
| 最大的日期 | 9999-12-31 |
| 最小的时间 | 00:00:00 |
| 最大的时间 | 24:00:00 |
| 最小的时间戳 | 0001-01-01-00.00.00.000000 |
| 最大的时间戳 | 9999-12-31-23.59.59.999999 |

在 `mysql` 中，其范围定义为 `1000-01-01`to`9999-12-31`；
在 `js` 中，时间戳的最小值为 `-8640000000000000` 即公元前 271,821 年 4 月 20 日，最大值为 `8640000000000000`，即 275,760 年 9 月 13 日。规范中时间范围为 1970/1/1 前后 `100,000,000` 天。


### 5. 2038 年虫

听说，2038 年之后时间戳不够用了。

> 在计算机应用上，2038年问题可能会导致某些软件在2038年无法正常工作。所有使用UNIX时间表示时间的程序都将受其影响，因为它们以自1970年1月1日经过的秒数（忽略闰秒）来表示时间。这种时间表示法在类Unix（Unix-like）操作系统上是一个标准，并会影响以其C编程语言开发给其他大部份操作系统使用的软件。在大部份的32位操作系统上，此“time_t”数据模式使用一个有正负号的32位元整数(signedint32)存储计算的秒数。依照此“time_t”标准，在此格式能被表示的最后时间是2038年1月19日03:14:07，星期二（UTC）。超过此一瞬间，时间将会被掩盖（wrap around）且在内部被表示为一个负数，并造成程序无法工作，因为它们无法将此时间识别为2038年，而可能会依个别实作而跳回1970年或1901年。错误的计算及动作可能因此产生。

实际上参考第 4 部分，Date 的上限绰绰有余，大家可以拿起手头的设备测试一下 2038 年会出现怎样的异状。


### 6. 参考

1、EmacScript 语言规范 - [http://ecma-international.org/ecma-262/5.1/#sec-15.9](http://ecma-international.org/ecma-262/5.1/#sec-15.9)

2、Mysql 时间范围 - [https://dev.mysql.com/doc/refman/5.5/en/datetime.html](https://dev.mysql.com/doc/refman/5.5/en/datetime.html)

3、JS 时间戳边界 - [https://stackoverflow.com/questions/11526504/minimum-and-maximum-date](https://stackoverflow.com/questions/11526504/minimum-and-maximum-date)

### 7. 库

- [moment](https://github.com/moment/moment) - 重量级时间处理库，支持时间解析、格式化、计算等，功能强大，支持浏览器和 Node.js，压缩后体积约为 16.3 KB
- [date-fns](https://github.com/date-fns/date-fns) - 较 moment 更轻量级的事件处理库，体积更小


