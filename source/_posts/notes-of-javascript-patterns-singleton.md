---
title: JavaScript 设计模式笔记（一）—— 单例模式
date: 2016-07-23 09:42:44
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 单例模式
---

单例模式（Singleton）是一种常用的设计模式，它被定义为：

> 保证一个类**仅有一个实例**，并提供一个访问它的**全局访问**点。

实现单例模式的核心思想就是判断当前要创建的对象是否存在，若果存在则直接返回，反之则创建再返回。

<!-- more -->

## 单例模式实现方式

### 全局变量

由于 JavaScript 并不是一种严格的面向对象语言，所以并不一定需要为了创建一个唯一的对象而去定义一个类。因此得到一个唯一对象最简单的方法就是在全局声明一个对象。

```javascript
var a = {};
```

在全局声明的变量是独一无二的，而且在任何位置都可以访问，所以满足了单例的两个条件。

但是使用全局变量会带来命名空间污染，同时为变量管理带来困难。

### 函数方式创建

避免使用全局变量，利用一个函数来创建对象。

```javascript
var Singleton = (function() {
  var instance;
  
  function init() {
    /* 单例 */
    return {
      createTime: new Date()
    }
  }
  
  return {
    getInstance: function () {
      if (!instance) {
        instance = init();
      }
      return instance;
    }
  };
})();

var a = Singleton.getInstance();
var b = Singleton.getInstance();

console.log(a === b);    // true
```

利用一个闭包来保存单例是否已经创建避免使用全局变量，同时通过上述方式可以在调用 `getInstance` 方法时才创建单例对象，而非在页面加载好的时候创建，可以提高部分性能。

### 透明的单例模式

然而通常我们习惯像直接使用一个普通的类一样创建单例，所以可以将上面的方式进行修改。

```javascript
var Singleton = (function() {
  var instance;
  
  var Singleton = function() {
    if (!instance) {
      instance = this;
    }
    return instance;
  }

  return Singleton;
})();

var a = new Singleton();
var b = new Singleton();

console.log(a === b);    // true
```

### 通用惰性单例

想像一个场景，我们需要在页面创建一个唯一的登录弹窗，可以这样去写：

```javascript
var createLoginLayer = (function() {
  var div;
  return function() {
    if (!div) {
      div = document.createElement('div');
      div.innerHTML = '我是登录弹窗';
      div.style.display = 'none';
      document.body.appendChild('div');
    }
    
    return div;
  };
})();
```

这样写已经不错了，可以在需要用到弹窗的时候才创建，但是这段代码有一个缺点，如果下次在页面想创建一个唯一的 iframe 时，几乎就要将函数照炒一遍。

所以需要将不变的部分分离出来。

```javascript
var getSingle = function(fn) {
  var result;
  return function() {
    return result || (result = fn.apply(this, arguments));
  };
};

var createLoginLayer = function() {
  var div = document.createElement('div');
  div.innerHTML = '我是登录浮窗';
  div.style.display = 'none';
  document.body.appendChild(div);
  return div;
￼￼};

var createIframe = function() {
  var iframe = document.createElement('iframe');
  document.body.appendChild(iframe);
  return iframe;
};

var createSingleLoginLayer = getSingle(createLoginLayer);
var createSingleIframe = getSingle(createIframe);

var loginLayer = createSingleLoginLayer();
var iframe = createSingleIframe();
```

感谢您的阅读，有不足之处请在评论为我指出。

**参考**

1. [JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)
2. [深入理解JavaScript系列（25）：设计模式之单例模式](http://www.cnblogs.com/TomXu/archive/2012/02/20/2352817.html)
