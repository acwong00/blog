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

## Generators

node 的著名开发者 TJ 利用 ES6 新特性生成器（Generators）开发了一个异步控制工具 [co](https://github.com/tj/co)。

如果不了解 Generators 可以看看以下的文章：

- [深入浅出ES6（三）：生成器 Generators](http://www.infoq.com/cn/articles/es6-in-depth-generators)
- [深入浅出ES6（十一）：生成器 Generators，续篇](http://www.infoq.com/cn/articles/es6-in-depth-generators-continued)

利用 co 可以将异步代码的写法写成类似同步代码的形式：

```javascript
const util = require('util')
const fs = require('fs')
const co = require('co')

const readFile = util.promisify(fs.readFile)

co(function* () {
  const txt = yield readFile('file1.txt', 'utf8')
  console.log(txt)
  const txt2 = yield readFile('file2.txt', 'utf8')
  console.log(txt2)
})
```

使用 Generators 的好似显然易见，可以使异步代码写得非常清晰，缺点就是要另外引入相关的库来利用该特性。

## Async/Await

node7.6 以上的版本引入了一个 ES7 的新特性 Async/Await 是专门用于控制异步代码。先看一个例子：

```javascript
const util = require('util')
const fs = require('fs')

const readFile = util.promisify(fs.readFile)

async function readFiles () {
  const txt = await readFile('file1.txt', 'utf8')
  console.log(txt)
  const txt2 = await readFile('file2.txt', 'utf8')
  console.log(txt2)
})
```

首先要使用 `async` 关键字定义一个包含异步代码的函数，在 Promise 形式的异步函数前面使用 `await` 关键字就可以将异步写成同步操作的形式。

看上去与 Generators 控制方式相差不大，但是 Async/Await 是原生用于控制异步，所以是比较推荐使用的。

## 错误处理

最后来探讨下四种异步控制方法的错误处理。

### 回调函数

回调函数错误处理非常简单，就是在回调函数中同时回传错误信息：

```javascript
const fs = require('fs')

fs.readFile('file.txt', (err, data) => {
  if (err) {
    throw err
  }
  console.log(data)
})
```

### Promise

Promise 在 `then` 方法之后使用一个 `catch` 方案来捕捉错误信息：

```javascript
const fs = require('fs')
const readFile = util.promisify(fs.readFile)

readFile('file.txt')
  .then(data => console.log(data))
  .catch(err => console.log(err))
```

### Generators 和 Async/Await

Generators 和 Async/Await 比较类似，可以有两种方式，第一种使用 Promise 的 `catch` 方法，第二种用 `try` `catch` 关键字。

**Promise catch**

```javascript
const fs = require('fs')
const co = require('co')
const readFile = util.promisify(fs.readFile)

co(function* () {
  const data = yield readFile('file.txt').catch(err => console.log(err))
})
```

```javascript
const fs = require('fs')
const co = require('co')
const readFile = util.promisify(fs.readFile)

async function testRead() {
  const data = await readFile('file.txt').catch(err => console.log(err))
}
```

**try/catch**

```javascript
const fs = require('fs')
const co = require('co')
const readFile = util.promisify(fs.readFile)

co(function* () {
  try {
    const data = yield readFile('file.txt')
  } catch(err) {
    console.log(err)
  }
})
```

```javascript
const fs = require('fs')
const readFile = util.promisify(fs.readFile)

async function testRead() {
  try {
    const data = await readFile('file.txt')
  } catch(err) {
    console.log(data)
  }
}
```

感谢您的阅读，有不足之处请为我指出。

**参考**

1. [谈谈 ES6 的 Promise 对象](http://blog.acwong.org/2015/06/22/es6-promise/)
2. [深入浅出ES6（三）：生成器 Generators](http://www.infoq.com/cn/articles/es6-in-depth-generators)
3. [深入浅出ES6（十一）：生成器 Generators，续篇](http://www.infoq.com/cn/articles/es6-in-depth-generators-continued)