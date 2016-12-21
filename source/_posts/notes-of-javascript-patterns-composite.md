---
title: JavaScript 设计模式笔记（七）—— 组合模式
date: 2016-12-06 13:13:38
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 组合模式
---

## 定义

组合模式（Composite）定义为：

> 组合模式将对象组合成树形结构以表示“部分-整体”的层次结构，组合模式使得用户对单个对象和组合对象的使用具有一致性。

在上一篇文章[（JavaScript 设计模式笔记（六）—— 命令模式）](http://blog.acwong.org/2016/11/30/notes-of-javascript-patterns-command/#宏命令)当中有提到命令模式可以将多个命令组合在一起组成一个宏命令，这就是一个简单的组合模式。

<!-- more -->

宏命令对象与子命令对象之间形成树状结构，宏命令和子命令对象有相同的调用方法 `execute`。但宏命令的 `execute` 方法并不直接执行操作，而是遍历子命令对象执行真正的操作。

## 组合模式的组成

组合模式一般包括 3 种对象 Component、Leaf（叶对象）、Composite（组合对象），Leaf 和 Composite 都会继承于 Component，Component 使叶对象和组合对象拥有相同名字的方法，可以对来自父对象的请求作出反应。

叶对象和组合对象不同的地方在于叶对象没有子对象。

## 例子

这里用文件夹与文件来表示组合模式。

```javascript
// Folder 类
var Folder = function(name) {
  this.name = name;
  this.files = [];
};

Folder.prototype.add = function(file) {
  this.files.push(file);
};

Folder.prototype.scan = function() {
  console.log('扫描文件夹：' + this.name);
  for(var i = 0, file, files = this.files; file = files[i++];) {
    file.scan();
  }
};

// File 类
var File = function(name) {
  this.name = name;
};

File.prototype.add = function() {
  // File 类的 add 方法要抛出错误
  throw new Error('文件下面不能添加文件');
};

File.prototype.scan = function() {
  console.log('扫描文件：' + this.name);
};
```

## 组合模式需要注意的地方

- 组合模式不是父子关系
- 对叶对象操作需要有一致性
- 叶对象不能属于多个组合对象
- 可以使用职责链模式提升性能

## 总结

组合对象优点：

- 应用于表示部分整体结构的树形对象，可以很方便对整棵树进行统一的操作
- 可以忽略操作的对象是叶对象还是组合对象，组合对象和叶对象都会各自完成操作

组合模式缺点在于使用会导致代码理解困难同时有可能会导致性能问题。

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)