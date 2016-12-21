---
title: JavaScript 设计模式笔记（三）—— 代理模式
date: 2016-08-16 10:28:38
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 代理模式
---

## 定义

代理模式的定义为：

> 为其他对象提供一个代理以控制对该对象的访问

## 代理模式的分类

**保护代理（Protect Proxy）**可以帮助目标对象识别不同权限的访问，过滤掉不合要求的请求。

**虚拟代理（Virtual Proxy）**接受一个请求（需要创建资源消耗较大的对象），在需要创建的时候才会创建。

**缓存代理（Cache Proxy）**为一些运算结果提供暂时的存储，若下次传递的参数与之前一致，可立刻返回结果。

<!-- more -->

## 虚拟代理实例

先在页面上定义由多个 checkbox 组成的列表。

```html
<input type="checkbox" value="1">1
<input type="checkbox" value="2">2
<input type="checkbox" value="3">3
<input type="checkbox" value="4">4
<input type="checkbox" value="5">5
<input type="checkbox" value="6">6
<input type="checkbox" value="7">7
<input type="checkbox" value="8">8
<input type="checkbox" value="9">9
```

假设每点击 checkbox 就会向服务器发送一个请求，不使用代理模式的写法是：

```javascript
var synchronousFile = function(id) {
  console.log('开始同步文件，id 为：' + id);
};

var checkbox = document.getElementsByTagName('input');

for (var i = 0, c; c = checkbox[i++];) {
  c.onclick = function() {
    if (this.checked === true) {
      synchronousFile(this.value);
    }
  }
}
```

这种方法的缺点在于，如果点击过快会导致频繁的网络请求，增加服务器处理的压力。利用虚拟代理将请求方法改为收集两秒内点击的请求再延迟发送到服务器，可以大大降低服务器的压力。

```javascipt
var synchronousFile = function(id) {
  console.log('开始同步文件，id 为：' + id);
};

var proxySynchronousFile = (function() {
  var cache = [];   // 保存2秒内需要请求的id
  var timer;
  
  return function(id) {
    cache.push(id);
    if (timer) {
      return;
    }
    timer = setTimeout(function() {
      synchronousFile(cache.join(','));
      clearTimeout(timer);
      timer = null;
      cache.length = 0;  // 清空缓存的id
    }, 2000);
  }
})();

var checkbox = document.getElementsByTagName('input');

for (var i = 0, c; c = checkbox[i++];) {
  c.onclick = function() {
    if (this.checked === true) {
      proxySynchronousFile(this.value);
    }
  }
}
```

## 缓存代理实例

一个用于求乘积的函数，如果传入相同的参数就直接返回缓存的结果。

```javascript
var mult = function() {
  var a = 1;
  for (var i = 0, l = arguments.length; i < l; i++) {
    a = a * arguments[i];
  }
  return a;
};

var createProxyFactory = function(fn) {
  var cache = {};
  return function() {
    var args = Array.prototype.join.call(arguments, ',');
    if (args in cache) {
      return cache[args];
    }
    return cache[args] = fn.apply(this, arguments);
  }
};

var proxyMult = createProxyFactory(mult);

console.log(proxyMult(1, 2, 3)); // 6
console.log(proxyMult(1, 2, 3)); // 6 
```

## 代理模式的接口一致性

在 Java 语言中实现代理模式时，代理和本体对象都需要实现相同的接口，使得代理和本体可以替代使用。但在 JavaScript 当中只要代理对象和本体对象都接受相同的函数并可以正常执行，就可以被认为是具有同一接口。

感谢你的阅读，有不足之处请为我指出。

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)



