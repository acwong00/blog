---
title: JavaScript 中 this 绑定的对象
date: 2018-07-23 20:41:53
tags: [JavaScript]
categories: 学习笔记
---

在 JavaScript 工程师的面试当中， `this` 的绑定常常是考察的重点，现在就来总结一下如何判断 `this` 所绑定的对象。

在开始之前，首先要清楚一点是 ** 函数中的 `this` 是函数调用的时候被绑定的**。因此，判断  `this` 所绑定的对象也就是判断函数**调用的位置**。

## new 绑定

```javascript
function foo(a) {
  this.a = a
}
var bar = new foo(2)
console.log(bar.a) // 2
```

在有 `class` 关键字之前，通常会使用 `new` 关键字配合构造函数来实现面向对象编程。 使用 `new` 调用构造函数时，会执行下面的操作：

1. 创建一个新的对象
2. 新对象执行 [[Prototype]] 连接
3. 新对象会绑定到函数调用的 `this`
4. 如果函数没有返回其他对象，那么 `new` 表达式中的函数调用会自动返回该新对象

因此当使用 `new` 关键字构造新对象的时候，`this` 会被绑定到新创建的对象上面。

## 显式绑定

### call 和 apply

 `call` 和 `apply` 函数的第一个参数是一个对象，可以为当前调用的函数 强制指定一个 `this` 的绑定对象，此时， `this` 指向绑定的对象。

```javascript
function foo() {
  console.log(this.a)
}

var obj = { a: 2 }

foo.call(obj) // 2
```

### bind

`bind` 是 ES5 提供的一个方法，它 同样会为原始函数绑定一个 `this` 但不同的是它不会直接调用该函数，而是返回一个新的被包裹之后的函数，之后调用包裹后的函数，函数 `this` 都会指向新绑定的对象。

```javascript
function foo() {
  console.log(this.a)
}

var obj = { a: 2 }

var bar = foo.bind(obj)

bar() // 2
```

###  上下文参数

一些 JavaScrip 内置的函数也会提供用于显式绑定的参数，可以手动指定回调函数当中 `this` 的指向。

```javascript
function foo(el) {
  console.log(el, this.id)
}

var obj = {
  id: 'acwong'
}

// forEach 第二个参数用于指定回调的 this
[1, 2, 3].forEach(foo, obj) // 1 acwong 2 acwong 3 acwong
```

## 隐式绑定

```javascript
function foo() {
  console.log(this.a)
}

var obj = {
  a: 2,
  foo: foo
}

obj.foo() // 2
```

看上方的代码，函数 `foo` 并非在对象当中定义，而是定义之后当作属性添加到对象当中。但是由于使用 `obj` 调用，因此 `obj` 隐性绑定到  `foo` 上，成为其 `this` 上下文。

隐性绑定只与最后一层调用有关。

```javascript
function foo() {
  console.log(this.a)
}

var obj2 = {
  a: 42,
  foo: foo
}

var obj1 = {
  a: 2,
  obj2: obj2
}

obj1.obj2.foo() // 42
```

### 隐性丢失

隐性绑定有一个值得注意的现象——隐性丢失，隐性丢失是指 隐性绑定的函数会丢失对象，变为应用默认绑定，也就是将 `this` 绑定到全局对象或 `undefined`（严格模式时）上。

```javascript
function foo() {
  console.log(this.a)
}

var obj = {
  a: 2,
  foo: foo
}

var bar = obj.foo // 实际上是引用 foo 函数本身

var a = 'global'

bar() // global
```

```javascript
function foo() {
  console.log(this.a)
}

function doFoo(fn) {
  //  传入参数也相当于赋值
  fn()
}

var obj = {
  a: 2,
  foo: foo
}

var a = 'global'

doFoo(obj.foo) // 'global'
```

## 默认绑定

当上面规则到不能应用的时候就可以判断为默认绑定，`this` 会被绑定为全局对象或被绑定为 `undefined`（ 严格模式下）。

```javascript
function foo() {
  console.log(this.a)
}

var a = 2

foo() // 2
```

```javascript
function foo() {
  'use strict'

  console.log(this.a)
}

var a = 2

foo() // TypeError: this is undefined
```

##   被忽略的 this 和 箭头函数

接下来分享两种 比较常见的例外情况。

 **被忽略的  this**

当我们使用 `call` 和 `apply` 或者 `bind` 传入的绑定参数为 `null` 和 `undefined` 会被忽略， 取而代之会执行默认绑定。

```javascript
function foo() {
  console.log(this.a)
}

var a = 2

foo.call(null) // 2
```

**箭头函数**

ES6 当中新增的箭头函数，不应用上述的四条规则，不为函数绑定 `this` ,而是根据外层的作用域而定。

```javascript
function foo() {
  setTimeout(function() {
    console.log(this.a)
  }, 100)
}

var obj = {
  a: 2
}

foo.call(obj) // undefined
```

```javascript
function foo() {
  setTimeout(() => {
    console.log(this.a)
  }, 100)
}

var obj = {
  a: 2
}

foo.call(obj) // 2
```

## 小结

当我们遇到需要判断 `this` 所绑定对象的 问题时，可以遵循下面列出的规则来逐一判断：

1. `new` 关键字调用，绑定到新创建的对象。
2. `call`、` apply`、`bind` 调用，绑定到参数指定的对象（`null` 和 `undefined` 除外）。
3. 由上下文对象调用，绑定到改上下文。
4.  默认绑定，严格模式下为 `undefined`，否则为全局对象。

最后要留意例外规则。

**参考**

[你不知道的JavaScript（上卷）](https://book.douban.com/subject/26351021/)
