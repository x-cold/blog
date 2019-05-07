
---

title: Mac mini 2014 款拆解

date: 2019-03-28 10:00:41 +0800

tags: []

---
最近入手了一款 Mac mini (Late 2014) 中配版本，主要用于 Work At Home 的一些需求，替换掉我原来的 Mac Mini (2011) 款。由于自带的 HDD 1TB 5400R 的硬盘的读写速度的限制，系统运行效率受到很大的制约，我选择升级到 SDD 以提高机器的性能。

> 温馨提示：2014 款的 Mac mini 的内存是焊死在主板上的，无法进行内存升级。


<a name="77f721d4"></a>
## SSD 选用

首先，2014 款支持两种升级 SSD 的方式，**加装 PCIe SSD** 和替换原有 **SATA HDD**。

- Mac mini 主板上有预留一个 PCIe 的接口（传输速度限制在 700MB/s 左右），需要通过转接卡才能使用标准的 PCIe / NVMe 的 SSD；
- Mac mini 有且仅有一个 SATA HDD，升级 SATA SSD 必须替换到原有的 HDD；

<!-- more -->

|  | SATA SSD | PCIe SSD |
| --- | --- | --- |
| 传输速率 | 500MB/s (Samsang 860 EVO 500G 为例，下同) | 读取 3000MB/s, 写入2300MB/s (Sumang 970 Plus EVO  250G 为例，下同) |
| 价格 | ￥529 / 500G | ￥499 / 250G |
| 额外设备 | 无 | [NVMe PCIe x4 M.2 NGFF转 late 2014苹果 Mac mini A1347 SSD 转接卡]() |
| 拆装难度 | 需要拆解整机，替换原有 HDD | 只需要拆开底壳，主板表面即可安装 |
| 总结 | 总体上来看，升级 SATA SSD 的性价比要优于 PCIe SSD，但是需要拆解整机，需要一定的动手能力。另外原有的 HDD 也无法同时使用。 | PCIe SSD 的优势很明显，传输速率明显比传统的 SATA SSD 更快一些，另外还能跟原有的 HDD 共存，可以保持更大的存储空间。<br />但是受限于主板接口的传输速率的限制，PCIe SSD 应有的传输速率会大打折扣 (读写 700MB/s)。 |

