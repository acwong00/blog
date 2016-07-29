---
title: 谈谈 ES6 的 Promise 对象
date: 2015-06-22 17:43:07
tags: [JavaScript,ECMAScript6,Promise,异步编程]
categories: 技术研究
description: 介绍 ES6(EMCAScript 2015) 的原生 Promise
---

## 前言

开篇首先设想一个日常开发常常会遇到的需求：在多个接口异步请求数据，然后利用这些数据来进行一系列的操作。一般会这样去写：

```javascript
$.ajax({
    url: '......',
    success: function (data) {
        $.ajax({
            // 要在第一个请求成功后才可以执行下一步
            url: '......',
            success: function (data) {
                 // ......
            }
        });
    }
});
```

<!-- more -->


这样的写法的原理是，当执行一些异步操作时，我们需要知道操作是否已经完成，所有当执行完成的时候会返回一个回调函数，表示操作已经完成。

使用回调函数的形式理解起来并不困难，但是实际的应用当中会有以下的缺点：

1. 在需要多个操作的时候，会导致多个回调函数嵌套，导致代码不够直观，就是常说的 **Callback Hell**。
2. 如果几个异步操作之间并没有前后顺序之分（例如不需要前一个请求的结果作为后一个请求的参数）时，同样需要等待上一个操作完成再实行下一个操作。

为了解决上述的问题，Promise 对象应运而生，在 EMCAScript 2015 当中已经成为标准。

## 什么是 Promise

一个 Promise 对象可以理解为一次将要执行的操作（常常被用于异步操作），使用了 Promise 对象之后可以用一种链式调用的方式来组织代码，让代码更加直观。而且由于 `Promise.all` 这样的方法存在，可以让同时执行多个操作变得简单。接下来就来简单介绍 Promise 对象。

### resolve 和 reject

首先来看一段使用了 Promise 对象的代码。

```javascript
function helloWorld (ready) {
    return new Promise(function (resolve, reject) {
        if (ready) {
            resolve("Hello World!");
        } else {
            reject("Good bye!");
        }
    });
}

helloWorld(true).then(function (message) {
    alert(message);
}, function (error) {
    alert(error);
});
```

[jsFiddle](http://jsfiddle.net/acwong/rpswm61r/)(请用现代浏览器打开)

上面的代码实现的功能非常简单，`helloWord` 函数接受一个参数，如果为 `true` 就打印 "Hello World!"，如果为 `false` 就打印错误的信息。`helloWord` 函数返回的是一个 Promise 对象。

在 Promise 对象当中有两个重要方法————`resolve` 和 `reject`。

`resolve` 方法可以使 Promise 对象的状态改变成成功，同时传递一个参数用于后续成功后的操作，在这个例子当中就是 *Hello World!* 字符串。

`reject` 方法则是将 Promise 对象的状态改变为失败，同时将错误的信息传递到后续错误处理的操作。

### Promise 的三种状态

上面提到了 `resolve` 和 `reject` 可以改变 Promise 对象的状态，那么它究竟有哪些状态呢？

Promise 对象有三种状态：

- Fulfilled 可以理解为成功的状态
- Rejected 可以理解为失败的状态
- Pending 既不是 Fulfilld 也不是 Rejected 的状态，可以理解为 Promise 对象实例创建时候的初始状态

helloWorld 的例子中的 `then` 方法就是根据 Promise 对象的状态来确定执行的操作，resolve 时执行第一个函数（onFulfilled），reject 时执行第二个函数（onRejected）。

### then 和 catch

#### then

helloWorld 的例子当中利用了 `then(onFulfilld, onRejected)` 方法来执行一个任务打印 "Hello World!"，在多个任务的情况下 `then` 方法同样可以用一个清晰的方式完成。

```javascript
function printHello (ready) {
    return new Promise(function (resolve, reject) {
        if (ready) {
            resolve("Hello");
        } else {
            reject("Good bye!");
        }
    });
}

function printWorld () {
    alert("World");
}

function printExclamation () {
    alert("!");
}

printHello(true)
    .then(function(message){
        alert(message);
    })
    .then(printWorld)
    .then(printExclamation);
```

[jsFiddle](http://jsfiddle.net/acwong/rpswm61r/1/)

上述例子通过链式调用的方式，按顺序打印出了相应的内容。`then` 可以使用链式调用的写法原因在于，每一次执行该方法时总是会返回一个 Promise 对象。另外，在 `then` onFulfilled 的函数当中的返回值，可以作为后续操作的参数，因此上面的例子也可以写成：

```javascript
printHello(true).then(function (message) {
    return message;
}).then(function (message) {
    return message  + ' World';
}).then(function (message) {
    return message + '!';
}).then(function (message) {
    alert(message);
});
```

[jsFiddle](http://jsfiddle.net/acwong/rpswm61r/2/)

同样可以打印出正确的内容。

#### catch

`catch` 方法是 `then(onFulfilled, onRejected)` 方法当中 `onRejected` 函数的一个简单的写法，也就是说可以写成 `then(fn).catch(fn)`，相当于 `then(fn).then(null, fn)`。使用 `catch` 的写法比一般的写法更加清晰明确。

### Promise.all 和 Promise.race

`Promise.all` 可以接收一个元素为 Promise 对象的数组作为参数，当这个数组里面所有的 Promise 对象都变为 resolve 时，该方法才会返回。

```javascript
var p1 = new Promise(function (resolve) {
    setTimeout(function () {
        resolve("Hello");
    }, 3000);
});

var p2 = new Promise(function (resolve) {
    setTimeout(function () {
        resolve("World");
    }, 1000);
});

Promise.all([p1, p2]).then(function (result) {
    console.log(result); // ["Hello", "World"]
});
```

上面的例子模拟了传输两个数据需要不同的时长，虽然 p2 的速度比 p1 要快，但是 `Promise.all` 方法会按照数组里面的顺序将结果返回。

日常开发中经常会遇到这样的需求，在不同的接口请求数据然后拼合成自己所需的数据，通常这些接口之间没有关联（例如不需要前一个接口的数据作为后一个接口的参数），这个时候 `Promise.all` 方法就可以派上用场了。

还有一个和 `Promise.all` 相类似的方法 `Promise.race`，它同样接收一个数组，不同的是只要该数组中的 Promise 对象的状态发生变化（无论是 resolve 还是 reject）该方法都会返回。

## 兼容性

最后是关于 Promise 对象的兼容性问题。

[![Promise 兼容性](http://7q5etm.com1.z0.glb.clouddn.com/2015-06_promise-can-i-use.PNG)](http://7q5etm.com1.z0.glb.clouddn.com/2015-06_promise-can-i-use.PNG)

在浏览器端，一些主流的浏览器都已经可以使用 Promise 对象进行开发，在 Node.js 配合 babel 也可以很方便地使用。

如果要兼容旧的浏览器，建议可以寻找一些第三方的解决方案，例如 jQuery 的 [$.Deferred](http://api.jquery.com/category/deferred-object/)。

感谢你的阅读，有不足之处请为我指出。

**参考**

[JavaScript Promise迷你书（中文版）](http://liubin.github.io/promises-book/)
