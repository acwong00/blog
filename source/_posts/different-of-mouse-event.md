---
title: JavaScript 笔记 —— 鼠标事件的浏览器差异
date: 2015-01-19 14:17:40
tags: [JavaScript,事件,兼容性]
categories: 学习笔记
description: 总结鼠标事件在各个浏览器之间的差异。
---

鼠标是我们在 PC 端浏览网页时候最重要的交互工具，因此鼠标事件也是 Web 开发当中最常用的一类事件。然而，由于各种原因，不同厂商或者不同版本的浏览器之间对于鼠标事件的实现也有所不同。本文总结一下，鼠标事件在不同浏览器实现的差异。

<!-- more -->

## mouseover 和 mouseout 相关元素差异

*mouseover* 和 *mouseout* 是 DOM3 级事件当中的其中两个事件。

*mouseover* 是当鼠标指针在该目标元素外部，然后用户将鼠标首次移入目标元素的边界时触发的事件。

*mouseout* 是当鼠标指针在当前元素上方，然后用户将鼠标移入另一个元素时触发的事件。另一个元素可以位于当前元素的外部，也可以是当前元素的子元素。

可以看出上述两个事件都是在描述从一个元素移动到另一个元素的情况，因此参与事件有两个元素，这个时候我们就需要了解除了目标元素之外还有哪一个元素参加了事件。

**标准事件对象** `event` 包含了名为 `relatedTarget` 的属性，提供相关元素的信息，只有在 *mouseover* 和 *mouseout* 当中该属性才包含元素的信息，在其他事件当中它的值为 `null`。

有如下 HTMl：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>demo</title>
    <style>
        #myDiv {
        	width: 200px;
        	height: 200px;
        	background-color: red;
        }
    </style>
</head>
<body>
	<div id="myDiv">
	</div>
	<script src="demo.js"></script>
</body>
</html>
```

为 *myDiv* 分别绑定 *mouseover* 和 *mouseout* 事件。

```javascript
var div = document.getElmentById("myDiv");
div.addEventListener("mouseover", function(event) {
	alert("Mouse comes from " + event.relatedTarget.tagName);
    // 触发事件，弹出 "Mouse comes from BODY"
}, false);
```

```javascript
var div = document.getElementById("myDiv");
div.addEventListener("mouseout", function(event) {
	alert("Mouse moves to " + event.relatedTarget.tagName);
    // 触发事件，弹出 "Mouse moves to BODY"
}, false);
```

**IE8 或之前的版本**不支持 `relatedTarget` 属性，我们需要使用另一个属性访问相关元素。当 *mouseover* 事件触发时，IE 事件对象当中 `fromElement` 保存相关元素；当 *mouseout* 事件触发时，IE 事件对象当中 `toElement` 保存相关元素。

延续上面的例子，为 *myDiv* 分别绑定 *mouseover* 和 *mouseout* 事件。

```javascript
var div = document.getElementById("myDiv");
div.attachEvent("onmouseover", function(event) {
	alert("Mouse comes from " + event.fromElement.tagName);
    // IE 浏览器中触发事件，弹出 "Mouse comes from BODY"
});
```

```javascript
var div = document.getElementById("myDiv");
div.attachEvent("onmouseout", function(event) {
	alert("Mouse moves to " + event.toElement.tagName);
    // IE 浏览器中触发事件，弹出 "Mouse moves to BODY"
});
```

## 鼠标按键信息差异

现在的鼠标通常包含3个按键，左键、右键和中间的键，在开发过程当中我们可能会需要知道用户按下的是鼠标的哪一个键。

**标准事件对象**使用 `button` 属性来识别鼠标按键。0 表示主鼠标按钮（一般为左键），1 表示中间的按钮，2 表示次鼠标按钮（一般为右键）。

延续上面的例子，为 *myDiv* 绑定 *mousedown* 事件。

```javascript
var div = document.getElementById("myDiv");
div.addEventListener("mousedown", function (event) {
	alert(event.button);    // 根据按键不同分别出现值 0，1，2
}, false);
```

**IE8 或之前的版本**中的事件对象同样提供了 `button` 属性，但是该属性的值与标准事件对象有所不同。

- 0 表示没有按下按钮。
- 1 表示按下主鼠标按钮（一般为左键）。
- 2 表示按下次鼠标按钮（一般为右键）。
- 3 表示同时按下主、次鼠标按钮。
- 4 表示按下中间按钮。
- 5 表示同时按下主鼠标按钮和中间按钮。
- 6 表示同时按下次鼠标按钮和中间按钮。
- 7 表示同时按下了三个按钮

IE事件对象中 `button` 同时考虑到了两个或多个按钮同时按下的情形，虽然这样的操作并不常见。

## 鼠标滚轮事件差异

*mousewheel* 事件是用户使用鼠标滚轮滚动的时候触发的事件，该事件的兼容性比较好，IE6.0 就已经实现。

在鼠标滚轮的事件当中，我们通常会希望知道用户是向前还是向后滚动滚轮，*mousewheel* 事件对象当中包含一个 `wheelDelta` 属性，当用户向前滚动滚轮时，`wheelDelta` 的值为 120 的倍数；当用户向后滚动滚轮时，`wheelDelta` 的值为 -120 的倍数。

```javascript
var div = document.getElementById("myDiv");
div.addEventListener("mousewheel", function (event) {
	alert(event.wheelDelta);   // 120 或 -120
}, false);
```

有一个需要注意的点，在 Opera 9.5 之前的版本，`wheelDelta` 的值与标准的值**符号相反**。

在 FireFox 浏览器当中，除了 `mousewheel` 事件以外还有一个表示鼠标滚动的事件 `DOMMouseScroll`。该事件当中 `detail` 的值与 `mousewheel` 事件对象当中的 `wheelDelta` 作用相同。

不同的是鼠标向前滚动时 `detail` 值为 -3，向后滚动时 `detail` 值为 3。

```javascript
// FireFox 浏览器当中
var div = document.getElementById("myDiv");
div.addEventListener("DOMMouseScroll", function (event) {
	alert(event.detail); // -3 或 3
}, false);
```

感谢您的阅读，有不足之处请为我指出。

**参考**

[JavaScript高级程序设计(第3版)](http://book.douban.com/subject/10546125/)
