---
title: JavaScript 设计模式笔记（十） —— 职责链模式
date: 2016-12-20 13:32:27
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 职责链模式
---

## 定义

> 职责链模式（Chain of responsibility）是使多个对象都有机会处理请求，从而避免请求的发送者和接受者之间的耦合关系。将这个对象连成一条链，并沿着这条链传递该请求，直到有一个对象处理他为止。

职责链模式在前端开发中最常见的例子就是 DOM 中的事件冒泡，当触发一个元素的事件时，元素会奖事件一直往上层元素传递，直到被处理事件的函数捕捉。

<!-- more -->

## 例子

一个手机商城网站，有预订活动，预付 500 元定金和 200 元订金的顾客可以分别获得 100 元优惠券和 50 元优惠券，而没有预付定金的顾客只能够普通购买，没有优惠券，而且库存为零的时候无法购买。定义 3 个字段。

- orderType： 订单类型 1，2，3 分别为 500元定金、200元定金、普通用户
- pay：是否支付定金
- stock：库存

### 定义处理函数

```javascript
var order500 = function(orderType, pay, stock) {
  if (orderType === 1 && pay === true) {
    console.log('500 元定金预购，得到 100 优惠券');
  } else {
    return 'nextSuccessor'; // 不满足条件，往下一个节点传递
  }
};

var order200 = function(orderType, pay, stock) {
  if (orderType === 2 && pay === true) {
    console.log('200 元定金预购，得到 50 优惠券');
  } else {
    return 'nextSuccessor';
  }
};

var orderNormal = function(orderType, pay, stock) {
  if (stock > 0) {
    console.log('普通购买，无优惠券');
  } else {
    console.log('手机库存不足');
  }
};
```

### 构造职责链函数

```javascript
// Chain.prototype.setNextSuccessor 指定链中的下一个节点
// Chain.prototype.passRequest 传递请求给某个节点

var Chain = funcion(fn) {
  this.fn = fn;
  this.successor = null;
};

Chain.prototype.setNextSuccessor = function(successor) {
  return this.successor = successor;
};

Chain.prototype.passRequest = function() {
  var ret = this.fn.apply(this, arguments);
  
  if (ret === 'nextSuccessor') {
    return this.successor && this.successor.passRequest.apply(this.successor, arguments);
  }
  
  return ret;
};
```

### 添加节点

```javascript
var chainOrder500 = new Chain(order500);
var chainOrder200 = new Chain(order200);
var chainOrderNormal = new Chain(orderNormal);

chainOrder500.setNextSuccessor(chainOrder200);
chainOrder200.setNextSuccessor(chainOrderNormal);
```

## 总结

职责链模式的优点在于解耦了请求者与多个接受者的关系，不需要知道哪一个接受者可以处理请求，只需把请求传递给第一个节点。

职责链模式要注意避免职责链过长导致的性能问题。

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)