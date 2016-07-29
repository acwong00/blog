---
title: Node.js 练习 —— 逼死强迫症头像
date: 2015-01-29 11:35:27
tags: [图像处理,Node.js]
categories: 技术实践
description: Node.js 小练习，使用 Node.js 在图像上添加模拟提示信息数字。
---

最近在 GitHub 上看到了一个名为 [Python 练习册](https://github.com/Show-Me-the-Code/show-me-the-code)的项目。这个项目让大家用 Python 来完成一些简单的小练习，题目也同样适用于其他的语言，这里就 Node.js 来写完成一些小练习。

<!-- more -->

## 题目0000

> 将你的 QQ 头像（或者微博头像）右上角加上红色的数字，类似于微信未读信息数量那种提示效果。 类似于图中效果

>  ![题目0000图片](https://camo.githubusercontent.com/d518d3929e4054ce2f9183b23e52908da7e5632d/687474703a2f2f692e696d6775722e636f6d2f736732646b75592e706e673f31)


## 图片库选择

这个题目要求的是在图片上添加一个数字，然后完成前阵子很流行的模拟提示数字逼死强迫症的效果。在 Python 当中要作图通常会使用 Pillow 库。而在 Node.js 当中我选择了较为全面的 [gm](http://aheckmann.github.io/gm/) 库。当然，还有其他的选择，可以参考 [StackOverflow 的答案](http://stackoverflow.com/questions/10692075/which-library-should-i-use-for-server-side-image-manipulation-on-node-js)。


## 安装 gm

要使用 gm 首先要在系统安装 [GraphicsMagick](http://www.graphicsmagick.org/) 或者 [ImageMagick](http://www.imagemagick.org/)。这里我选择了 ImageMagick。在 Ubuntu 系统里面非常简单：

```
sudo apt-get install imagemagick
```

然后用 *npm* 安装 gm 库：

```
npm install gm
```

## 开始作图

先来看看最终的效果：

![acwong_afeter](https://raw.githubusercontent.com/acwong00/node_exercise/master/0000/acwong2.jpg)

因此，现在就要在原图的右上角画上一个红色的圆和白色的数字。

这里我主要用到 gm 的 `drawCircle` 和 `drawCircle` 的方法分别用来画圆和数字。

直接上代码：

```javascript
var fs = require('fs')
  , gm = require('gm')  // 加载 gm 模块
  , readStream = fs.createReadStream("acwong.jpg");  // 创建流
gm(readStream,'acwong.jpg')
    .options({imageMagick: true})  // 使用 ImageMagick 
    .size({bufferStream: true}, function(err, size){
        // 使用 size 方法获取图像的尺寸
        if (err) {
            throw err;
        } else {
            var width = parseInt(size.width);
            var height = parseInt(size.width);
            this.fill("#ff0000");
            // 画圆
            this.drawCircle(width-30, 30, width-30, 0);
            this.fill("#ffffff");
            this.fontSize("50");
            // 画数字
            this.drawText(width-45, 50, "7");
            this.write("acwong2.jpg", function(err){
                if (err) {
                    throw err;
                } else {
                    console.log("done");
                }
            });
        }
    });
```

运行程序：

```
node test
```

命令行中出现 **done** 打开新的图片 *acwong2.jpg* 就可以看到效果了。

感谢您的阅读，有不足之处请为我指出。

