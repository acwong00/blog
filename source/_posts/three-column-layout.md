---
title: 三栏布局 —— 圣杯布局、双飞翼布局和 flex
date: 2019-03-10 15:47:38
tags: [CSS,布局,flex]
categories: 学习笔记
---

三栏式布局是日常开发当中常见的布局方式，常见的布局要求是：左右两边是固定宽度，中间自适应，同时要让中间的内容优先渲染。接下来就来看看最常见的三种三栏式布局的实现方式。

## 圣杯布局

首先是 html 的结构：

```html
<div class="content">
    <div class="main">main</div>
    <div class="left">left</div>
    <div class="right">right</div>
</div>
```

设置元素的基本样式，三栏的元素都向左浮动，容器 `content` 设置左右的 `padding` 为左右两栏的元素预留出空位。

```css
.content {
  overflow: hidden;
  padding-left: 100px;
  padding-right: 100px;
}
.content > div {
  float: left;
}
.main {
  width: 100%;
  background-color: red;
}
.left {
  width: 100px;
  background-color: yellow;
}
.right {
  width: 100px;
  background-color: green;
}
```

设置完毕之后可以看到，左右两栏目前处于中间栏的下方，接下来就要让左右两栏浮动到合适的位置，这个时候虽然使用到 `margin` 负值的技术。

```css
/* 忽略其余代码 */
.left {
  width: 100px;
  background-color: yellow;
  margin-left: -100%; /* 设置 margin 负值 */
}
.right {
  width: 100px;
  background-color: yellow;
  margin-left: -100px; /* 设置 margin 负值 */
}
```

`margin: -100%;` 让左边栏移动了整个 `content` 容器的长度减去左右两端 `padding` 的长度。而 `margin: -100px;` 则让右边栏刚好能浮动到与中间栏同一行上面。

这个时候看到左右两栏已经浮动到中间栏上方，并覆盖了中间栏的左右两端。接下来只要把左右两栏位移到 `padding` 预留的位置就大功告成了。

```css
.content > div {
  position: relative; /* 将元素设为相对定位 */
  float: left;
}
.left {
  width: 100px;
  background-color: yellow;
  margin-left: -100%;
  left: -100px; /* 位移到正确位置 */
}
.right {
  width: 100px;
  background-color: green;
  margin-left: -100px;
  right: -100px; /* 位移到正确位置 */
}
```

[最终代码](https://codepen.io/acwong/pen/rRwRWy)

## 双飞翼布局

双飞翼布局与圣杯布局有类似的思路，不同的是它不需要用相对定位，方法是在中间栏外面添加一个容器，使用 `margin`去解决。

```html
<div class="content">
  <div class="main">
    <div class="main-inner">main</div>
  </div>
  <div class="left">left</div>
  <div class="right">right</div>
</div>
```

```css
.content {
  overflow: hidden;
}
.content > div {
  float: left;
}
.main {
  width: 100%;
  background-color: red;
}
.main-inner {
  margin-left: 100px;
  margin-right: 100px;
}
.left {
  width: 100px;
  background-color: yellow;
  margin-left: -100%;
}
.right {
  width: 100px;
  background-color: green;
  margin-left: -100px;
}
```

[最终代码](https://codepen.io/acwong/pen/ywXwZX)

## flex 布局

对于不需要考虑兼容性的情况，可以使用 flex 布局，这种布局比较简单，设置中间栏占满，左右两栏固定宽度，然后使用 `order` 属性调换一下排序就可以了。

```html
<div class="content">
  <div class="main">main</div>
  <div class="left">left</div>
  <div class="right">right</div>
</div>
```

```css
.content {
  display: flex;
}
.main {
  flex: 1;
  background-color: red;
}
.left {
  order: -1;
  width: 100px;
  background-color: yellow;
}
.right {
  width: 100px;
  background-color: green;
}
```

[最终代码](https://codepen.io/acwong/pen/ywXwro)
