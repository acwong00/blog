---
title: 一些常见的图片 hover 效果
date: 2015-03-17 12:08:31
tags: [CSS,CSS3,CSS3动画]
categories: 技术研究
description: 介绍一些常见的图片 hover 效果以及它们的实现方式。
---

图片 hover 效果是指鼠标移上图片时候产生的一些交互效果，在各大网站上都非常常见，这里介绍一下一些常见的图片 hover 效果以及它们的实现方式。

<!-- more -->

## 图片透明度改变效果

改变透明度是我们最常见的图片 hover 效果，实现方式也非常简单，只要鼠标移动到图片上的时候改变它的透明度就可以了。

```css
/* 减少透明度 */
#pic1 {
    opacity: 1;
}
#pic1:hover {
    opacity: 0.5;
}

/* 增加透明度 */
#pic2 {
    opacity: 0.5;
}
#pic1:hover {
    opacity: 1;
}
```

还可以加上一些过渡效果。

```css
#pic1, #pic2 {
    transition: 1s;
}
```

[看例子](https://jsfiddle.net/acwong/nrwkfq91/)

网站实例：[花瓣网](http://huaban.com/)

## 遮罩层效果

第二种效果也非常常见，就是在图片上面添加一层遮罩层，鼠标移动到图片上方时实现各种效果。

### 遮罩层透明度改变效果

与上面改变透明度的方法类似，但是这里不是直接改变图片的透明度，而是在图片外添加一个透明的遮罩层。

```html
<!-- 加上遮罩层 -->
<div class="pic">
    <img src="http://acwongblog.qiniudn.com/2015-03_example-picture.jpg" id="pic1">
    <div class="mask" id="mask1"></div>
</div>
```

```css
.pic {
    position: relative;
}
.mask {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    transition: .5s;
}
```

然后就可以添加不同的效果。

```css
#mask1 {
    background-color: chocolate;
    opacity:0;
}
.pic:hover #mask1 {
    opacity: 0.3;
}

#mask2 {
     background-color:black;
     opacity:0.3;
}
.pic:hover #mask2 {
     opacity: 0;
}

/* 渐变效果 */
#mask3 {
    background:linear-gradient(top,orange,chocolate);
    background:-webkit-linear-gradient(top,orange,chocolate);
    background:-moz-linear-gradient(top,orange,chocolate);
    opacity:0.5 
}
.pic:hover #mask3 {
     opacity: 0;
}
```

[看例子](https://jsfiddle.net/acwong/nrwkfq91/1/)

网站实例：[LOFTER](http://www.lofter.com/)、[36氪](http://www.36kr.com/)

### 遮罩层位移效果

第二种遮罩层显示效果是遮罩层从各个方向移动到图片上方，此时遮罩层通常会承载对图片补充文字说明的功能。常见与内容、资讯、新闻网站。

首先设置外层元素 `overflow:hidden` 暂时隐藏或隐藏一部分遮罩层，当鼠标移到图片上时候才以各种形式出现。

```css
.pic {
    position: relative;
    width: 256px;
    height: 256px;
    overflow: hidden;
}
.mask {
    position: absolute;
    width: 100%;
    height: 100%;
    opacity:0.5;
    transition: .5s;
}
```

添加各种效果。

```css
#mask1 {
    background-color:chocolate;
    left:0;top:256px;
}
.pic:hover #mask1 {
    top:0;
}

#mask2 {
    background-color:black;
    left:0;
    top:200px;
    color:white;
}
.pic:hover #mask2 {
    top:100px;
}
```

还可以配合 JavaScript做出更加复杂的动画效果。

仿照[百度新闻](http://news.baidu.com/#media)做一个鼠标从不同方向进入图片显示不同效果的功能。

首先将遮罩层隐藏。

```css
.pic{
    position:relative;
    width:256px;
    height:256px;
    overflow:hidden;
}
.mask{
    position:absolute;
    width:100%;
    height:100%;
    background-color:chocolate;
    opacity:0.5;
}
#mask1 {
    top:256px;
    left:256px;
}
```

判断鼠标进入图片的方向（算法参考[stackoverflow的一个回答](http://stackoverflow.com/questions/3627042/jquery-animation-for-a-hover-with-mouse-direction)）。

```javascript
function getDirection(element, event) {
    var w = element.offsetWidth,
        h = element.offsetHeight,
        x = (event.pageX - element.offsetLeft - (w/2)) * (w > h ? (h/w) : 1),
        y = (event.pageY - element.offsetTop - (h/2)) * (h > w ? (w/h) : 1),
        direction = Math.round((((Math.atan2(y, x) * (180/Math.PI)) + 180) / 90) + 3) % 4;
        
        return direction
}
```

这个函数会返回0、1、2、3分别代表上、右、下、左四个方向。

然后写动画的代码。利用 jQuery库。

[看完整代码](https://jsfiddle.net/acwong/nrwkfq91/2/)

网站实例：[百度新闻](http://news.baidu.com/)

## 图片变换效果

图片变换最常见于电商类网站。鼠标移动到图片上的时候通常会出现位移、大小、旋转等变换方式。

```css
img {
    transition: all 1s;
}
#img1:hover {
    transform: translateX(20px);
}
#img2:hover {
    transform: scale(1.2,1.2);
}
#img3:hover {
    transform: rotate(360deg);
}
```

还可以做更加复杂的 3D 变换。

```html
<div class="pic">
    <img src="http://acwongblog.qiniudn.com/2015-03_example-picture.jpg" id="img4">
    <div class="info">Hello</div>
</div>
```

```css
.pic {
    position:relative;
    width:256px;
    height:256px;
    transform-style: preserve-3d;
    transition: transform 1s;
}
.pic:hover {
    transform: translateZ(-128px) rotateX(90deg);
}
.pic img {
    transform: translateZ(128px);
    transition: all 1s;
}
.info {
    position:absolute;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background-color:black;
    transform: rotateX(-90deg) translateZ(128px);
    transition: all 1s;
    color: white;
}
```

[看完整代码](https://jsfiddle.net/acwong/nrwkfq91/3/)

网站实例：[京东](http://www.jd.com/?utm_source=jd.com)、[前端乱炖](http://www.html-js.com/article)

感谢您的阅读，有不足之处请为我指出。

**参考**

[jQuery animation for a hover with 'mouse direction' —— stackoverflow](http://stackoverflow.com/questions/3627042/jquery-animation-for-a-hover-with-mouse-direction)

