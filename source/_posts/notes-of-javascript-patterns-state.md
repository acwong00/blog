---
title: JavaScript 设计模式笔记（十三） —— 状态模式
date: 2016-12-24 17:13:14
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 状态模式
---

## 定义

状态模式定义为：

> 允许一个对象在其内部状态改变的时候改变它的行为，对象看起来似乎修改了它的类。

这个定义的前半句是指将状态封装成独立的类，并将请求委托给当前的状态对象，使内部状态改变的时候可以有不同的行为。

后半句指在客户的角度来看，使用的对象，在不同状态下有不同的行为，就像是从不同的类实例化而来的。

<!-- more -->

对于不同状态有不同的行为，生活中最常见的就是灯光开关，同一个按钮，在不同的状态下可以进行开灯和关灯操作。现在看一个灯光按钮的例子。

## 传统面向对象写法

### 封装状态对象

将各种状态封装成独立的类，并实现操作行为的函数。

```javascript
var OffLightState = function(light) {
  this.light = light;
};

OffLightState.prototype.buttonWasPressed = function() {
  console.log('弱光');
  this.light.setState(this.light.weakLightState);
};

var WeakLightState = function(light) {
  this.light = light;
};

WeakLightState.prototype.buttonWasPressed = function() {
  console.log('强光');
  this.light.setState(this.light.strongLightState);
};

var StrongLightState = function(light) {
  this.light = light;
};

StrongLightState.prototype.buttonWasPressed = function() {
  console.log('关灯');
  this.light.setState(this.light.offLightState);
};
```

### setState 方法

```javascript
Light.prototype.setState = function(newState) {
  this.currState = newState;
};
```

### Light 类

```javascript
// 为每一种状态创建一个状态对象
var Light = function() {
  this.offLightState = new OffLightState(this);
  this.weakLightState = new WeakLightState(this);
  this.strongLightState = new StrongLightState(this);
  this.button = null;
};

Light.prototype.init = function() {
  var button = document.createElement('button');
  var self = this;
  this.button = document.body.appendChild(button);
  this.button.innerHTML = '开关';

  this.currState = this.offLightState;
  this.button.onclick = function() {
    self.currState.buttonWasPressed();
  };
};

// 执行
var light = new Light();
light.init();
```

## 非传统面向对象写法

JavaScript 并非严格的面向对象语言，所以对象并非一定要从类中创建而来。以下改写上述例子。

### 使用 call 方法委托

```javascript
var Light = function() {
  this.currState = FSM.off; // 当前状态
  this.button = null;
};

Light.prototype.init = function() {
  var button = document.createElement('button');
  var self = this;
  
  button.innerHTML = '开关';
  this.button = document.body.appendChild(button);
  
  this.button.onclick = function() {
    self.currState.buttonWasPressed.call(self); // 把请求委托给 FSM 状态机
  }
};

var FSM = {
  off: {
    buttonWasPressed: function() {
      console.log('弱光');
      this.currState = FSM.weak;
    }
  },
  weak: {
    buttonWasPressed: function() {
      console.log('强光');
      this.currState = FSM.strong;
    }
  },
  strong: {
    buttonWasPressed: function() {
      console.log('关灯');
      this.currState = FSM.off;
    }
  }
};

// 执行
var light = new Light();
light.init();
```

## 总结

状态模式的优点：将状态行为封装到一个类里面，可以方便地添加新状态；允许状态转换逻辑与状态对象合成一体，而不是某一个巨大的条件语句块；将转换状态规则封装到类当中。

状态模式的缺点：增加了对象数量；对“开闭原则”支持不佳，添加状态的时候同时要修改其他状态里面的转换规则。

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)