---
title: "实用的margin负值"
date: 2014-12-06 11:33:58
tags: [CSS,布局,盒模型]
categories: 技术研究
description: 介绍 margin 负值以及 margin 负值在实际当中的应用。
---

无论是在介绍前端知识的书籍还是谈论盒模型的文章，margin 都是最重要的属性之一，然而它的负值用法却极少被提到。其实 margin 负值是一个相当实用的属性，可以被应用于日常前端开发当中的不少场景。

<!-- more -->

## margin 负值初体验

与正值的 margin 一样，margin 的负值同样可以被用于上下左右四个方向，我把它所起到的效果总结为：

**上和左方的 margin 负值使该元素向上和左方向移动。**

**下和右方的 margin 负值使该元素下方、右方的元素被拉向该元素。**

我们通过几个简单的小例子去理解。**[传送门......](http://jsfiddle.net/acwong/j8x2r6a7/)**

在例子当中一个大的正方形包裹着两个分别是蓝色和黄色的正方形，分别对蓝色的正方形使用上、下、左、右四个方向的 margin 负值。

结果我们可以看到，使用`margin-top: -50px` 和 `margin-left: -50px` 的例子，蓝色正方形分别向上方和左方移动了50个像素。

[![negative margin-top](http://acwongblog.qiniudn.com/2014-12_negative-margin-top.PNG)](http://acwongblog.qiniudn.com/2014-12_negative-margin-top.PNG)

[![negative margin-left](http://acwongblog.qiniudn.com/2014-12_negative-margin-left.PNG)](http://acwongblog.qiniudn.com/2014-12_negative-margin-left.PNG)

而使用 `margin-bottom: -50px` 和 `margin-right: -50px` 的例子，位于下方和右方的黄色正方形向蓝色正方形方向移动了50个像素，覆盖了蓝色正方形的一部分。


[![negative margin-bottom](http://acwongblog.qiniudn.com/2014-12_negative-margin-bottom.PNG)](http://acwongblog.qiniudn.com/2014-12_negative-margin-bottom.PNG)

[![negative margin-right](http://acwongblog.qiniudn.com/2014-12_negative-margin-right.PNG)](http://acwongblog.qiniudn.com/2014-12_negative-margin-right.PNG)

## 原理浅析

产生上述两种情况的差异是由于 margin 在上、左方和下、右方解析逻辑有所不同。这里引用怿飞博客**[《由浅入深漫谈margin属性》](http://www.planabc.net/2007/03/18/css_attribute_margin/)** 中参考线的概念。

[![margin-move](http://acwongblog.qiniudn.com/2014-12_margin-move.png)](http://acwongblog.qiniudn.com/2014-12_margin-move.png)

简单来说就是上、左方和下、右方参考线的不同导致的。

**margin 上方负值以包含块(Containing block) 内容区域的上边或者上方相连元素 margin 的下边为参考线**

**margin 左方负值以包含块(Containing block) 内容区域的左边或者左方相连元素 margin 的右边为参考线**

**margin 下方负值以元素本身 border 的下边为参考线**

**margin 右方负值以元素本身 border 的右边为参考线**

所以使用 margin 上、左方负值时可以理解为与参考线的距离减少，导致元素产生位移；使用使用 margin 下、右方负值时可以理解为参考线向上、右方移动。

深入理解可以看**[《由浅入深漫谈margin属性》](http://www.planabc.net/2007/03/18/css_attribute_margin/)**。另外，关于**[包含块( Containing block )](http://w3help.org/zh-cn/kb/008/)**。

## margin 负值在实际当中的应用

margin 负值虽然不是常常被提起，但是在实际当中已经有相当广泛的应用。现在来看几个实例。

### 大众点评团购城市列表

[http://t.dianping.com/citylist](http://t.dianping.com/citylist)

[![dianping-list](http://acwongblog.qiniudn.com/2014-12_dianpin-list.PNG)](http://acwongblog.qiniudn.com/2014-12_dianpin-list.PNG)

上图每一个城市之间都有一条浅灰色竖线作为分割符，查看源码我们可以发现它其实是每个`li`元素的左边界，然而通常使用`border`来完成类似需求时我们不希望第一个（或最后一个）`li` 元素出现`border`，因此我们通常会在第一个（或最后一个）`li` 元素添加 *frist-item*(或 *last-item*) 的 class 使他们不显示，而这里的城市列表用了一个更加简单的方法：每一个`li` 元素添加一个像素左方向的 `margin` 负值。

```css
.list li .cityes li {
    border-left: 1px solid #ccc;
    margin: 17px 0 0 -1px;
    /* 省略其余代码 */
}
```

第一个城市的左方 `border` 就这样被隐藏了。


### segmentfault 首页tab

[http://segmentfault.com/](http://segmentfault.com/)

[![segmentfault-tab](http://acwongblog.qiniudn.com/2014-12_segmentfault-tab.PNG)](http://acwongblog.qiniudn.com/2014-12_segmentfault-tab.PNG)

完成类似的tab效果，我们需要分别给各个 tab 元素和其父元素添加 `border`，这个时候会出现双边框的情况。segmentfault 的解决方法是给每一个tab元素添加一像素下方的 `margin` 负值。

另外，为了类似上一个例子中的城市列表，这里的元素添加了一个像素的右方的 `margin` 负值，tab 元素之间不会出现双边框的情况。

```css
.nav-tabs {
    border-bottom: 1px solid #ddd;
    /* 父元素ul */
}
.nav-tabs > li {
    margin-bottom: -1px;
    /* 省略其余代码 */
}
.nav-tabs-zen > li > a {
    margin-right： 1px;
    border: 1px solid #ddd;
    /* 省略其余代码 */
}
```

### Bootstrap 网格系统

在 Bootstrap 的网格系统当中，每一个使用 `col-**-*` 类的列元素都应该包裹在 `row` 类的元素当中。为了使页面美观每个 `col-**-*` 的类都设置了左、右15个像素的补白 `padding`，这样会导致一个结果，第一个和最后一个元素会离开容器15个像素的距离。为此，Bootstrap在 `row` 类当中分别定义了左、右方向15个像素的 `margin` 负值来抵消第一列和最后一列产生的左右补白。

[![bootstrap-grid-system](http://acwongblog.qiniudn.com/2014-12_bootstrap-grid-system.jpg)](http://acwongblog.qiniudn.com/2014-12_bootstrap-grid-system.jpg)

```css
.col-xs-1, .col-sm-1, .col-md-1, .col-lg-1, 
.col-xs-2, .col-sm-2, .col-md-2, .col-lg-2, 
.col-xs-3, .col-sm-3, .col-md-3, .col-lg-3, 
.col-xs-4, .col-sm-4, .col-md-4, .col-lg-4, 
.col-xs-5, .col-sm-5, .col-md-5, .col-lg-5, 
.col-xs-6, .col-sm-6, .col-md-6, .col-lg-6, 
.col-xs-7, .col-sm-7, .col-md-7, .col-lg-7, 
.col-xs-8, .col-sm-8, .col-md-8, .col-lg-8, 
.col-xs-9, .col-sm-9, .col-md-9, .col-lg-9, 
.col-xs-10, .col-sm-10, .col-md-10, .col-lg-10, 
.col-xs-11, .col-sm-11, .col-md-11, .col-lg-11, 
.col-xs-12, .col-sm-12, .col-md-12, .col-lg-12 {
  position: relative;
  min-height: 1px;
  padding-right: 15px;
  padding-left: 15px;
}

.row {
  margin-right: -15px;
  margin-left: -15px;
}
```

### 左右并排布局

在做左右并排布局时候，除了可以使用 `float` 或者 `inline-block` 之外，还可以尝试使用 margin 负值。

[直接上例子](http://jsfiddle.net/acwong/r0ujysb9/)

## 最后

利用 margin 负值可以简单直接的解决某些我们日常开发当中遇到的问题，margin 负值还有很多其余的使用实例，这里不一一叙述，只要平时多看看别人写的代码，就会发现 margin 负值的应用其实无处不在。

感谢您的阅读，有不足之处请在评论为我指出。

**参考**

1. [由浅入深漫谈margin属性](http://www.planabc.net/2007/03/18/css_attribute_margin/)
2. [我知道你不知道的负Margin](http://www.hicss.net/i-know-you-do-not-know-the-negative-margin/)
3. [Bootstrap框架的网格系统工作原理](http://www.imooc.com/code/2325)





