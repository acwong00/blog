---
title: JavaScript 设计模式笔记（九）—— 享元模式
date: 2016-12-16 14:13:52
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 享元模式
---

## 定义

享元模式（Flyweight）使用共享技术，用来支持大量细粒度的对象。是一种为了提高性能而诞生的设计模式。

享元模式通过将大量相似的对象的属性划分内部状态和外部状态，将内部状态相同的对象指定为同一个共享对象，外部状态储存在外部，在调用方法在传进来，达到节省对象数目的目的。

<!-- more -->

## 例子

现在有一个咖啡馆，销售各种咖啡给顾客，定义咖啡的属性，味道、台号、数量：

```
flavor
table
num
```

```javascript
var CoffeeOrder = function(id, flavor, table, num){
  this.id = id;
  this.flavor = flavor;
  this.table = table;
  this.num = num
};

CoffeeOrder.prototype.serving = function() {
  console.log('送到' + this.table + '号台的' + this.flavor + '共' + this.num + '杯');
};
```

```javascript
var id = 0

var startServing = function(orders) {
  for (var i = 0, order; order = orders[i++];) {
    var coffeeOrder = new CoffeeOrder(id++, order.flavor, order.table, order.num);
    coffeeOrder.serving();
  }
};

startServing([
  {
    flavor: 'Cappuccino',
    table: 1,
    num: 1
  }, {
    flavor: 'Xpresso',
    table: 1,
    num: 1
  }, {
    flavor: 'Xpresso',
    table: 2,
    num: 2
  }, {
    flavor: 'Latte',
    table: 3,
    num: 1
  }
]);
```

## 内部状态和外部状态

上述的代码没有用享元模式优化的情况下，有多少个咖啡订单的时候就会创建多少个对象。

要用享元模式重构，首先要划分内部状态和外部状态，划分方法有以下几条经验：

> - 内部状态存储于对象内部
> - 内部状态可以被一些对象共享
> - 内部状态独立于具体的场景，通常不会改变。
> - 外部状态取决于具体的场景，并根据场景而变化，外部状态不能被共享

上述的例子中可以看出，味道 `flavor` 是内部状态，台号 `table` 和数量 `num` 就是外部状态。

## 享元模式重构例子

### 创建 Coffee 工厂

```javascript
var Coffee = function(flavor) {
  this.flavor = flavor;
};

Coffee.prototype.serving = function(id) {
  orderManager.setExternalState(id, this);
  console.log('送到' + this.table + '号台的' + this.flavor + '共' + this.num + '杯');
};

var CoffeeFactory = (function() {
  var existingCoffee = {};
  
  return {
    createCoffee: function(flavor) {
      if (existingCoffee[flavor]) {
        return existingCoffee[flavor];
      }
      
      return existingCoffee[flavor] = new Coffee(flavor);
    }
  }
})();
```

### 管理封装外部状态

```javascript
var orderManager = (function() {
  var orderDatabase = {};
  
  return {
    add: function(id, flavor, table, num) {
      var flyWeightObj = CoffeeFactory.createCoffee(flavor);
      
      orderDatabase[id] = {
        table: table,
        num: num
      };
      return flyWeightObj;
    },
    setExternalState: function(id, flyWeightObj) {
      var orderData = orderDatabase[id];
      for (var i in orderData) {
        flyWeightObj[i] = orderData[i];
      }
    }
  }
})();
```

### 执行

```javascript
var id = 0;

var startServing = function(orders) {
  for (var i = 0, order; order = orders[i++];) {
    var coffeeOrder = orderManager.add(id, order.flavor, order.table, order.num);
    coffeeOrder.serving(id++);
  }
};

startServing([
  {
    flavor: 'Cappuccino',
    table: 1,
    num: 1
  }, {
    flavor: 'Xpresso',
    table: 1,
    num: 1
  }, {
    flavor: 'Xpresso',
    table: 2,
    num: 2
  }, {
    flavor: 'Latte',
    table: 3,
    num: 1
  }
]);
```

可以看到使用了享元模式之后，只要为每个咖啡味道创建一个对象就可以了。

## 总结

享元模式的优点在于可以大量减少内存里面的对象数量，通过分离外部状态使 flyweight 对象可以被共享。

享元模式的缺点是分离外部与内部状态使程序复杂性增加，另外因为用时间换取空间，会导致程序运行时间变长。

**参考**

1. [JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)
2. [深入理解JavaScript系列（37）：设计模式之享元模式](http://www.cnblogs.com/TomXu/archive/2012/04/09/2379774.html)