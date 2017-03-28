---
title: Seajs 实践(二)—— 使用 spm3 构建项目
date: 2014-11-16 00:06:02
tags: [前端模块化,seajs,spm]
categories: 技术实践
description: Seajs 实践，使用 spm3 对 2048 游戏项目进行构建。
---

## 回顾

在[上一篇文章](http://blog.acwong.org/2014/11/15/2048-with-seajs/)中，利用 Seajs 对 2048 游戏进行了模块化。现在我们可以看到，在页面中使用`seajs.use("game/main")` 就能够自动加载其余的2个js文件。

[![2048网络请求](http://acwongblog.qiniudn.com/2048s-network.PNG)](http://acwongblog.qiniudn.com/2048s-network.PNG)

<!-- more -->

## 构建的意义

但是在实际的开发当中，通常会利用工具把多个 js 文件进行合并和压缩，减少服务器的请求次数，降低服务器的压力。

然而，使用传统的压缩工具对 CMD 模块进行压缩并不奏效，原因在于我们在写CMD模块的时候写的都是“匿名模块”，所以在使用普通工具合并之后 seajs 并不能识别出每一个“匿名模块”。因此，在合并之前还需要多一个步骤，就是将我们手写的 CMD 模块使用构建工具转换为 Modules/Transport 格式：

```javascript
define("id", ["dep-1", "dep-2"], function(require, exports, module) {
  // code
})
```

第一个参数id 用于识别各个模块。第二个参数指明该模块所依赖的模块，第三个就是原来写的函数。

## 构建过程

### spm3 介绍

**spm**(static package manager) 静态包管理工具，可以使用它来对CMD模块进行构建。spm3 是 spm 的新版本，它集成了**spm-build-deps** 的功能，可以直接使用它来构建。

spm3 与 spm2 的差异非常大，了解更多可以看[《spm3 发布通告》](https://github.com/spmjs/spm/issues/819) 和 [《spm@3.0 和 spmjs.org 的未来》](https://github.com/spmjs/spm/issues/718) 两篇文章。

### 去掉 CMD 模块的包装

spm3 当中，支持的书写规范从 CMD 模块 转向了 CommonJS。因此在构建之前，要先把原 CMD 模块的 `define` 包装去掉。构建之后 spm3 会自动在代码外添加

```javascript
define("id", ["dep-1", "dep-2"], function(require, exports, module)
```

包装(如果没有去掉，构建后会发现原 `define` 外又添加了一层 `define`，会导致代码不能执行)。

### 安装 spm3

要安装 spm3 先要安装 nodejs(这个应该大家都安装了吧)。然后,打开命令行工具安装 spm

```
npm install spm -g
```

输入
 
```
spm -v
```

出现版本号3.x.x安装成功。

### 创建 package.json

spm 使用与 npm 同样的文件 *package.json* 来描述要构建的项目。

package.json 可以手动创建，也可以用 `npm init` 等方法去创建。

```json
{
  "name": "2048",
  "version": "1.0.0",
  "description": "2048 with seajs",
  "author": "acwong",
  "license": "MIT",
  "spm": {
    "main": "static/game/main.js"
  }
}
```

`spm` 字段是包含与 spm 构建相关的一些属性。这里我们把入口文件定义为 *main.js* (默认为 *index.js*)。其余的属性可以参考[spm3官网的介绍](http://spmjs.io/documentation/package.json)。

### build

在项目的目录打开命令行工具，输入构建命令

```
spm build
```

等待一段时间，构建完成。

### 构建完成

构建完成之后,可以发现项目目录下多了一个文件夹 *dist*，这个就是存放构建后代码的地方。现在只要在页面文件中改动一下构建后的路径，就可以运行游戏了。

```javascript
seajs.config({
    base: "../dist/",
});
// 构建后入口文件的id
seajs.use("2048/1.0.0/static/game/main");
```

打开游戏，可以发现原来的3个 js 文件，现在只剩下 *main.js* 一个了。

[![2048构建后网络请求](http://acwongblog.qiniudn.com/2048ss-network.PNG)](http://acwongblog.qiniudn.com/2048ss-network.PNG)

[这里](https://github.com/acwong00/blog-demo-code/tree/master/seajs-2048/2048-with-seajs-and-spm3)可以查看最终的代码。

## 最后

由于 spm3 从 CMD 模块转向了 CommonJS 所以会导致一个问题，去掉 `define` 之后线下文件不能直接打开调试，所以 Seajs 退出了一个 seajs-wrap 的插件可以动态添加
 
```
define(function(require, exports, module) {})
``` 

seajs-wrap 在 *sea.js* 之后引入。

```html
<script src="path/to/sea.js"></script>
<script src="path/to/seajs-wrap.js"></script>
```

虽然有了这个插件，但是我认为还是不太便于使用，希望未来的版本可以有更好的解决方案。[了解更多请戳...](https://github.com/seajs/seajs-wrap)

这里只是简单谈谈我自己的一次实践过程，seajs还有更多强大的功能等着我们去学习。

感谢您的阅读，有不足之处请为我指出。

**参考**

1. [Develop A Package -- spmjs.io](http://spmjs.io/documentation/develop-a-package)
2. [为什么要有约定和构建工具](https://github.com/seajs/seajs/issues/426)
3. [为什么 SeaJS 模块的合并这么麻烦](http://chaoskeh.com/blog/why-its-hard-to-combo-seajs-modules.html)
4. [seajs-wrap 中文文档](https://github.com/seajs/seajs-wrap/issues/1)
