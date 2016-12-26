---
title: JavaScript 设计模式笔记（十四） —— 适配器模式
date: 2016-12-26 12:18:48
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 适配器模式
---

## 定义

适配器模式的定义为：

> 适配器模式（Adapter）是将一个类（对象）的接口（方法或属性）转化成客户希望的另外一个接口（方法或属性），适配器模式使得原本由于接口不兼容而不能一起工作的那些类（对象）可以一些工作。

简单来说，适配器模式主要用于解决接口不兼容问题。

<!-- more -->

## 例子

google 地图和百度地图都有渲染地图的函数，但接口命名不同。可以通过增加适配器去进行兼容。

```javascript
var googleMap = {
  show: function() {
    console.log('开始渲染谷歌地图');
  }
};

var baiduMap = {
  display: function() {
    console.log('开始渲染百度地图');
  }
};

var renderMap = function(map) {
  if (map.show instanceof Function) {
    map.show();
  }
};

var baiduMapAdapter = {
  show: function() {
    return baiduMap.display();
  }
};

renderMap(googleMap);
renderMap(baiduMapAdapter);
```

## 总结

一般情况下，拿到不匹配的接口，我们很难去修改原有的代码，适配器模式可以很方便的解缺接口不匹配的问题，不需要修改接口代码，只要在接口外再包装一层。客户不需了解原有的接口，只要调用适配器就可以了。

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)