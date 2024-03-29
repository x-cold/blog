---
title: Docker大行其道—初识
urlname: zphz8h
date: '2016-05-29 00:00:00 +0800'
tags:
  - linux
  - docker
categories: []
---

随着分布式、云计算、大数据的火热爆发，大量的云计算集群出现，光凭计算机硬件配置的已经无法再次一较高下，虚拟化成为其中最核心的技术。虚拟化既可以通过硬件模拟，也可以通过操作系统层面去实现，近年来热火朝天的容器轻量级虚拟化，保留了操作系统本身的机制和特性，而 Docker 在此脱颖而出。

### Docker 的前世今生

Docker 是基于 Go 语言实现的云开源项目，目前归于 Apache 基金会并遵循 Apache 2.0 协议。诞生于 2013 年初，前身公司为 dotCloud，docker 开源后得到受到社会广泛的关注，docker 的生态圈体系也逐渐成熟，这家公司也改名为 Docker Inc，专注于 Docker 相关技术和产品开发。

<!-- more -->

Docker 最大的目标是：“Build, Ship and Run Any App, Anywhere！”。你只需要通过对应用组件的一次的封装，就能在任意地点构建和运行你的应用。无论是一个完整的应用，或者是某些微服务，甚至到一个完整的操作系统都能成为 docker 的应用组件。Docker 提供一个高效、敏捷和轻量的容器方案，能动态适应各种规模的系统部署需求。

Docker 整个生命周期包含三部分：镜像（Image），容器（Container），仓库（Repository）。镜像和容器的关系就像程序和进程，镜像是容器运行的一大前提，而容器则是镜像的一个运行实例。仓库则是镜像的管理中心，默认的镜像仓库为 Docker Hub。

![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530282528817-dfd72221-6fc4-4fb2-9f5a-da659e85f848.png#width=747)

Docker 运行容器前需要检查本地是否存在对应的镜像，如果不存在，会尝试从默认的镜像仓库下载。镜像实例化之后运行着一个完整的容器，容器除了镜像本身的内容外，还提供额外的可写文件层以及相对独立的运行环境（可能是一些应用或者服务，也可能是完整的操作系统）。

作为一个 C/S 模型的项目，Docker 通过 Docker Host 进行镜像、容器、守护进程、分区等的管理，同时在 Docker Client 进行镜像的拉取，容器的构建等操作，通常情况下 Host 和 Client 可能会在同一台机器上。

Docker 开源代码地址：[https://github.com/docker/docker](https://github.com/docker/docker)

### Docker 得天独厚的优势

### 新的部署方式

假如当前有这么一个场景：“由于业务增长，公司的一个网站项目需要迁移到新的服务器”。按照传统方案，我们很可能需要作一些重复性的工作。首先需要在新的服务器上安装对应的运行环境以及对应的依赖，如 LAMP（Linux+Apache+Mysql+PHP），创建对应的用户或组并进行文件权限的管理，耗费大量的精力后，还需要对该环境进行测试，最后才能部署上线。试想一下，如果这样的需求多少十几倍，这些工作需要重复的执行。

也许你会说可以通过虚拟化的技术将整个环境打包成镜像再进行部署，加入新的服务器本身也是一台虚拟化的机器，再加上一层 xen（或者其他虚拟机）去部署显然显得多余了。

而 Docker 提供一种极为简便的操作方式，通过容器来进行应用打包，我们可以通过封装成镜像或是编写 Dockerfile 等方式来进行打包，这意味着在新的服务器上只需要启动所需要的容器即可。一来节省了大量的时间投入，而来降低了部署过程出现问题带来的隐患。

### 运维策略的革新

1. 极速交付和部署

使用 docker，开发人员可以使用镜像快速构建一套标准的开发环境。之后的测试和上线环节完全可以复用这套镜像将应用部署到测试环境或生产环境等任意地方。Docker 可以快速创建、删除容器，并保留了每一个步骤的配置和操作过程，降低开发、测试、部署的时间的同时让环境部署更容易被理解。通过简单的配置文件修改，就能轻松完成一次运行环境的迭代，所有操作都可以以增量的形式进行分发和更新，从而实现自动化和高效的容器管理。

1. 性能损耗低

事实上 docker 是内核级别的虚拟化，不需要额外的虚拟化管理程序，因此开启 docker 对性能的损耗几乎忽略不计。

1. 轻便易迁移拓展

Docker 几乎支持任意平台运行，无论是物理机还是虚拟化的主机，甚至个人电脑都能兼容运行 docker，这种兼容性可以让应用更方便切换运行平台。

1. 规范化的标准

Docker 背后的标准化容器执行引擎 - runC。runC 是由 docker 贡献后续完善的一个开放的工业化标准，其主要内容：

- **操作标准化**：容器的标准化操作包括使用标准容器感觉创建、启动、停止容器，使用标准文件系统工具复制和创建容器快照，使用标准化网络工具进行下载和上传。

- **内容无关**：内容无关指不管针对的具体容器内容是什么，容器标准操作执行后都能产生同样的效果。如容器可以用同样的方式上传、启动，不管是 php 应用还是 mysql 数据库服务。

- **基础设施无关**：无论是个人的笔记本电脑还是 AWS S3，亦或是 Openstack，或者其他基础设施，都应该对支持容器的各项操作。

- **为自动化量身定制**：制定容器统一标准，是的操作内容无关化、平台无关化的根本目的之一，就是为了可以使容器操作全平台自动化。

- **工业级交付**：制定容器标准一大目标，就是使软件分发可以达到工业级交付成为现实。

1. 集群管理

Kubernetes 是 Google 开源的 Docker 容器集群管理系统，为容器化的应用提供资源调度、部署运行、服务发现、扩容缩容等整一套功能，本质上可看作是基于容器技术的 mini-PaaS 平台。

![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530282540268-e4b8ef20-e07f-40a7-9dc4-9df606ee60f9.png#width=747)

关于 Docker 和虚拟机的比较，请参考：[http://www.linuxprobe.com/docker-and-vm.html](http://www.linuxprobe.com/docker-and-vm.html)

关于 Docker 的标准，请参考：[http://www.open-open.com/lib/view/open1444481959869.html](http://www.open-open.com/lib/view/open1444481959869.html)

### 文章小节

全文主要对 docker 进行概念性的介绍，想必读到这里，docker 再也不会是一个陌生的技术。无论是在针对应用的自动化运维还是 PAAS 的管理策略，docker 都能提供一套优秀的解决方案，docker 在领域内倍受青睐，让运维的工作有了前所未有的优质体验。如果你也被 docker 的魅力深深折服的话，欢迎加入到 docker 的学习行列一同探索。
