---
title: "从一个居中方法说起 —— 谈 translate 与 相对、绝对定位"
date: 2014-12-21 15:59:47
tags: [CSS,CSS3,定位,CSS3动画]
categories: 技术研究
description: 通过一个居中的例子引入，谈谈 translate 和 相对、绝对定位的区别。
---

## 方法介绍

垂直水平居中是日常前端开发当中一个常见的需求，在支持 CSS3 属性的现代浏览器当中，有一个利用 CSS3 属性的垂直水平居中方法：

```css
    .center {
        position: absolute;
        top: 50%;
        left: 50%;
        -ms-transform: translate(-50%,-50%);
        -moz-transform: translate(-50%,-50%);
        -o-transform: translate(-50%,-50%);
        transform: translate(-50%,-50%); 
    }
```

**[例子传送门](http://jsfiddle.net/acwong/kjcvss1a/)**（请用现代浏览器打开）

从上面的例子看到，无论我们怎样调整窗口的大小，红色方块始终会在窗口垂直、水平居中。

<!-- more -->

## 原理

为了解释原理，我们创建两个元素:

```html
    <div id="outer">
        <div id="inner">
        </div>
    </div>
```

先不加上 `transform` 属性：

```css
    #outer {
        position: relative;
        width: 500px;
        height: 500px;
        border: 2px solid yellow;
    }
    
    #inner {
        position: absolute;
        top: 50%;
        left: 50%;
        width: 100px;
        height: 100px;
        background-color: red;
    }
```

[未加上 `transform` 属性的例子](http://jsfiddle.net/acwong/kjcvss1a/1)。

[![](http://acwongblog.qiniudn.com/2014-12_middle-position.PNG)](http://acwongblog.qiniudn.com/2014-12_middle-position.PNG)

可以看到红色方块左、上方距离外层方块的距离都是250个像素，如果我们想实现垂直水平居中，就应该将红色方块的中心点移动到目前元素左上角的位置，也就是分别向上和向左移动一半方块边长的长度，50个像素。

```css
     #inner {
        position: absolute;
        top: 50%;
        left: 50%;
        width: 100px;
        height: 100px;
        background-color: red;
        -ms-transform: translate(-50%,-50%);
        -moz-transform: translate(-50%,-50%);
        -o-transform: translate(-50%,-50%);
        transform: translate(-50%,-50%);
    }
```

[加上 `transform` 属性](http://jsfiddle.net/acwong/kjcvss1a/2/)。

所以我们可以看到在 `translate` 函数当中使用百分比是以该元素的内容区、补白(`padding`)、边框(`border`)为标准计算的，为了说明这一点，我们在 *innner* 元素加上一些 `padding` 和 `border`:

```css
    #inner {
        position: absolute;
        top: 50%;
        left: 50%;
        width: 100px;
        height: 100px;
        border: 25px solid yellow;
        padding: 25px;
        background-color: red;
        -ms-transform: translate(-50%,-50%);
        -moz-transform: translate(-50%,-50%);
        -o-transform: translate(-50%,-50%);
        transform: translate(-50%,-50%);
   }
```

[加上 `padding` 和 `border` 以后](http://jsfiddle.net/acwong/kjcvss1a/3/)。

可以看到 *inner* 元素一样做到了垂直、水平居中。

## translate 与绝对定位、相对定位

在表现上看，使用 CSS3 `translate` 函数和绝对定位、相对定位属性加上 `top`、`left` 数值都可以使元素产生位移。实际上它们还是有不少的区别。

### 元素视图属性中的 `offsetLeft` 和 `offsetTop` 属性。

我们分别用相对定位和 `translate` 的方法来使元素产生位移：

```css
    #box1 {
        position: relative;
        width: 50px;
        height: 50px;
        background-color: blue;
        top: 100px;
        left: 300px;
   }
```

```css
   #box2 {
       width: 50px;
       height: 50px;
       background-color: red;
       -ms-transform: translate(300px,100px);
       -moz-transform: translate(300px,100px);
       -o-transform: translate(300px,100px);
       transform: translate(300px,100px);
   }
```

然后看看两者的 `offsetTop` 和 `offsetLeft` 的数值：

```javascript
    var box1 = document.getElementById("box1");
    
    alert(box1.offsetLeft);
    alert(box1.offsetTop);
```

```javascript
    var box2 = document.getElementById("box1");
    
    alert(box2.offsetLeft);
    alert(box2.offsetTop);
```

[使用相对定位的例子](http://jsfiddle.net/acwong/kjcvss1a/5/)

[使用 translate 的例子](http://jsfiddle.net/acwong/kjcvss1a/6/)

可以看出使用 `translate` 的例子的 `offsetTop` 和 `offsetLeft` 的数值与没有产生位移的元素没有然后区别，无论位移多少这两个数值都是固定不变的。

而使用相对定位的例子 `offsetTop` 和 `offsetLeft` 的数值则根据位移的长度发生了改变。

### 动画表现的区别

在 CSS3 属性还没很好地被浏览器支持的时候，我们常常会使用绝对定位(`position:absolute`)，然后结合 *jQuery* 改变元素的 `top`、`left` 的数值来做位移的动画效果。

然而，两者在位移动画的表现上也有一定的区别。借用国外博主 Paul Irish 的两个例子：

[Animating with Top/Left](http://codepen.io/paulirish/pen/nkwKs)

[Animating with Translate](http://codepen.io/paulirish/pen/LsxyF)

对比两个例子来看，可以看出使用 `translate` 来制作的动画比绝对定位的动画更加平滑。

原因在于使用绝对定位的动画效果会受制于利用像素(*px*)为单位进行位移，而使用 `translate` 函数的动画则可以不受像素的影响，以更小的单位进行位移。

另外，绝对定位的动画效果完全使用 CPU 进行计算，而使用 `translate` 函数的动画则是利用 GPU，因此在视觉上使用  `translate` 函数的动画可以有比绝对定位动画有更高的帧数。

## 最后

CSS3 动画相关的属性出现以后，可以让我们更加轻松地制作复杂的动画，同时 `position:relative` 和 `position:absolute` 这一类的属性可以回归它们原本的定位，为定位、布局服务，而将动画的重任交给 CSS3 的相关属性。

感谢您的阅读，有不足之处请在评论为我指出。

**参考**

[Why Moving Elements With Translate() Is Better Than Pos:abs Top/left](http://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/)




