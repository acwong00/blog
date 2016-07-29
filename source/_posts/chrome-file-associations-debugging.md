---
title: Chrome 浏览器文件关联调试方法
date: 2015-05-26 14:12:27
tags: [Chrome,调试]
categories: 学习笔记
description: Chrome 浏览器使用技巧，文件关联调试
---

Chrome 浏览器和 FireFox 浏览器一直是前端工程师热爱的两款浏览器。除了因为它们对新的开发标准支持程度高以外，最大的原因莫过于它们都支持强大的调试功能。

<!-- more -->

相比而言，我更加习惯于使用 Chrome 浏览器进行调试，今天就介绍一个 Chrome 浏览器的一个文件关联调试方法，使调试的时候更加高效。

## 不利用文件关联的调试方式

通过一个例子来说明。

文件结构。

![文件结构](http://acwongblog.qiniudn.com/2015-05_hello-folder-structure.PNG)

```html
<!-- hello.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hello World</title>
    <link rel="stylesheet" type="text/css" href="style/hello.css">
</head>
<body>
    <h1>Hello World</h1>
</body>
</html>
```

```css
/* hello.css */
h1 {
    font-size: 60px;
}
```

以往的调试方式，我们会在 Chrome 调试相应的 CSS 样式，然后再回到 CSS 文件当中修改相应的语句，然后返回到浏览器查看效果。这种调试方法的缺点在于，我们需要不断切换浏览器和编辑器的界面去修改代码。

[![旧的调试方式](http://acwongblog.qiniudn.com/2015-05_old-debugging.gif)](http://acwongblog.qiniudn.com/2015-05_old-debugging.gif)

## 文件关联调试方式

### 建立关联

文件关联顾名思义就是在浏览器的调试功能下绑定我们本地的文件，在浏览器当中修改属性，本地的文件就会自动被修改。

首先在需要调试的页面打开调试控制台，然后点击 *Sources* 的 tab，右键点击添加开发项目的目录。

[![添加相关目录](http://acwongblog.qiniudn.com/2015-05_add-folder.gif)](http://acwongblog.qiniudn.com/2015-05_add-folder.gif)

然后把相应的文件建立关联，这个时候浏览器会请求重启。

[![添加文件关联](http://acwongblog.qiniudn.com/2015-05_map-network.gif)](http://acwongblog.qiniudn.com/2015-05_map-network.gif)

好了，这个时候，浏览器会根据我们关联的文件，自动把相关的其他文件也作一个关联（如本例当中的 hello.css）。当在调试界面修改语句并且保存(Ctrl + s)的时候，chrom 会同步更新本地的文件。

[![更新样式](http://acwongblog.qiniudn.com/2015-05_update-css.gif)](http://acwongblog.qiniudn.com/2015-05_update-css.gif)

### 删除关联

删除关联的方式也非常简单，只要在已经关联的文件当中右键点击 *Remove network mapping* 即可。

感谢你的阅读，有不足之处请为我指出。
