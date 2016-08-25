---
title: 禁止用户选择的另一种思路（兼容 IE8）
date: 2016-08-23 16:15:11
tags: [CSS,伪类,伪元素,兼容性]
categories: 技术研究
---

## user-select

前端开发中常常会遇到一种需求，让某些元素的内容不能被选中，一般的做法会用 `user-select: none` 来做，由于 `user-select` 并不是标准的 CSS 属性，所以使用的时候要加上浏览器的前缀。

```css
.disabled-select {
  -ms-user-select: none;
  -moz-user-select: none;
  -webkit-user-select: none;
  user-select: none;
}
```

<!-- more -->

来看看 `user-select` 的在桌面端的兼容性：

![](http://acwongblog.qiniudn.com/2016-08_user-select-compatibility.png)

目前依然有大部分桌面端网页需要兼容 IE8 以上的浏览器，因此使用 `user-select` 并不是一个最完美的解决方案。

## onselectstart

禁止用户选择的另一种方法是在不想被选中的元素上面绑定 `onselectstart` 事件并且返回 `false`。这个在实际应用中并不好用，如果用户在该元素上开始选择的确可以禁止选中，但只要移出该元素外开始选择就可以无视 `onselectstart` 事件。

## 另一种思路：伪类、伪元素

先上一个[例子](https://jsfiddle.net/acwong/a1g7zaq8/)。

```html
<div class="disable-select">123</div>
```

```css
.disable-select:after {
  content: "456";
}
```

由于伪类并不是 DOM 里面的一部分，所以可以发现写在伪类 `content` 里面的值不能被选中。

但是一般来说页面渲染的内容不能直接写到 CSS 当中，所以这里需要一个强大的 CSS 方法 —— `attr`。

### attr

把上面的例子修改一下（[传送门](https://jsfiddle.net/acwong/a1g7zaq8/2/)）

```html
<div class="disable-select" data-content="456">123</div>
```

```css
.disable-select:after {
  content: attr(data-content);
}
```

CSS 的 `attr` 是一个强大的方法，可以直接获取元素属性的值直接用在 CSS 当中。CSS3 标准当中 `attr` 方法可以用于所有的 CSS 属性和元素当中，但是目前还没有任何一个浏览器实现了这个标准。

但应用于伪类、伪元素（IE8 只支持伪类） `content` 属性返回 `string` 类型的用法是被大部分浏览器支持。

![](http://acwongblog.qiniudn.com/2016-08_css-attr-compatibility.png)

### 不足

虽然使用伪类加上 `attr` 可以做到兼容性较好的禁止选择效果，但是这种方法在 IE8 里面依然有一些不同的表现，使用 `alt + a` 全选等快捷键按钮依然可以选择伪类里面的内容。

感谢您的阅读，有不足之处请为我指出。
