title: 咦？浏览器都能做人脸检测了？
author: 小冷
tags:
  - javascript
  - ''
  - 图像处理
  - html5
  - 人脸检测
categories:
  - javascript
date: 2017-08-10 23:28:00
---
Shape Detection API 的发布已经有一些时日，其主要的提供的能力是给予前端直接可用的特征检测的接口（包括条形码、人脸、文本检测）。本文将简单的对其进行介绍，对前端进行人脸检测进行普适性的讲解。（本文不讲算法～望轻拍）

# 1 背景与场景

人脸检测（Face Detection）算是老生常谈的课题了，在诸多行业应用广泛，例如金融、安防、电子商务、智能手机、娱乐图片等行业。其中涉及的技术也在不断的演变，下面简要介绍几种思路：

a. 基于特征的人脸检测

例如opencv中内置了基于Viola-Jones目标检测框架的Harr分类器，只需要载入一个配置文件（haarcascade_frontalface_alt.xml）就能直接调用detectObject去完成检测过程，同时也支持其他特征的检测（如鼻子、嘴巴等）。

b. 基于学习的人脸检测，其实也是需要通过算子提取的图像中的局部特征，通过对其进行分类、统计、回归等方式得到的具备更精确和快响应的分类器。

# 2 套路集锦

## 2.1 后端处理

前端通过网络将资源传输到后端，后端统一处理需要检测的图像或视频流，对后端的架构有一定的挑战，同时网络的延时往往不能给用户带来实时的交互效果。

## 2.2 客户端处理

得益于OpenCV在跨语言和跨平台的优势，客户端也能以较低的开发成本的提供人脸检测的能力，并且可以通过JsBridge等方式向web容器提供服务，然而一旦脱离这个容器，孤立的页面将失去这种能力。直到有一天……

## 2.3 开放服务

不知道从啥时候开始，云计算等概念拔地而起，计算的成本日益降低。各大研发团队（如阿里云、Face++）都蠢蠢欲动又不紧不慢的上架了人脸检测服务，甚至还带上了各种特！殊！服！务！，人脸识别、活体识别、证件OCR及人脸对比等等等。

尽管不仅提供了客户端的SDK以及前后端的API，但是，怎么说也要讲讲我纯前端的方案吧。

# 3 时代带来了什么

好吧，人脸识别在前端依然是在刀耕火种的远古时代，然而，我们的基础建设已经起步，希望后续的一些相关介绍能为各位看官带来一定的启发。

## [3.1 Shape Detection API](https://wicg.github.io/shape-detection-api/)

随着客户端硬件的计算能力逐渐提高，浏览器层面得到的权限也越来越多，由于图像处理需要耗费大量的计算资源，实际上浏览器上也能承担图像检测的一些工作，因此就搞出了个Shape Detection API。

以下几个简单的例子介绍了基本的用法，在尝试编辑并运行这些代码之前，请确保在你的Chrome版本以及该新特性已经被激活，另外该API受同源策略所限制：

> chrome://flags/#enable-experimental-web-platform-features

* 条形码：Barcode Detection (For Chrome 56+)

```js
var barcodeDetector = new BarcodeDetector();
barcodeDetector.detect(image)
  .then(barcodes => {
    barcodes.forEach(barcode => console.log(barcodes.rawValue))
  })
  .catch(err => console.error(err));
 ```

* 人脸：Face Detection (For Chrome 56+)

```js
var faceDetector = new FaceDetector();
faceDetector.detect(image)
  .then(faces => faces.forEach(face => console.log(face)))
  .catch(err => console.error(err));
```

* 文本：Text Detection (For Chrome 58+)

```js
var textDetector = new TextDetector();
textDetector.detect(image)
  .then(boundingBoxes => {
    for(let box of boundingBoxes) {
      speechSynthesis.speak(new SpeechSynthesisUtterance(box.rawValue));
    }
  })
  .catch(err => console.error(err));
```

## 3.2 图像中的人脸检测

图像的人脸检测比较简单，只需要传入一个图片的元素，就能直接调起该API进行人脸识别了。然后接住canvas我们可以将检测的结果展示出来。

![DingTalk20170807214620.png](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/bdf149b843cd097ef76f7fee1c36fd7a.png)

核心代码如下：

```js
var image = document.querySelector('#image');
var canvas = document.querySelector('#canvas');

var ctx = canvas.getContext("2d");
var scale = 1;

image.onload = function () {
  ctx.drawImage(image,
    0, 0, image.width, image.height,
    0, 0, canvas.width, canvas.height);

  scale = canvas.width / image.width;
};
function detect() {
  if (window.FaceDetector == undefined) {
    console.error('Face Detection not supported');
    return;
  }

  var faceDetector = new FaceDetector();
  console.time('detect');
  return faceDetector.detect(image)
    .then(faces => {
      console.log(faces)
      // Draw the faces on the <canvas>.
      var ctx = canvas.getContext("2d");
      ctx.lineWidth = 2;
      ctx.strokeStyle = "red";
      for (var i = 0; i < faces.length; i++) {
        var item = faces[i].boundingBox;
        ctx.rect(Math.floor(item.x * scale),
          Math.floor(item.y * scale),
          Math.floor(item.width * scale),
          Math.floor(item.height * scale));
        ctx.stroke();
      }
      console.timeEnd('detect');
    })
    .catch((e) => {
      console.error("Boo, Face Detection failed: " + e);
    });
}
```

## 3.3 视频中的人脸检测

视频中的人脸检测跟图像相差不大，通过`getUserMedia` 可以打开摄像头获取视频/麦克风的信息，通过将视频帧进行检测和展示，即可实现视频中的人脸检测。

![animation.gif](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/3f17c22d239ecd41d3668d9b59b25c9f.gif)

核心代码如下：

