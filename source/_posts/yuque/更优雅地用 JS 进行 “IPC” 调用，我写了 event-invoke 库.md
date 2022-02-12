---
title: 更优雅地用 JS 进行 “IPC” 调用，我写了 event-invoke 库
urlname: sqrkko
date: '2022-02-12 17:08:14 +0800'
tags: []
categories: []
---

## 背景

团队最近有一个 Node.js 全新的模块需要开发，涉及多进程的管理和通讯，简化模型可以理解为需要频繁从 master 进程调用 worker 进程的某些方法，简单设计实现了一个 [event-invoke](https://github.com/x-cold/event-invoke) 的库，可以简单优雅进行调用。

> Node.js 提供了 child_process 模块，在 master 进程通过 fork / spawn 等方法调用可以创建 worker 进程并获取其对象（简称 cp）。父子进程会建立 IPC 通道，在 master 进程中可以使用 cp.send() 给 worker 进程发送 IPC 消息，而在 worker 进程中也可以通过 process.send() 给父进程发送 IPC 消息，达到双工通信的目的。（进程管理涉及更复杂的工作，本文暂不涉及）

## 最小实现

基于以上前提，借助 IPC 通道和进程对象，我们可以通过事件驱动的方式实现进程间的通信，只需要简单的几行代码，就能实现基本调用逻辑，例如：

```javascript
// master.js
const child_process = require('child_process');
const cp = child_process.fork('./worker.js');

function invoke() {
	cp.send({ name: 'methodA', args: [] });
  cp.on('message', (packet) => {
  	console.log('result: %j', packet.payload);
  });
}

invoke();

// worker.js
const methodMap = {
  methodA() {}
}

cp.on('message', async (packet) => {
  const { name, args } = packet;
  const result = await methodMap[name)(...args);
  process.send({ name, payload: result });
});
```

仔细分析上述代码实现，直观感受 invoke 调用并不优雅，并且当调用量较大时，会创建很多的 message 监听器，并且要保证请求和响应是一一对应，需要做很多额外的设计。**希望设计一个简单理想的方式，只需提供 invoke 方法，传入方法名和参数，返回一个 Promise，像调用本地方法那样进行 IPC 调用，而不用考虑消息通信的细节。**

```javascript
// 假想中的 IPC 调用
const res1 = await invoker.invoke("sleep", 1000);
console.log("sleep 1000ms:", res1);
const res2 = await invoker.invoke("max", [1, 2, 3]); // 3
console.log("max(1, 2, 3):", res2);
```

## 流程设计

从调用的模型看，可以将角色抽象为 Invoker 和 Callee，分别对应服务调用方和提供方，将消息通讯的细节可以封装在内部。parent_process 和 child_process 的通信桥梁是操作系统提供的 IPC 通道，单纯从 API 的视角看，可以简化为两个 Event 对象（主进程为 cp，子进程为 process）。Event 对象作为中间的双工通道两端，暂且命名为 InvokerChannel 和 CalleeChannel。
​

关键实体和流程如下：
![](https://cdn.nlark.com/yuque/__puml/389251cdfc899ca7af47f3fc7d6764b3.svg#lake_card_v2=eyJ0eXBlIjoicHVtbCIsImNvZGUiOiJAc3RhcnR1bWxcblxuYXV0b251bWJlclxuXG5hY3RvciBcInVzZXJcIiBhcyBVc2VyXG5wYXJ0aWNpcGFudCBcIkludm9rZXJcIiBhcyBJbnZva2VyXG5wYXJ0aWNpcGFudCBcIkludm9rZXJDaGFubmVsXCIgYXMgSW52b2tlckNoYW5uZWxcbnBhcnRpY2lwYW50IFwiQ2FsbGVlQ2hhbm5lbFwiIGFzIENhbGxlZUNoYW5uZWxcbnBhcnRpY2lwYW50IFwiQ2FsbGVlXCIgYXMgQ2FsbGVlXG5cbmFjdGl2YXRlIFVzZXJcblxuVXNlciAtPiBJbnZva2VyOiBpbnZva2VyLmludm9rZSgnbWV0aG9kQScsIGFyZ3MpXG5hY3RpdmF0ZSBJbnZva2VyXG5JbnZva2VyIC0-IEludm9rZXI6IHByb21pc2VNYXAuc2V0KG5hbWUsIHNlcSwgcHJvbWlzZSlcbkludm9rZXIgLT4gVXNlcjogcHJvbWlzZTxwZW5kaW5nPlxuXG5JbnZva2VyIC0-IEludm9rZXJDaGFubmVsOiBzZW5kTWVzc2FnZTpcXG57IG5hbWUsIGFyZ3MsIHNlcSB9XG5hY3RpdmF0ZSBJbnZva2VyQ2hhbm5lbFxuXG5JbnZva2VyQ2hhbm5lbCAtPiBDYWxsZWVDaGFubmVsOiBvbk1lc3NhZ2UoKVxuYWN0aXZhdGUgQ2FsbGVlQ2hhbm5lbFxuXG5JbnZva2VyIC0-IEludm9rZXI6IG9uVGltZW91dDogcmVqZWN0KClcblxuQ2FsbGVlQ2hhbm5lbCAtPiBDYWxsZWU6IGZ1bmN0aW9uTWFwLmdldChuYW1lKVxcbmV4ZWN1dGUgbWV0aG9kQShhcmdzKVxuYWN0aXZhdGUgQ2FsbGVlXG5cbkNhbGxlZSAtPiBDYWxsZWVDaGFubmVsOiBzZW5kTWVzc2FnZTpcXG57IG5hbWUsIHNlcSwgcGF5bG9hZCwgc3RhdHVzIH1cbmRlYWN0aXZhdGUgQ2FsbGVlXG5cdFxuQ2FsbGVlQ2hhbm5lbCAtPiBJbnZva2VyQ2hhbm5lbDogb25NZXNzYWdlKClcbmRlYWN0aXZhdGUgQ2FsbGVlQ2hhbm5lbFxuXHRcbkludm9rZXJDaGFubmVsIC0-IEludm9rZXI6IHByb21pc2VNYXAuZ2V0KG5hbWUsIHNlcSlcXG5yZXNvbHZlKHBheWxvYWQpL3JlamVjdCgpXG5kZWFjdGl2YXRlIEludm9rZXJDaGFubmVsXG5cblVzZXIgLT4gVXNlcjogcHJvbWlzZTxmdWxsZmlsbGVkIHwgcmVqZWN0ZWQ-XG5cbkBlbmR1bWwiLCJ1cmwiOiJodHRwczovL2Nkbi5ubGFyay5jb20veXVxdWUvX19wdW1sLzM4OTI1MWNkZmM4OTljYTdhZjQ3ZjNmYzdkNjc2NGIzLnN2ZyIsImlkIjoiVXB5eGMiLCJtYXJnaW4iOnsidG9wIjp0cnVlLCJib3R0b20iOnRydWV9LCJjYXJkIjoiZGlhZ3JhbSJ9)

- Callee 中注册可被调用的所有方法，并保存在 functionMap
- 用户调用 Invoker.invoke() 时：
  - 创建一个 promise 对象，返回给用户，同时将其保存在 promiseMap 中
  - 每次调用生成一个 id，保证调用和执行结果是一一对应的
  - 进行超时控制，超时的任务直接执行 reject 该 promise
- Invoker 通过 Channel 把调用方法消息发送给 Callee
- Callee 解析收到的消息，通过 name 执行对应方法，并将结果和完成状态（成功 or 异常）通过 Channel 发送消息给 Invoker
- Invoker 解析消息，通过 id+name 找到对应的 promise 对象，成功则 resolve，失败则 reject

​

实际上，这个设计不仅适用 IPC 调用，在浏览器的场景下也能直接得到很好的应用，比如说跨 iframe 的调用可以包装 window.postMessage()，跨标签页调用可以使用 storage 事件，以及 Web worker 中可借助 worker.postMessage() 作为通信的桥梁。

## 快速开始

基于以上设计，实现编码必然不在话下，趁着非工作时间迅速完成开发和文档的工作，源代码：[https://github.com/x-cold/event-invoke](https://github.com/x-cold/event-invoke)
​

### 安装依赖

```bash
npm i -S event-invoke
```

### 父子进程通信实例

> 示例代码：[Example code](https://github.com/x-cold/event-invoke/tree/master/examples/nodejs/child_process)

```javascript
// parent.js
const cp = require("child_process");
const { Invoker } = require("event-invoke");

const invokerChannel = cp.fork("./child.js");

const invoker = new Invoker(invokerChannel);

async function main() {
  const res1 = await invoker.invoke("sleep", 1000);
  console.log("sleep 1000ms:", res1);
  const res2 = await invoker.invoke("max", [1, 2, 3]); // 3
  console.log("max(1, 2, 3):", res2);
  invoker.destroy();
}

main();
```

```js
// child.js
const { Callee } = require("event-invoke");

const calleeChannel = process;

const callee = new Callee(calleeChannel);

// async method
callee.register(async function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
});

// sync method
callee.register(function max(...args) {
  return Math.max(...args);
});

callee.listen();
```

### 自定义 Channel 实现 PM2 进程间调用

> 示例代码：[Example code](https://github.com/x-cold/event-invoke/tree/master/examples/nodejs/pm2)

```javascript
// pm2.config.cjs
module.exports = {
  apps: [
    {
      script: "invoker.js",
      name: "invoker",
      exec_mode: "fork",
    },
    {
      script: "callee.js",
      name: "callee",
      exec_mode: "fork",
    },
  ],
};
```

```javascript
// callee.js
import net from "net";
import pm2 from "pm2";
import { Callee, BaseCalleeChannel } from "event-invoke";

const messageType = "event-invoke";
const messageTopic = "some topic";

class CalleeChannel extends BaseCalleeChannel {
  constructor() {
    super();
    this._onProcessMessage = this.onProcessMessage.bind(this);
    process.on("message", this._onProcessMessage);
  }

  onProcessMessage(packet) {
    if (packet.type !== messageType) {
      return;
    }
    this.emit("message", packet.data);
  }

  send(data) {
    pm2.list((err, processes) => {
      if (err) {
        throw err;
      }
      const list = processes.filter((p) => p.name === "invoker");
      const pmId = list[0].pm2_env.pm_id;
      pm2.sendDataToProcessId(
        {
          id: pmId,
          type: messageType,
          topic: messageTopic,
          data,
        },
        function (err, res) {
          if (err) {
            throw err;
          }
        }
      );
    });
  }

  destory() {
    process.off("message", this._onProcessMessage);
  }
}

const channel = new CalleeChannel();
const callee = new Callee(channel);

// async method
callee.register(async function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
});

// sync method
callee.register(function max(...args) {
  return Math.max(...args);
});

callee.listen();

// keep your process alive
net.createServer().listen();
```

```javascript
// invoker.js
import pm2 from "pm2";
import { Invoker, BaseInvokerChannel } from "event-invoke";

const messageType = "event-invoke";
const messageTopic = "some topic";

class InvokerChannel extends BaseInvokerChannel {
  constructor() {
    super();
    this._onProcessMessage = this.onProcessMessage.bind(this);
    process.on("message", this._onProcessMessage);
  }

  onProcessMessage(packet) {
    if (packet.type !== messageType) {
      return;
    }
    this.emit("message", packet.data);
  }

  send(data) {
    pm2.list((err, processes) => {
      if (err) {
        throw err;
      }
      const list = processes.filter((p) => p.name === "callee");
      const pmId = list[0].pm2_env.pm_id;
      pm2.sendDataToProcessId(
        {
          id: pmId,
          type: messageType,
          topic: messageTopic,
          data,
        },
        function (err, res) {
          if (err) {
            throw err;
          }
        }
      );
    });
  }

  connect() {
    this.connected = true;
  }

  disconnect() {
    this.connected = false;
  }

  destory() {
    process.off("message", this._onProcessMessage);
  }
}

const channel = new InvokerChannel();
channel.connect();

const invoker = new Invoker(channel);

setInterval(async () => {
  const res1 = await invoker.invoke("sleep", 1000);
  console.log("sleep 1000ms:", res1);
  const res2 = await invoker.invoke("max", [1, 2, 3]); // 3
  console.log("max(1, 2, 3):", res2);
}, 5 * 1000);
```

## 下一步

目前 [event-invoke](https://github.com/x-cold/event-invoke) 具备了优雅调用“IPC”调用的基本能力，代码覆盖率 100%，同时提供了相对完善的[类型描述](https://github.com/x-cold/event-invoke/blob/master/index.d.ts)。感兴趣的同学可以直接使用，有任何问题可以直接提 [Issue](https://github.com/x-cold/event-invoke/issues)。
​

另外一些后续仍要持续完善的部分：

- 更丰富的示例，覆盖跨 Iframe，跨标签页，Web worker 等使用场景
- 提供开箱即用通用 Channel
- 更友好的异常处理
