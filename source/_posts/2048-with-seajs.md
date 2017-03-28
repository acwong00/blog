---
title: Seajs 实践(一)—— 模块化 2048 游戏
date: 2014-11-15 23:43:42
tags: [前端模块化,seajs]
categories: 技术实践
description: Seajs 实践，使用 Seajs 对 2048 游戏进行模块化。
---

## 前言

前段时间在[慕课网](http://www.imooc.com/)跟着视频做了一个简单的 2048 游戏，发现这个小项目非常适合用来实践 Seajs 模块化，现在就把我的实践过程和大家分享一下。

<!-- more -->

## 实践过程

### 准备

没有进行模块化之前总共有5个文件：

- **index.html**        游戏页面
- **2048.css**          游戏样式文件
- **main.js**           程序入口文件
- **showanimation.js**  游戏动画文件
- **support.js**        基础函数文件

*main.js* 需要使用 *showanimation.js* 和 *support.js* 定义的函数。

*showanimation.js* 需要使用 *support.js* 定义的函数。

除了这些文件之外，这个项目还用了jQuery的库，用了[百度的cdn](http://apps.bdimg.com/libs/jquery/2.1.1/jquery.min.js)。

目前 js 文件引入顺序如下:

```html
<script src="http://apps.bdimg.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="../static/game/support.js"></script>
<script src="../static/game/showanimation.js"></script>
<script src="../static/game/main.js"></script>
```

### 目录结构

[![2048文件目录结构](http://acwongblog.qiniudn.com/2048-folder-structure.PNG)](http://acwongblog.qiniudn.com/2048-folder-structure.PNG)

源文件可以在[这里](https://github.com/acwong00/blog-demo-code/tree/master/seajs-2048/2048)找到，有兴趣的朋友可以下载下来尝试一下。

### 引入Sea.js

在[Seajs官网](http://seajs.org/docs/#downloads)下载Sea.js(本文用到的版本是 2.3.0)。在*static*目录下建立一个*lib*文件夹，存放下载下来的*sea.js*。

然后引入：

```html
<script src="../static/lib/sea.js"></script>
```

### CMD规范改写

CMD ( Common Module Definition ) 是Seajs遵循的一种模块定义规范。规范当中，一个模块就是一个文件，因此我按照CMD规范改写 2048 游戏的3个 js 文件。

> SeaJS 里，推崇的 Modules/Wrappings 规范是 CMD 规范：`define(function(){ })` 直接是由开发者手写的，写完后，可直接不经过任何构建工具就在浏览器上加载运行。

```javascript
 define(function(require, exports, module) {
     var a = require("a")
     exports.foo = ...
 });
```

首先，*main.js*、*showanimation.js* 和 *support.js* 三个文件都用 `defined` 函数包裹起来，`define` 接收一个匿名函数作为参数，该函数传入默认的三个参数  `require`、`exports` 和 `moudule` 。

```javascript
define(function(require, exports, moudule){
	// support.js 代码
});
```
```javascript
define(function(require, exports, moudule){
	// showanimation.js 代码
});
```
```javascript
define(function(require, exports, moudule){
	// main.js 代码
});
```

接着，把 *showanimation.js* 和 *support.js* 当中需要被其他模块调用的函数和变量使用 `exports` 暴露给其他模块。

```javascript
// 暴露变量
exports.documentWidth = documentWidth;
exports.gridContainerWidth = gridContainerWidth;
exports.cellSideLength = cellSideLength;
exports.cellSpace = cellSpace;

// 暴露函数
exports.getPostTop = function(i,j) {
    // code
};

exports.getPostLeft = function(i,j) {
    // code
};
......
```

然后，使用 `require` 来获取其他模块暴露的接口.

```javascript
// main.js
var support = require('./support');
var animation = require('./showanimation');
```

```javascript
// showanimation.js
var support = require('./support');
```

最后，将原来调用其它模块的方法或变量改写为，以下形式：

```javascript
var a = require('./a');
// 调用模块 a 的方法
a.doSomething();
```

```javascript
// main.js
// 调用变量
support.cellSpace = 20;
support.cellSideLength = 100;

// 调用 showanimation.js 方法
animation.showNumberWithAnimation(randx, randy, randNumber);
// 调用 support.js 方法
support.canMoveDown(board)
```

### 在页面当中加载入口模块

在引入 *sea.js* 之后，在该 **script** 标签之后，再写一段 seajs 的配置代码：

```javascript
seajs.config({
    base: "../static"
});

// 加载入口模块 
seajs.use(["game/main"]);
```

### 运行

经过上述过程之后 2048 游戏已经完成了模块化，现在打开浏览器运行一下,就可以正确运行了。

[![2048运行效果](http://acwongblog.qiniudn.com/2048s-start.PNG)](http://acwongblog.qiniudn.com/2048s-start.PNG)

[这里](https://github.com/acwong00/blog-demo-code/tree/master/seajs-2048/2048-with-seajs)是完成后的代码。

## 使用Seajs的意义

使用 Seajs 将各个文件转变成一个个独立的模块，模块当中可以方便的对函数和变量进行命名，免去了多个文件之间命名冲突的烦恼。除此之外，使用 Seajs 还可以在 js 文件当中声明所需的依赖，不再需要手动在引入过程中管理，降低了开发时出错的几率。

在 EMCAScript6 `import` 功能出现之前，Seajs 的确是一个不错的前端模块化工具。

[下一篇文章](http://blog.acwong.org/2014/11/16/2048-with-seajs-and-spm3/)，我会谈一下如何用 spm3 进行Seajs标准构建。

感谢您的阅读，有不足之处请为我指出。


**参考**

1. [CMD 模块定义规范](https://github.com/seajs/seajs/issues/242)
2. [CommonJS 的 Modules/Transport 和 Modules/Wrappings 规范有什么区别？ -- 知乎](http://www.zhihu.com/question/20789867/answer/16187950)
3. [前端模块化开发的价值](https://github.com/seajs/seajs/issues/547)
