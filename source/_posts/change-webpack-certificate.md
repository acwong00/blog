---
title: 记一次移动端开发环境调试
date: 2016-03-05 21:39:29
categories: 学习笔记
tags: [开发环境,webpack,https,openssl,移动前端]
description: 手机淘宝 https 环境调试经历，使用 openssl 生成证书替换 webpack 开发服务器无效证书
---

最近的一个项目要在手机淘宝客户端里面开发网页，由于淘宝目前全站https，所以在开发环境搭建时候遇到了之前没有料想到的一些问题，这里分享一下这次踩坑的经历。

<!-- more -->

## 一

在这个项目当中使用了 webpack 作为模块加载器，使用 webpack 进行前端开发一般会同时使用 webpack-dev-server 来提高开发的效率。

webpack-dev-server 会利用 Express 建立一个服务器，将打包后的 js 文件 引入到页面当中，即时反映对文件的修改。

在配置好 webpack 之后，运行之后发现 webpack-dev-server 加载的 js 文件并不能在页面上显示。经过一番研究之后发现这里涉及到了 https 的 Mixed Content 问题。

### Mixed Content

如果一个 HTTPS 网页当中有请求 HTTP 的资源，这种网页就被称为 **Mixed Content Page**。

Mixed Content 被分为两类 **Optionally-blockable Content** 和 **Blockable Content**。

####  Optionally-blockable Content

Optionally-blockable Content 包括一些引入风险较低的资源:

- &lt;img&gt;
- &lt;audio&gt;
- &lt;video&gt;

在现代的浏览器当中这些资源即时不是通过 https 引用也会被加载到页面当中。

[![](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_mixed-content-2.png)](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_mixed-content-2.png)

#### Blockable Content

而其他的引入风险较高的资源就被称为 Blockable Content，包括 &lt;script&gt;、&lt;link&gt;、&lt;iframe&gt; 等。这些资源如果是通过 http 协议引用的话是不会被加载到页面当中的。

[![](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_mixed-content-1.png)](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_mixed-content-1.png)

### 解决方法

既然知道问题所在，解决的方法也就非常简单了，修改一下 webpack-dev-server 的配置，启用 https 协议。

```javascript
new WebpackDevServer(webpack(config), {
	// 省略其余代码
	https: true  // 启用 https 
}).listen(3000, function(err, res) {});
```

## 二

启用了 https 协议之后，依然无法正常访问 webpack 打包的资源。在桌面浏览器访问一些 https 网站时候经常会看到这样的画面：

[![](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_https-wran.PNG)](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_https-wran.PNG)

出现这个画面的原因是网站的证书不受信任，在桌面端的浏览器可以点击继续前往来访问不受信任的资源。而在移动端的浏览器除了少数的浏览器（如：uc浏览器）可以访问不受信任的资源之外，大部分的浏览器会直接禁止访问。

### 解决方法

要在手机浏览器上访问 https 协议的 webpack-dev-server 服务器上面的资源，就要安装匹配服务器的证书。

打开 node-module 找到 webpack-dev-server 会发现一个叫 ssl 的文件夹，这就是用来放置 webpack-dev-server 证书的地方。

[![](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_server-ssl.png)](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_server-ssl.png)

现在把客户端用的 ca.crt 证书安装到手机上，搞定。

## 三

安装完证书之后再打开手机淘宝，发现静态资源依然不能访问，打开手机安装的证书发现 webpack-dev-server 的证书已经过期了T_T。

[![](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_expired.jpg)](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_expired.jpg)

再看看 webpack-dev-server github 的项目，发现这些证书最近的更新是一年前。看来现在只能自己去生成新的自签证书了。

[![](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_webpakc-dev-server-github.png)](http://7q5etm.com1.z0.glb.clouddn.com/2016-03_webpakc-dev-server-github.png)

查看 webpakc-dev-server 的代码：

```javascript
// using built-in self-signed certificate if no certificate was configured
options.https.key = options.https.key || fs.readFileSync(path.join(__dirname, "../ssl/server.key"));
options.https.cert = options.https.cert || fs.readFileSync(path.join(__dirname, "../ssl/server.crt"));
options.https.ca = options.https.ca || fs.readFileSync(path.join(__dirname, "../ssl/ca.crt"));
```

要替代原来的证书需要生成这三个文件。

### 解决方法

生成自签的证书最常见的方法就是用 OpenSSl 工具，在 Mac OSX 上面默认已经安装了。

首先要生成一个证书颁发机构(CA)根证书，利用这个根证书可以创建客户端使用的证书，还需要用根证书去对服务端使用的证书进行签名。

创建CA证书首先创建私钥文件，2048指的是私钥的位数：

```bash
openssl genrsa -out CA.key 2048
```

然后创建证书：

```bash
openssl req -x509 -new -key CA.key -out CA.crt -days 730
```

创建证书的过程当中需要填写一系列的信息，其中要留意 **Common Name** 需要填写服务器的域名，经过个人的测试在安卓机上即使证书是被信任的，但是 **Common Name** 的域名并不对应的话资源同样是无法访问的。CA.crt 已经可以发送到移动设备上面使用了。

然后创建服务端使用的证书。同样先创建私钥文件：

```bash
openssl genrsa -out server.key 2048
```

然后创建一个证书请求，填写与CA根证书相应的信息：

```bash
openssl req -new -out server.req -key server.key
```

利用CA证书签发服务端使用的证书：

```bash
openssl x509 -req -in server.req -out server.crt -CAkey CA.key -CA CA.crt -days 365 -CAcreateserial -CAserial serial
```

最后把生成的证书替换 ssl 文件夹里面的内容，大功告成，webpack-dev-server 上的资源可以成功访问了。

**参考**

[在iOS上使用自签名的SSL证书](http://beyondvincent.com/2014/03/17/2014-03-17-five-tips-for-using-self-signed-ssl-certificates-with-ios/)
