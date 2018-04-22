---
title: 立即执行函数表达式 —— IIFE
date: 2018-04-18 21:06:04
tags: [JavaScript,闭包,作用域,设计模式]
categories: 学习笔记
description: 立即执行函数表达式 —— IIFE
---

无论阅读源码还是日常开发当中常常会见到 `(function(){ ... })()` 这种形式的表达式，它就是 IIFE，立即执行函数表达式（Immediately Invoked Function Expression）。除了上述的结构以外还有另一种形式同样非常常见 `(function() { ... }())`。下面介绍 IIFE 常见的应用。

## 避免污染全局作用域

IIFE 最常见的应用可见于各种前端 Javascript 库当中，避免库中定义的变量污染全局作用域。

```javascript
// jQuery 3.3.1
(function(global, factory) {
  // ... jQuery code
})(typeof window !== "undefined" ? window : this, function(window, noGlobal) {
  // ... factory code
})
```

```javascript
// lodash 4.17.5
(function() {
  // ... lodash code
}.call(this))
```

上述两个例子分别是 jQuery 和 lodash 使用 IIFE 的例子，可以看到除了避免全局作用域被污染以外，两者都利用 IIFE 的参数将全局的变量传入函数作用域当中，jQuery 还统一将不同环境当中的全局作用域通通重命名为 `global`。

另外，除了传入全局变量以外，还可以传入任何你想传入的东西，如 jQuery 代码当中就传入了一个名为 `factory` 的函数。另一个常见传入的就是 `undefined`，避免 `undefined` 被覆盖而导致的异常。

```javascript

(function (undefined) {
  // 可以确定使用 undefined 是安全的
})()
```

## 闭包

在学习 JavaScript 作用域知识的时候常常见到下面这样的问题：

定时输出数字 1~5，但结果输出的全部是6.

```javascript
for (var i = 1; i <= 5; i++) {
  setTimeout(function () {
    console.log(i)
  }, i * 1000)
}
```

又如希望点击列表元素输出相应数字，结果输出的全部是6.

```html
<div id="list">
  <li>1</li>
  <li>2</li>
  <li>3</li>
  <li>4</li>
  <li>5</li>
</div>
```

```javascript
var lists = document.querySelectorAll('#list li')
for (var i = 0; i < 5; i++) {
  lists[i].addEventListener('click', function() {
    console.log(i + 1)
  })
}
```

由于回调函数是在循环结束之后才被执行，在语义上我们感觉是每次回调函数绑定的是当时循环的 `i`，而实际上所有的匿名函数都是共用一个 `i` 的引用，所以会发现输出的都是6，并不是原来希望的结果。

为了解决这个问题，我们可以使用 IIFE 来创建一个作用域来捕获当时循环的 `i`。

```javscript
for (var i = 1; i <= 5; i++) {
  (function(j) {
    setTimeout(function() {
      console.log(j)
    }, j * 1000)
  })(i)
}
```

```javscript
var lists = document.querySelectorAll('#list li')
for (var i = 0; i < 5; i++) {
  (function(j) {
    lists[j].addEventListener('click', function() {
      console.log(j + 1)
    })
  })(i)
}
```

当然，上述只是用来说明 IIFE 的作用，更好的方案应该使用 `let` 关键字以及不在每个元素绑定事件而是使用事件代理。

同样利用 IIFE 结合闭包可以实现简单的单例模式。

```javascript
var foo = (function CoolModule() {
  var something = 'cool'
  var another = [1, 2, 3]
  
  function doSomething() {
    console.log(something)
  }
  
  function doAnother() {
    console.log(another.join('!'))
  }
  
  function changeSomething() {
    something += '!'
  }
  
  return {
    doSomething: doSomething,
    doAnother: doAnother,
    changeSomething: changeSomething
  }
})()

foo.doSomething() // cool
foo.doAnother() // 1!2!3
foo.changeSomething()
foo.doSomething() // cool!
```

最后，IIFE 给我们提供了非常强大的功能，使用的时候最重要的是理解 IIFE 包装了一个函数作用域，使得外部作用域无法访问函数内的内容，同时通过访问函数内部以各种形式暴露的函数形成闭包，从而实现各种强大的功能。

**参考**

[你不知道的JavaScript（上卷）](https://book.douban.com/subject/26351021/)