```js
navigator.mediaDevices.getUserMedia({
    video: true,
    // audio: true
  })
    .then(function (mediaStream) {
      video.src = window.URL.createObjectURL(mediaStream);
      video.onloadedmetadata = function (e) {
        // Do something with the video here.
      };
    })
    .catch(function (error) {
      console.log(error.name);
    });

  setInterval(function () {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(video, 0, 0);
    image.src = canvas.toDataURL('image/png');
    image.onload = function() {
      detect();
    }
  }, 60);
```

## 3.4 时光倒流到没有API的日子

实际上，在很久很久以前，也有不少解决方案存在。由于硬件条件以及没有硬件加速等限制的情况，一直没有被广泛地投入生产。

a. [tracking.js](https://github.com/eduardolundgren/tracking.js/) 

tracking.js 是一款js封装的图像处理的库，为浏览器带来丰富的计算视觉相关的算法和技术，通过它可以实现颜色追踪、人脸检测等功能，具体特性如下：

![DingTalk20170807003805.png](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/140e59c2efb6c14b83d9b15811e1b2aa.png)

b. [jquery.facedetection](https://github.com/jaysalvat/jquery.facedetection)

jquery.facedetection 是一款jquery / zepto 人脸检测插件，基于跨终端能力超强的[ccv](https://github.com/liuliu/ccv)中的图像分类器和检测器。

2.5 Node.js & OpenCv

[node-opencv](https://github.com/peterbraden/node-opencv) 模块已经发布了有些年头，尽管目前还不能完美兼容v3.x，提供的API也比较有限，但能完美兼容opencv v2.4.x。N-API的到来可能会带来更多的惊喜。

设想一下在一个Electron或者Node-Webkit容器中，我们是否可以通过本地开启websocket服务来实现实时的人脸检测呢？实现的思路代码如下：

+ 后端处理逻辑

```js
import cv from 'opencv';

const detectConfigFile = './node_modules/opencv/data/haarcascade_frontalface_alt2.xml';

// camera properties
const camWidth = 320;
const camHeight = 240;
const camFps = 10;
const camInterval = 1000 / camFps;

// face detection properties
const rectColor = [0, 255, 0];
const rectThickness = 2;

// initialize camera
const camera = new cv.VideoCapture(0);

camera.setWidth(camWidth);
camera.setHeight(camHeight);

const frameHandler = (err, im) => {
  return new Promise((resolve, reject) => {
    if (err) {
      return reject(err);
    }
    im.detectObject(detectConfigFile, {}, (error, faces) => {
      if (error) {
        return reject(error);
      }
      let face;
      for (let i = 0; i < faces.length; i++) {
        face = faces[i];
        im.rectangle([face.x, face.y], [face.width, face.height], rectColor, rectThickness);
      }
      return resolve(im);
    });
  });
};

module.exports = function (socket) {
  const frameSocketHanlder = (err, im) => {
    return frameHandler(err, im)
      .then((img) => {
        socket.emit('frame', {
          buffer: img.toBuffer(),
        });
      });
  };
  const handler = () => {
    camera.read(frameSocketHanlder);
  };
  setInterval(handler, camInterval);
};
```

+ 前端调用接口

```js
socket.on('frame', function (data) {
  var unit8Arr = new Uint8Array(data.buffer);
  var str = String.fromCharCode.apply(null, unit8Arr);
  var base64String = btoa(str);

  img.onload = function () {
    ctx.drawImage(this, 0, 0, canvas.width, canvas.height);
  }
  img.src = 'data:image/png;base64,' + base64String;
});
```

# 4 总结

## 4.1 未来的发展

这些前沿的技术将会在前端得到更为广泛的应用和支持是毋庸置疑的，未来的图像在前端也会随着传统图像处理->学习+图像处理的方式前进，这一切的功劳离不开基础设施(硬件、浏览器、工具、库等)的逐渐增强和完善，其中包括但不仅限于：

+ getUserMedia/Canvas   =>  图像 / 视频的操作
+ Shape Detection API   =>  图像检测
+ Web Workers           =>  并行计算能力
+ [ConvNetJS](http://cs.stanford.edu/people/karpathy/convnetjs/demo/mnist.html)             =>  深度学习框架

## 4.2 实际上并没有那么乐观

4.2.1 准确率

对于正脸(多个)的识别率还是比较高的，但是在侧脸已经有障碍物的情况下，检测的效果并不理想。

4.2.2 处理速度

对于图像中人脸检测的例子2.2，耗费时间300ms+（实际上无法满足大分辨率视频实时处理），是调用Opencv的检测速度100ms的三倍之多。

4.2.3 特性

还有很多需要完善的地方：如不支持眼镜状态、性别、年龄估计、表情识别、人种、笑容、模糊检测等主流服务提供商提供的服务。

## 4.3 想说又说不完的

a. Demo：
> https://github.com/x-cold/face-detection-browser

> https://github.com/x-cold/face-detection-nodejs

b. 关于人脸检测在不同场景的适应性，以及检测消耗的时间暂时没有数据支撑，后面考虑引入PASCAL VOC、AT&T提供的样本进行小规模的测试。

c.  招资深前端安卓IOS视觉交互：ais-ued-jobs@list.alibaba-inc.com

# 5 参考

1. 人脸识别技术大总结(1)：Face Detection & Alignment: http://blog.jobbole.com/85783/
2. 阿里巴巴直播防控中的实人认证技术: https://xianzhi.aliyun.com/forum/mobile/read/635.html
3. 前端在人工智能时代能做些什么？：https://yq.aliyun.com/articles/153198
4. ConvNetJS Deep Learning in your browser：http://cs.stanford.edu/people/karpathy/convnetjs/
5. Face detection using Shape Detection API：https://paul.kinlan.me/face-detection/
