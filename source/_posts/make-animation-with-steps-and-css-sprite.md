---
title: 利用 CSS animation 和 CSS sprite 制作动画
date: 2015-03-23 21:40:32
tags: [CSS,CSS3,CSS3动画,雪碧图]
categories: 技术研究
description: 使用 CSS animation 和雪碧图制作动画
---

CSS3 大大强化了制作动画的能力，但是如果要做出图案比较复杂的动画，选择 GIF 依然是一个不错的选择。今天给大家介绍一个使用 CSS animation 配合雪碧图(CSS sprite)来制作动画的方法，可以做出类似于 GIF 动画的效果。

<!-- more -->

## CSS3 Animation steps函数

首先看看，CSS3 animation的[兼容性](http://caniuse.com/#feat=css-animation)。可以看到基本上主流浏览器都支持了 animation 属性，chrome、safari、opera和移动端的浏览器带上前缀就可以支持。

利用雪碧图来制作动画使用了 CSS3 Animation 里面的一个重要的函数 `steps`。

animation 本身是一个复合的属性，它包含了 *animation-name*，*animation-timing-function*，*animation-iteration-count*，*animation-direction*，*animation-play-state*，*animation-fill-mode* 六个属性。

``steps`` 就是属于 *animation-timing-function* 中的一个函数。

*animation-timing-function* 平时我们用的比较多的是默认的一些动画曲线值 `ease`、`ease-in` 等等。而 `steps` 则可以由我们控制动画被分成多少个部分进行。

`steps(n,[start|end])` 传入一到两个参数，第一个参数意思是把动画分成 n 等分，然后动画就会平均地运行。第二个参数 start 表示从动画的开头开始运行，相反，end 就表示从动画的结尾开始运行，默认值为 end。

因此，我们利用雪碧图和 `steps` 函数制作动画的原理就是，雪碧图包含了动画图片的每一帧，然后利用 `steps` 函数确定固定时间内动画运行的部分等于动画的帧数，从而实现动画效果。

## 动画实例

用猥琐的兔斯基做例子╮(￣▽￣")╭

![兔斯基gif](http://acwongblog.qiniudn.com/2015-03_tuski-gif.gif)

首先我们要切图，把动画的每一帧切成这样的图:

![兔斯基雪碧图](http://acwongblog.qiniudn.com/2015-03_tuski-sprite.png)

切图如果大家不想折腾，推荐[在线合并雪碧图的工具](http://alloyteam.github.io/gopng/)。

然后写 keyframes

```css
@-webkit-keyframes tuski {
    0% {
        background-position:0;
    }
    100% {
        background-position: -576px 0;
    }
}
@-moz-keyframes tuski {
    0% {
        background-position:0;
    }
    100% {
        background-position: -576px 0;
    }
}
@keyframes tuski {
    0% {
        background-position:0;
    }
    100% {
        background-position: -576px 0;
    }
}
```

调用动画

```css
#tuski {
    -webkit-animation: tuski .5s steps(12) infinite;
    -moz-animation: tuski .5s steps(12) infinite;
    animation: tuski .5s steps(12) infinite;
}
```

与 GIF 相比，这种动画可以让我们手动调整动画运行的速度。

点[这里](http://jsfiddle.net/acwong/7hoz365p/2/)看完整的代码。

大功告成。

感谢您的阅读，有不足之处请为我指出。
