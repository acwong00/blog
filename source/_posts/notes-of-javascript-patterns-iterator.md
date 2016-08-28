---
title: JavaScript 设计模式笔记（四）—— 迭代器模式
date: 2016-08-28 14:32:57
tags: [JavaScript,设计模式,ECMAScript6]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 迭代器模式
---

## 定义

迭代器模式（Iterator）的定义为：

> 提供一种方法顺序一个聚合对象中各个元素，而又不暴露该对象内部表示。

迭代器可以分为内部迭代器和外部迭代器。

<!-- more -->

## 内部迭代器

内部迭代器的特点是在函数内部已经定义好迭代规则，外部只要一次初始调用。

原生的 JavaScript 本身已经带有内部迭代器的实现 `Array.prototype.forEach`，而常见的内部迭代器还有 jQuery 的 `$.each` 和 lodash 的 `_.forEach`。接下来看看 jQuery 的迭代器实现。

**jQuery**

```javascript
each: function( obj, callback ) {
  var length, i = 0;
  
  if ( isArrayLike( obj ) ) {
    length = obj.length;
    for ( ; i < length; i++ ) {
      if ( callback.call( obj[ i ], i, obj[ i ] ) === false ) {
        break;
      }
    }
  } else {
    for ( i in obj ) {
      if ( callback.call( obj[ i ], i, obj[ i ] ) === false ) {
        break;
      }
    }
  }
  
  return obj;
}
```

迭代器不仅可以迭代数组，还可以迭代拥有 `length` 属性且可以以下标访问的类数组对象。jQuery 利用 JavaScript 的 `for in` 语句实现对对象的迭代。

```javascript
if ( callback.call( obj[ i ], i, obj[ i ] ) === false ) {
  break;
}
```

jQuery 还通过判断回调函数返回 `false` 实现中止迭代器的方法。

## 外部迭代器

外部迭代器与内部迭代器的区别在于外部迭代器必须显式请求下一个元素。

这里实现一个简单的外部迭代器：

```javascript
var Iterator = function(obj) {
  var current = 0;
  
  var next = function() {
    current += 1;
  };
  
  var isDone = function() {
    return current >= obj.length;
  };
  
  var getCurrItem = function() {
    return obj[current];
  };
  
  return {
    next: next,
    isDone: isDone,
    getCurrItem: getCurrItem
  };
};

var iterator = Iterator([1, 2, 3, 4]);

while(!iterator.isDone()) {
  console.log(iterator.getCurrItem()); // 顺序打印 1,2,3,4
  iterator.next();
}
```

### ECMAScript6 迭代器

ECMASCript6（下文简称 ES6）提供了 `for of` 的方法可以用于迭代实现了迭代器方法的对象，将上面的例子用 ES6 的语法改写。

```javascript
class Iterator {
  constructor(obj) {
    this.obj = obj;
    this.current = 0;
  }
  
  [Symbol.iterator]() {
    return this;
  }
  
  next() {
    if (this.current >= this.obj.length) {
      return {
        done: true,
        value: undefined
      };
    } else {
      var value = this.obj[this.current];
      this.current = this.current + 1;
      return {
        done: false,
        value: value
      }
    }
  }
}

var iterator = new Iterator([1, 2, 3, 4]);

// console.log(iterator.next()); 
// { done: false, value: 1 }

for (var value of iterator) {
  console.log(value); // 顺序打印 1,2,3,4
}
```

### ECMAScript6 生成器

ES6 实现迭代对象更加简单的方法是使用生成器，生成器内部已经内建有 `next()` 和 `[Symbol.iterator]()` 方法，所以可以将精力集中于循环部分。用生成器改写上面的代码：

```javascript
function* iterator(obj) {
  for (var current = 0; current < obj.length; current++) {
    yield obj[current];
  }
}

var myIterator = iterator([1,2,3,4]);

// console.log(myIterator.next()); 
// { done: false, value: 1 }

for (var value of myIterator) {
  console.log(value); // 顺序打印 1,2,3,4
}
```

感谢你的阅读，有不足之处请为我指出。

**参考**

1. [JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)
2. [深入浅出ES6（二）：迭代器和for-of循环](http://www.infoq.com/cn/articles/es6-in-depth-iterators-and-the-for-of-loop)
3. [深入浅出ES6（三）：生成器 Generators](http://www.infoq.com/cn/articles/es6-in-depth-generators)


