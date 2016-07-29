---
title: JavaScript 笔记 —— 标准事件对象与 IE 事件对象
date: 2014-12-30 21:26:22
tags: [JavaScript,事件,事件对象,兼容性]
categories: 学习笔记
description: 总结 IE 事件对象和标准事件对象的区别。
---

标准的事件绑定函数是 `addEventListener` 函数，而 IE 浏览器（IE9 以下）则是用 `attachEvent`。 这两个函数中的事件处理函数都可以传入一个 `event` 参数，就是我们所说的事件对象，本文就来总结一下两者的区别。

<!-- more -->

## 获取事件的目标

事件的目标就是指当前触发事件的元素。

有如下的 HTML：

```html
<body id="myBody">
    <button id="myButton">click</button>
</body>
```

标准事件对象使用 `event` 的 `target` 属性获取事件目标。

```javascript
var btn = document.getElementById('myButton');
btn.addEventListener("click", function(event) {
    alert(event.target.id);    // myButton
});
```

IE 事件对象使用 `event` 的 `srcElement` 属性获取事件目标。

```javascript
var btn = document.getElementById("myButton");
btn.attachEvent("onclick", function(event) {
    alert(event.srcElement.id);    // myButton
});
```

**另外**，标准事件对象还有一个 `currentTarget` 属性，该属性在事件处理函数当中始终与 `this` 相等，而 `target` 属性则是指向事件触发的具体目标。

```javascript
document.body.addEventListener("click", function (event) {
    alert(event.currentTarget.id);    // myBody
    alert(event.target.id);           // myButton
    alert(this.id);                   // myBody
});
```

## 取消事件默认行为

有如下的 HTML：

```html
<body>
    <a id="myLink" href="http://blog.acwong.org">acwong blog</a>
</body>
```

标准事件对象使用 `event` 的 `preventDefault()` 方法取消事件默认行为。

```javascript
var myLink = document.getElementById('myLink');
myLink.addEventListener("click",function(event) {
    alert("haha");          // haha
    event.preventDefault(); // 浏览器不会跳转
});
```

IE 事件对象使用 `event` 的 `returnValue` 属性取消事件默认行为，该属性默认值为 `true` 设置为 `false` 就可以取消事件默认行为。

```javascript
var myLink = document.getElementById('myLink');
myLink.attaxchEvent("onclick",function(event) {
    alert("haha");                  // haha
    event.returnValue = false;      // 浏览器不会跳转
});
```

## 禁止事件冒泡

有如下的 HTML:

```html
<body id="myBody">
    <button id="myButton">click</button>
</body>
```

标准事件对象使用 `event` 的 `stopPropagation()` 方法禁止事件冒泡。

```javascript
var btn = document.getElementById("myButton");
btn.addEventListener("click", function(event) {
    alert(this.id);            // myButton
    event.stopPropagation();   // 禁止事件冒泡
});
document.body.addEventListener("click",function(event) {
    alert(this.id);           // 不会出现
});
```

IE 事件对象使用 `event` 的 `cancelBubble` 属性禁止事件冒泡，该属性值默认为 `false`，设置为 `true` 就可以禁止事件冒泡。

```javascript
var btn = document.getElementById("myButton");
btn.attachEvent("onclick", function(event) {
    alert("haha");              // haha
    event.cancelBubble = true;  // 禁止事件冒泡
});
document.body.attachEvent("onclick",function(event) {
    alert("hehe");             // 不会出现
});
```

## IE 事件处理函数中的 `this`

最后，还要一个与事件对象无关的小点，在 IE 事件处理函数当中 `this` 的值并不等于被绑定元素，而是等于 `window` 对象。

```javascript
var btn = document.getElementById("myButton");
btn.attachEvent("onclick", function(event) {
    alert(this === window);              // true
    alert(this.id)                       // undefined
});
```

而在标准事件绑定当中，`this` 的值等于被绑定的元素。

```javascript
var btn = document.getElementById("myButton");
btn.addEventListener("click", function(event) {
    alert(this === btn);                  // true
    alert(this.id);                       // myButton
    alert(this === event.currentTarget);  // true
});
```

最后祝大家新年快乐~

感谢您的阅读，有不足之处请为我指出。

**参考**

[JavaScript高级程序设计(第3版)](http://book.douban.com/subject/10546125/)

