
---

title: Nginx虚拟主机管理系统 [HCI趣玩-2016年预热]

date: 2015-12-31 00:00:00 +0800

tags: linux,hci,nginx

---
欢迎来访HCI第一次趣玩作业，本次作业主要是完成简易的ningx虚拟主机管理系统。所涉及的知识涵盖linux的基本管理命令、nginx/ftp服务器配置、简单的前端页面处理和后台逻辑。

<a name="iftvmh"></a>
### [](#iftvmh)Nginx知多少

Nginx是一款轻量级的Web 服务器/反向代理服务器及电子邮件（IMAP/POP3）代理服务器，并在一个BSD-like 协议下发行。由俄罗斯的程序设计师Igor Sysoev所开发，供俄国大型的入口网站及搜索引擎Rambler（俄文：Рамблер）使用。其特点是占有内存少，并发能力强，事实上nginx的并发能力确实在同类型的网页服务器中表现较好，中国大陆使用nginx网站用户有：百度、新浪、网易、腾讯等。【摘抄自百度百科】

<!-- more -->

- 官方网站：[http://nginx.org](http://nginx.org)

- 淘宝运维的nginx-book(_想深入了解的同学看这里_): [https://github.com/taobao/nginx-book](https://github.com/taobao/nginx-book)


<a name="yhetnf"></a>
### [](#yhetnf)前言

- 体验传送门(新浪云)：[http://sinaapp.com/](http://sinaapp.com/)

- 概要：日常情况下我们经常把应用部署到公开于网络的服务器上，而应用通过IP或域名访问，但于IP（端口）的数量限制，我们不得不剑走偏锋使用共享IP的方式。于是虚拟主机技术横空出世，可以从一台网络服务器上分配出磁盘空间供用户放置站点、应用组件给不同的虚拟主机，提供必要的站点功能、数据存放和传输功能，因此一个IP（套接字）可以直接运行多个多个网络应用。类似于新浪云、西部数码等虚拟主机提供商如雨后春笋般拔地而起。


<a name="cuzpga"></a>
### [](#cuzpga)设计目标

- 一个可用的虚拟主机管理系统，可以添加/删除/修改/查看多个虚拟主机（只需支持静态文件服务器），同时生成一个账户（账号名+密码）对该主机进行管理。

- 每个虚拟主机对应一个域名和项目文件路径

- 每个虚拟主机所运行的项目文件路径（空间）由系统自动生成，选用ftp/svn/git其中一种代码部署方式控制


<a name="4vtcxf"></a>
### [](#4vtcxf)举个栗子

以下介绍的服务器为HCI内部服务器，运行着HCI的官方网站、竞考网微信公众号后台、weinre调试服务器等应用，所有应用使用不同的域名和同一个套接字（IP+端口）。下面我们来简单分析nginx的配置文件。

nginx.conf局部

```
# nginx.conf局部
# 添加虚拟主机配置文件目录

http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        types_hash_max_size 2048;
        server_names_hash_bucket_size 64;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;
        gzip_disable "msie6";

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;

        ##
        # nginx-naxsi config
        ##
        # Uncomment it if you installed nginx-naxsi
        ##

        #include /etc/nginx/naxsi_core.rules;

        ##
        # nginx-passenger config
        ##
        # Uncomment it if you installed nginx-passenger
        ##

        #passenger_root /usr;
        #passenger_ruby /usr/bin/ruby;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
        #===================================#
        include /etc/nginx/vhosts/*;	# 添加虚拟主机配置文件目录
        #===================================#
}
```

官网配置文件

```
# 官网配置（静态文件服务器+PHP）
# /etc/nginx/sites-enabled/default

#===============================
#
#       HCI Server
#
#================================
upstream nodejs__upstream {
        server 127.0.0.1:3000;
        keepalive 64;
}
server {
        listen 80 default_server;
        listen [::]:80 default_server ipv6only=on;
        server_name localhost scauhci.org www.scauhci.org;

        root /var/www/HCIWEB-SCAU/home;
        index index.php index.html index.htm;

        location / {
                try_files $uri $uri/ /index.php$is_args$args;
                client_max_body_size    10m;
                # proxy_pass http://localhost:3000;
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules
        }

        location ^~ /jingkao {
                proxy_pass http://nodejs__upstream;
        }

        location ~ \.php$ {
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME /etc/nginx/sites-enabled/default$fastcgi_script_name;
                include /etc/nginx/fastcgi_params;
        }
}
```

虚拟主机目录

```
# 虚拟主机目录
106 Dec  6 06:17 jingkao.com.conf
135 Dec 26 11:32 weinre.conf
111 Dec 13 16:19 xsx.conf
175 Jan 15 21:03 ypf.conf
131 Dec 25 16:34 zsl.conf
131 Dec 25 16:34 zsl.conf
```

虚拟主机实例：weinre服务器

```
# weinre服务器
server {
listen 80;
server_name weinre.scauhci.com;
location / {
		# 反向代理到服务器B的8080端口
        proxy_pass http://192.168.100.4:8080;
}
}
```

虚拟主机实例：用于本次作业的测试服务器

```
# 测试服务器
server {
listen 80;
server_name test1.scauhci.com;
root /var/www/test;
index index.html;
}
```

应用列表(就不一一例举全部应用了)：

- [HCI官网](http://www.scauhci.org)


运行在`http://www.scauhci.com/`和`http://121.201.58.180:80`上，项目文件路径为/var/www/HCIWEB-SCAU/home，假设此文件夹只能由FTP账户（账号名: hci，密码：hci_pass）使用ftp对`ftp://www.scauhci.com/hci_home/`进行读写。

- [用于本次作业的测试服务器](http://test1.scauhci.com)


运行在`http://weinre.scauhci.com/`和`http://121.201.58.180:80`上，项目文件路径为/var/www/test，假设此文件夹只能由FTP账户（账号名: hci1，密码：hci1_pass）使用ftp对`ftp://www.scauhci.com/test/`进行读写。

<a name="nmq5wr"></a>
### [](#nmq5wr)设计思路和流程

1. 熟悉Linux环境和Nginx的配置(需部分成员了解)

2. 设计WEB管理系统，需简单的数据库保存虚拟主机的信息（域名、文件路径等）以及管理员信息（只设计一名管理员）

3. 模拟管理虚拟主机，同时对vhosts文件进行文本分析，了解规则后可以进行虚拟主机的实际管理

4. 如有余力可继续实现服务器性能参数的可视化（CPU占用率/内存使用情况/硬盘容量等）<br />


![](https://cdn.yuque.com/yuque/0/2018/png/103147/1530282751584-bab5ba04-1af0-484d-bd72-f0d54ae130d7.png#width=677)

<a name="iccxea"></a>
### [](#iccxea)写几个可能遇到的问题

1. 文件权限的问题：每个应用对应的路径（文件夹）是相对独立的，且只能由对应的用户进行读写

2. 考虑到DNS服务器的复杂性问题，本次作业无须自己搭建DNS服务器，统一分配10个二级域名用于实验

3. nginx的平滑重载:`kill -HUP cat '/usr/local/nginx/logs/nginx.pid'`或者`nginx -s reload`

4. ftp/svn/git 服务器的配置不再赘述，各位还请发挥自我学习能力搜集资料。


<a name="l7mrdw"></a>
### [](#l7mrdw)技能列表

- [Linux入门知识](https://www.shiyanlou.com/courses/1)

- ssh/ftp(或者svn/git)/nginx等服务器搭建和配置

- nginx进阶配置

- 后端：简单的 数据库处理、文件处理、业务逻辑设计

- 前端：一个管理后台的页面/如有余力则设计可视化的性能监控图形界面

- 协作工具：git[(coding)](https://coding.net/git#)/[teambition](http://teambition.com/)

- 规范化的开发流程：需求文档->原型设计->（设计图）->开发->测试->上线


<a name="nkddns"></a>
### [](#nkddns)成果：

- 可展示和使用的虚拟主机管理系统

- 完整的源代码和文档


<a name="k5k5hn"></a>
### [](#k5k5hn)后话

本作业难度适中，但涉及的分支非常丰富，适于团队合作，期望各位能涉及多方面的技术，另外需要对项目有大局的思考方式。建议3-5人一组，可挑选一名13级的师兄/师姐作为指导。有任何问题可直接在`HCI@上有老下有小群`讨论。也可以在本文后面的评论框直接评论。

（懒懒的很久不写博客，各路大侠见谅）

