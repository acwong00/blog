---
title: 头像拼接需求的Grid布局实现
date: 2022-06-19 16:18:08
tags: [CSS,布局,grid]
categories: 技术实践
---

## 背景

最近看项目的代码，有一个群聊头像拼接的需求，会获取到群聊成员的四个或者三个头像进行拼接（如下图，四头像拼接和三头像拼接），目前是使用 `position: absolut` 为各个头像进行绝对定位，感觉这样的解决方案不够优雅，由于项目是基于 electron 因此不用考虑兼容性问题，所以可以使用 Grid 布局的解决方案。

![20220427143721](https://user-images.githubusercontent.com/6183922/165456572-c3468379-e057-49cc-a8ac-f356c49dae62.png)

![20220427143721](https://user-images.githubusercontent.com/6183922/165456551-90ab4517-2aa8-4acd-8a6f-68b7a69dcdbf.png)

## 四人头像

与 flex 布局为一维布局不同，grid 为二维的布局属性，所以非常适合完成头像拼接这种二维布局的样式，首先是初始的 HTML 结构。

```html
<div class="container">
  <div class="item" style="background-color: red;">1</div>
  <div class="item" style="background-color: yellow;">2</div>
  <div class="item" style="background-color: blue;">3</div>
  <div class="item" style="background-color: green;">4</div>
</div>
```

容器设置为 grid 布局，设置行和列。

```css
.container {
  display: grid;
  width: 180px;
  height: 180px;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: 1fr 1fr;
  border-radius: 50%;
  overflow: hidden;
}
```

`grid-template-rows` 和 `grid-template-columns` 分别设置布局当中的行和列，可以看到现在是一个 2x2 的两行两列结构，设置容器固定宽高为 180x180，用 `fr` 单位就相当于 flex 布局当中元素占满剩余的区域，当前将每一列和行的宽度都设置为 `1fr` 就相当于元素平分了宽度和高度。

可以看到原本绝对定位布局需要针对下方每一个元素设置定位数值，而使用 grid 布局就只需要写数行代码。

## 三人头像

```html
<div class="container">
  <div class="item" style="background-color: red;">1</div>
  <div class="item" style="background-color: yellow;">2</div>
  <div class="item" style="background-color: blue;">3</div>
</div>
```

```css
.container {
  display: grid;
  width: 180px;
  height: 180px;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: 1fr 1fr;
  grid-auto-flow: column;
  border-radius: 50%;
  overflow: hidden;
}
```

由于三号头像需要在拼接的右侧，因此需要改变 `grid-auto-flow` 属性，这个属性的默认值为 `row` 意思是顺序的放置为先行后列，而改为 `column` 之后就改变为先列后行。

然后针对三号头像进行 `grid-row` 属性设置。

```css
.container .item:last-child {
  grid-row: 1 / 3;
}
```

要解释 `grid-row` 这个属性，首先要理解网格线这个概念，例如现在头像是一个「田」字型的布局，可以看作是横竖各三条网格线将一个平面分割成四分。而 `grid-row: 1 / 3` 这种写法也可以拆分为：

```css
.container .item:last-child {
  grid-row-start: 1;
  grid-row-end: 3;
}
```

意思就是该元素上边边框处于第一条网格线，下边边框处于第三条网格线，因此就可以完成需求的布局。

## 后续

后续如果遇到产品改需求，需要改变头像显示的顺序也非常简单，除了 `grid-auto-flow` 可以按照行列改变头像显示的顺序以外，还可以手动指定头像的位置，比如说要把1号头像放到右下角的位置。

```css
.container {
  display: grid;
  width: 180px;
  height: 180px;
  grid-template-columns: 1fr 1fr;
  grid-template-rows: 1fr 1fr;
  border-radius: 50%;
  overflow: hidden;
  grid-template-areas: 'a b'
                       'c d';
}

.container .item:first-child {
  grid-area: d;
}
```

为 container 添加 `grid-template-areas` 手动定义每一个区块的名称，然后在对应的子元素添加 `grid-area` 属性，指定它所在的区块。

总的来说 grid 布局方法为二维布局提供了许多相当简便又容易理解的布局方法，比 flex 布局又强大了许多。
