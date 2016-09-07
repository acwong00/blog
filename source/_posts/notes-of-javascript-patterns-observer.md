---
title: JavaScript 设计模式笔记（五）—— 观察者模式
date: 2016-09-05 15:56:56
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 观察者模式
---

## 定义

观察者（Observer）模式定义一种一对多的依赖关系，当一个对象的状态发生改变时，所以依赖它的对象都会得到通知。在 JavaScript 当中事件模型就是一种常见的观察者模式。

观察者模式有如下特点：

1. 使用简单的广播通信，自动通知已经订阅的对象。可以用于异步编程替代回调函数方式。
2. 观察者对象和目标对象之间耦合比较松散，两个对象能够单独扩展。
3. 有新订阅者出现的时候发布者不虽然进行修改，同时发布者进行修改时亦不会影响订阅者。

<!-- more -->

## 全局的观察者模式

```javascript
var Event = (function() {
  var clientList = [];  // 用于存放订阅者标识符和回调函数
  var listen;
  var trigger;
  var remove;

  /**
   * 订阅方法
   * @param  {String}   key 标识符
   * @param  {Function} fn  订阅者回调函数
   */
  listen = function (key, fn) {
    if (!clientList[key]) {
      clientList[key] = [];
    }
    clientList[key].push(fn); // 用数组保存所有订阅者的回调函数
  };

  trigger = function () {
    var key = Array.prototype.shift.call(arguments);
    var fns = clientList[key];
    if (!fns || fns.length === 0) {
      return false;
    }
    for (var i = 0, fn; fn = fns[i++];) {
      fn.apply(this, arguments);
    }
  };

  remove = function (key, fn) {
    var fns = clientList[key];
    if (!fns) {
      return false;
    }
    if (!fn) {
      fns && (fns.length = 0); // 如果没有传入具体的回调函数，则将对应 key 的订阅全部取消
    } else {
      for (var l = fns.length - 1; l >= 0; l--) {
        var _fn = fns[l];
        if (_fn === fn) {
          fns.splice(l, 1);
        }
      }
    }
  };

  return {
    listen: listen,
    trigger: trigger,
    remove: remove
  }
})();

Event.listen('hello', function (name) {
  console.log('hello ' + name);
});

Event.trigger('hello', 'acwong'); // hello acwong
```

## 总结

观察者模式的优点在于可以完成时间和空间上的解耦，时间上可以用于异步编程当中，空间上可以通过通知完成两个对象之间的通讯。

观察者模式的缺点是在通知未发生之前订阅者会一直存于内存当中，造成一定的消耗，而且如果大量使用观察者模式会使结构难已理解，造成分析和调试的困难。

感谢你的阅读，有不足之处请为我指出。

**参考**

1. [JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)
2. [深入理解JavaScript系列（32）：设计模式之观察者模式](http://www.cnblogs.com/TomXu/archive/2012/03/02/2355128.html)