综上，按照个人的需求可以选择一套合适的方案进行 SSD 的升级，个人建议需要大容量或者“不喜欢动手”的同学可以选择 PCIe SSD，追求性价比的同学推荐直接升级 SATA SSD (500G+ 的 SSD 正在成为主流)。关于 SSD 的选购可以参考这个[文章](https://zhuanlan.zhihu.com/p/40555331)。

<a name="9a2b769a"></a>
## 拆解步骤

> 拆解过程中基本没拍照，所以就只能引用参考资料的图片啦


<a name="88210852"></a>
### 准备工作

Mac mini 的组装相对普通的主机更为精细，使用的螺丝都是非常迷你的，以 T6H 为主，部分是普通的小十字螺丝。拆机过程记得对螺丝做好分类哦。

- T6H 螺丝刀
- 十字螺丝刀

一套小米家装的[精修工具箱](https://detail.tmall.com/item.htm?id=563193067319&skuId=3543342140610) (￥99) 就能解决啦~

<a name="717287d5"></a>
### 拆开底壳

使用稍微坚硬点的卡片，撬开黑色底壳；


![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552791318220-de5c1020-3c64-441d-aff9-4a6ef44bedf6.png#align=left&display=inline&height=444&name=image.png&originHeight=444&originWidth=592&size=216358&status=done&width=592)

拧下电磁屏蔽层的六枚螺丝，翘起一半**（注意不要直接打开）**，然后从主板卸下 Wifi 的连接线，取下电磁屏蔽层。


![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552791717666-0b64066c-ce50-4651-ab07-6bca12ed51df.png#align=left&display=inline&height=444&name=image.png&originHeight=444&originWidth=592&size=254350&status=done&width=592)

<a name="8c47ecd4"></a>
### 分割线

如果是加装 PCIe SSD，往下的步骤就不需要再进行下去了，只需要把 SSD 装进去转接卡上，然后将转接卡安装到主板表面即可。


![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552792965448-06555547-bce5-4847-a131-91421dd6cd59.png#align=left&display=inline&height=1024&name=image.png&originHeight=1024&originWidth=1366&size=1480881&status=done&width=1366)

<a name="e9812d11"></a>
### 卸载风扇

> 通常来说，无线网卡无需进行拆卸。


拧开固定风扇的螺丝，卸下风扇的接线（在 Wifi 接线的旁边），取出风扇。


![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552791918748-295fd5ba-f018-49f2-baf0-89c577e85f10.png#align=left&display=inline&height=444&name=image.png&originHeight=444&originWidth=592&size=296012&status=done&width=592)

<a name="7fe43ee3"></a>
### 取下主板

主板的拆解即是细致活，也是体力活。首先把 Mac mini 表面所有的排线和接口全部卸下，然后取出固定的螺丝。<br />
![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552792295593-1b7802ba-a1ce-46d6-80cc-0aaf8666a278.png#align=left&display=inline&height=482&name=image.png&originHeight=482&originWidth=638&size=464488&status=done&width=638)<br />
<br />蓝色区域是电源排线，也需要先推出来

接下来则是体力活了，用两只螺丝刀插入到这两个洞口**（务必插到最底部），然后往外用力推开。**

![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552792411854-d3976262-312c-455e-ac38-b4094e37e018.png#align=left&display=inline&height=483&name=image.png&originHeight=483&originWidth=642&size=354782&status=done&width=642)


![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552792502983-a70adf16-3524-4366-bf9f-eb0a7fe55004.png#align=left&display=inline&height=444&name=image.png&originHeight=444&originWidth=592&size=114993&status=done&width=592)

<a name="a5c28012"></a>
### 抽出电源

抽出电源之前一定要确保蓝色框的电源线接口已经拔出。电源的输入口就是我们插入电源线的接头，稍微拉松一下最下面的金属滑片，旋转接口至 90 度，可以明显感觉到松动感，抽出电源。

![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552792715272-71e2e732-b88d-4738-95de-e6ce9348bf96.png#align=left&display=inline&height=444&name=image.png&originHeight=444&originWidth=592&size=114055&status=done&width=592)

<a name="c27ff29f"></a>
### 替换硬盘

最后剩下的硬盘托架非常容易拆卸，往外一拉就出来了

![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552793027234-233cf2f3-89f7-44ab-b0ff-d966018d0793.png#align=left&display=inline&height=444&name=image.png&originHeight=444&originWidth=592&size=252148&status=done&width=592)

![image.png](https://cdn.nlark.com/yuque/0/2019/png/103147/1552793042179-20a64d5e-5b53-4496-a938-335982c18891.png#align=left&display=inline&height=444&name=image.png&originHeight=444&originWidth=592&size=217700&status=done&width=592)

然后替换上新的 SSD 即可（建议使用之前先测试一下 SSD 的可用性）。按照拆机的步骤反向进行即可重新组装好你的 Mac mini。

<a name="93a461ab"></a>
## 系统安装

系统安装可以通过三种方式进行安装，这里只介绍几个方法，不做深入的教程了，大家可以参考网上很多详细的教程。

- （如果你的系统是完整可运行的）直接从 App Store 下载和安装最新的 OSX，只需要搜索 “macos mojave”，然后根据提示安装到对应的硬盘就好了；
- 制作 OSX 的 U 盘启动，具体查阅参考资料的教程；
- 使用 Apple 官方提供的网络恢复；

<a name="5db9fd7c"></a>
## 小结

相较于 2011 款等的 Mac mini，2014 年款主板内存焊死，升级空间限制非常大，不过好在 2018 年款的 Mac mini 又可以进行内存升级了✌️。尽管在 SATA 接口的数量从两个减少到一个的情况下，还新增了一个 PCIe 的接口，硬盘数量上还是能接受的，当然升级的成本是增加了不少（PCIe SSD 和 SATA SSD 的差价，以及转接卡的购买）。

总体上来说，换上新的 SSD 的 2014 款 Mac mini 还是非常流畅的，足以应对绝大多数的办公和家庭娱乐的场景。

<a name="35808e79"></a>
## 参考资料

1、[《升级或安装 Mac mini 中的内存》](https://support.apple.com/zh-cn/HT205041)<br />2、[《2014 款苹果 Mac Mini 拆机组图》](http://www.mac52ipod.cn/post/apple-mac-mini-2014-teardown.php?page=1∂=1)<br />3、[《Mac mini 换SSD拆机详细教程》](http://www.iphoneba.net/2525.html)<br />4、[《Mac mini 2014 late 加装PCIe SSD纪实》](https://bbs.feng.com/read-htm-tid-11750596.html)<br />5、[《制作 macOS Mojave U盘USB启动安装盘方法教程 (全新安装 Mac 系统)》](https://www.iplaysoft.com/macos-usb-install-drive.html)<br />6、[《关于 macOS 的恢复功能》](https://support.apple.com/zh-cn/HT201314)<br />7、[《通过“启动转换”在 Windows 中使用 Apple 键盘》](https://support.apple.com/zh-cn/HT202676)<br />8、[《小白SSD固态硬盘选购指南》](https://zhuanlan.zhihu.com/p/40555331)

