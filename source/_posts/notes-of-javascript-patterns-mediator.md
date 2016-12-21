---
title: JavaScript 设计模式笔记（十一） —— 中介者模式
date: 2016-12-21 15:59:13
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 中介者模式
---

## 定义

> 中介者模式(Mediator Pattern)定义：用一个中介对象来封装一系列的对象交互，中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互。中介者模式又称为调停者模式，它是一种对象行为型模式。

中介者模式在一些管理应用里面非常常见，通常要修改一个数据会导致页面中多个位置发生变动，非常适宜用中介者模式来解决。

<!-- more -->

## 例子

一个手机购买页面，可以选择手机颜色和内存以及输入购买数量，同时要展示选择的内存与颜色和购买数量，并根据库存切换下一步按钮的状态和文本内容。

### 页面元素

```html
<body>
  选择颜色：<select id="colorSelect">
    <option value="">请选择</option>
    <option value="red">红色</option>
    <option value="blue">蓝色</option>
  </select>

  选择内存：<select id="memorySelect">
    <option value="">请选择</option>
    <option value="32G">32G</option>
    <option value="16G">16G</option>
  </select>

  输入购买数量：<input type="text" id="numberInput" />

  您选择了颜色：<div id="colorInfo"></div><br>
  您选择了内存：<div id="memoryInfo"></div><br>
  您输入了数量：<div id="numberInfo"></div><br>

  <button id="nextBtn" disabled="true">请选择手机颜色和购买数量</button>
  <script src="test.js"></script>
</body>
```

### 库存

```javascript
var goods = {
  "red|32G": 3,
  "red|16G": 0,
  "blue|32G": 1,
  "blue|16G": 6
};
```

### 定义中介者

```javascript
var mediator = (function() {
  var colorSelect = document.getElementById('colorSelect');
  var memorySelect = document.getElementById('memorySelect');
  var numberInput = document.getElementById('numberInput');
  var colorInfo = document.getElementById('colorInfo');
  var memoryInfo = document.getElementById('memoryInfo');
  var numberInfo = document.getElementById('numberInfo');
  var nextBtn = document.getElementById('nextBtn');

  return {
    change: function(obj) {
      var color = colorSelect.value;
      var memory = memorySelect .value;
      var number = numberInput.value;
      var stock = goods[color + '|' + memory];
      
      // 判断各个操作
      if (obj === colorSelect) {
        colorInfo.innerHTML = color;
      } else if (obj === memorySelect) {
        memoryInfo.innerHTML = memory;
      } else if (obj === numberInput) {
        numberInfo.innerHTML = number;
      }

      if (!color) {
        nextBtn.disabled = true;
        nextBtn.innerHTML = '请选择手机颜色';
        return;
      }

      if (!memory) {
        nextBtn.disabled = true;
        nextBtn.innerHTML = '请选择内存大小';
        return;
      }
      
      // 判断是否正整数
      if (((number - 0) | 0) !== number - 0) {
        nextBtn.disabled = true;
        nextBtn.innerHTML = '请输入正确的购买数量';
        return;
      }

      if (number > stock) {
        nextBtn.disabled = true;
        nextBtn.innerHTML = '库存不足';
        return;
      }

      nextBtn.disabled = false;
      nextBtn.innerHTML = '放入购物车';

    }
  }
})();
```

### 绑定事件

```javascript
colorSelect.onchange = function() {
  mediator.change(this);
};
memorySelect.onchange = function() {
  mediator.change(this);
};
numberInput.oninput = function() {
  mediator.change(this);
};
```

可以看到，当事件触发的时候只要通知中介者，中介者就会根据发生事件的对象作出相应的页面变化。而且，这样写之后要添加一种操作，只要修改中介者模式再绑定事件即可。

## 总结

中介者模式的优点，简化对象之间的交互，将对象之间多对多的关系转变成中介者与各个对象之间一多对一的关系。

而中介者模式的缺点就是中介者对象一般会变得非常复杂，令到代码更加难以维护。

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)