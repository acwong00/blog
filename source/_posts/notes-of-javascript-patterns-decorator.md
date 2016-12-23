---
title: JavaScript 设计模式笔记（十二） —— 装饰者模式
date: 2016-12-22 15:12:05
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 装饰者模式
---

## 定义

装饰者模式(Decorator)动态地给某个对象添加额外的职责，而不会影响这个类中派生的其他对象。

装饰者模式又称为包装器(Wrapper)，因为其结构上看是一个对象陷入另一个对象里面，就像一层包一层。

<!-- more -->

## 例子

一个管理软件在 ajax 函数请求成功时会有可能因为权限等问题返回错误的代码，现在要在不改变原有 ajax 函数的情况下，根据返回的错误代码作出全局的提示。

### 构建装饰函数

```javascript
var before = function(fn, beforeFn) {
  return function() {
    beforeFn.apply(this, arguments); // 执行新函数
    return fn.apply(this, arguments); // 返回原函数执行结果
  };
};
```

### 定义错误处理函数

```javascript
var extendAjax = function(param) {
  param.success = before(param.success, handleErrCode);
};

var handleErrCode = function(result) {
  switch(result.errCode) {
    case '001':
      alert('权限不足');
      break;
    case '002':
      alert('非法操作');
      break;
    default:
      return;
  };
};
```

### 修改 `$.ajax`

```javascript
$.ajax = before($.ajax, extendAjax);
```

可以看到，这里一共用来两次 `before` 函数，一次是在请求 ajax 函数之前获取到请求的参数，另一次是用于修改请求成功的函数，作错误代码处理。

## 总结

装饰者模式的优点是相比起其他增强对象的方式（如继承）灵活得多，只要对一个对象使用不同的装饰器就可以起到不同的效果。而且，装饰器和被装饰的函数可以独立更改，互不影响，符合开闭原则。

装饰者模式的缺点增加了代码的复杂度，而且有多层装饰器的函数会变得难以调试、理解。

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)