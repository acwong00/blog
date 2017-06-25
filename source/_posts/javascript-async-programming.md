---
title: JavaScript 异步编程的四种方式
date: 2017-06-24 15:52:17
tags: [JavaScript,ECMAScript6,ECMAScript7,异步编程]
categories: 学习笔记
---

异步编程是每个使用 JavaScript 编程的人都会遇到的问题，无论是前端的 ajax 请求，或是 node 的各种异步 API。本文就来总结一下常见的四种处理异步编程的方法。

<!-- more -->

## 回调函数

使用回调函数是最常见的一种形式，下面来举几个例子：

```javascript
// jQuery ajax
$.get('test.html', data => {
  $('#result').html(data)
})
```

```javascript
// node 异步读取文件
const fs = require('fs')

fs.readFile('/etc/passwd', (err, data) => {
  if (err) {
    throw err
  }
  console.log(data)
})
```
回调函数非常容易理解，就是定义函数的时候将另一个函数（回调函数）作为参数传入定义的函数当中，当异步操作执行完毕后在执行该回调函数，从而可以确保接下来的操作在异步操作之后执行。

回调函数的缺点在于当需要执行多个异步操作的时候会将多个回调函数嵌套在一起，组成代码结构上混乱，被称为回调地狱（callback hell）。

```javascript
func1(data0, data1 => {
  func2(data2, data3 => {
    func3(data3, data4 => data4)
  })
})
```

## Promise

Promise 利用一种链式调用的方法来组织异步代码，可以将原来以回调函数形式调用的代码改为链式调用。

```javascript
// jQuery ajax promise 方式
$.get('test.html')
  .then(data => $(data))
  .then($data => $data.find('#link').val('href'))
  .then(href => console.log(href))
```

自己定义一个 Promise 形式的函数在 ES6 当中也非常简单：

```javascript
function ready() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve('ready')
    }, 3000)
  })
}

ready().then(ready => console.log(`${ready} go!`))
```

在 node 8.0 以上的版本还可以利用 `util.promisify` 方法将回调形式的函数变为 Promise 形式。

```javascript
const util = require('util')
const fs = require('fs')

const readPromise = util.promisify(fs.readFile)

readPromise('test.txt').then(data => console.log(data.toString()))
```

想详细了解 Promise 可以阅读拙作[谈谈 ES6 的 Promise 对象](http://blog.acwong.org/2015/06/22/es6-promise/)。

## Generator

