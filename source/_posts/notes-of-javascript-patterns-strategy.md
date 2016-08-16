---
title: JavaScript 设计模式笔记（二）—— 策略模式
date: 2016-08-02 10:01:50
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 策略模式
---

## 定义

策略模式（Strategy）的定义为：

> 定义一系列的算法，把它们一个个封装起来，并且使它们可以相互替换。

实现策略模式需要实现两个部分：

第一部分为 **Strategy** 类，它封装了算法的实现，并提供了计算的接口。

第二部分为 **Context** 类，它会维持当前 Strategy 类的引用，让调用者改变策略，并将调用者的请求委托到相应的策略类。

<!-- more -->

接下来用例子说明策略模式。

## 实例

### 面向对象方式

用上班来做例子，可以选择搭地铁、巴士和骑单车。

先定义 Strategy 类，封装了计算费用的方法：

```javascript
var Metro = function(){};

Metro.prototype.getPrice = function(distance) {
  return distance > 10 ? 5 : 2;
};

var Bus = function(){};

Bus.prototype.getPrice = function(distance) {
  return 2;
};

var Bike = function(){};

Bike.prototype.getPrice = function(distance) {
  return 0;
};
```

然后定义 context 类：

```javascript
var Work = function() {
  this.distance = null;
};

Work.prototype.setDistance = function(distance) {
  this.distance = distance;
};

Work.prototype.setStrategy = function(strategy) {
  this.strategy = strategy;
};

Work.prototype.getPrice = function() {
  return this.strategy.getPrice(this.distance);
};

// 计算费用
var work = new Work();

work.setDistance(5);
work.setStrategy(new Metro());

console.log(work.getPrice()); // 2

work.setStrategy(new Bike());

console.log(work.getPrice()); // 0
```

### JavaScript 方式

由于 JavaScript 并不是严格的面向对象语言所以可以用更加简洁的方式实现。

```javascript
var strategies = {
  Metro: function(distance) {
    return distance > 10 ? 5 : 2;
  },
  Bus: function(distance) {
    return 2;
  },
  Bike: function(distance) {
    return 0;
  }
};
```

同时 context 类也可以更加简单，用一个普通的函数去完成委托。

```javascript
var getPrice = function(transportation, distance) {
  return strategies[transportation](distance);
};

console.log(getPrice('Bike', 10)); // 0
console.log(getPrice('Bus', 5)); // 2
```

感谢你的阅读，有不足之处请为我指出。

**参考**

1. [JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)
2. [Strategy](http://www.dofactory.com/javascript/strategy-design-pattern)

