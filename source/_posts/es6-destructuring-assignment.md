---
title: ES6/ES7 三点式 —— 扩展运算符与剩余操作符
date: 2017-09-23 16:56:42
tags: [JavaScript,ECMAScript6,ECMAScript7]
categories: 学习笔记
description: 介绍 ES6(EMCAScript 2015) 的扩展语句语法及应用
---

ES6 标准提供给 JavaScript 开发者许多简化代码的新特性，今天要介绍的扩展运算符就是非常常用的一种。可以使你的代码更加简洁优雅。

<!-- more -->


## 扩展运算符

扩展运算符以三个点的形式出现 `...` 可以将数组或者对象里面的值展开。

```javascript
const a = [1, 2, 3]

console.log(a) // 1 2 3

const b = {a: 1, b: 2}

console.log({c: 3, ...b}) // {a: 1, b: 2, c: 3}
```

### 扩展运算符的应用

接下来看看扩展运算符的常见应用。

**1.复制数组和复制对象**

```javascript
const a = [1, 2, 3]
const b = [...a]

// 相当于 b = a.slice()

console.log(a) // [1, 2, 3]
console.log(b) // [1, 2, 3]
console.log(a === b) // false
```

```javascript
const a = {a: 1, b: 2}
const b = {...a}

console.log(a) // {a: 1, b: 2}
console.log(b) // {a: 1, b: 2}
console.log(a === b) // false

// 相当于 const b = Object.assign({}, a)
```

要注意复制时候只会进行浅复制。

**2.合并数组和合并对象**

```javascript
const a = [1, 2, 3]
const b = [4, 5]

console.log([...a, ...b]) // [1, 2, 3, 4, 5]

// 相当于 a.concat(b)
```

```javascript
const a = {a: 1, b: 2}
const b = {b: 3, c: 4}

console.log({...a, ...b, c: 5}) // {a: 1, b: 3, c: 5}

// 相当于 Object.assign(a, b, {c: 5})
```

**3.类数组对象数组化**

前端开发当中经常会遇到一些类数组对象，如：function 的 arguments，document.querySelectorAll 等，通常会将这些类数组对象转换为数组的形式使其可以利用数组原型对象的方法。

```javascript
const divs = document.querySelectorAll('divs')

// divs.push 会报错

// slice 方式

divs = [].slice.call(divs)

// 使用扩展运算符

divs = [...divs]
```

**4.代替 apply 方法**

```javascript
function sum(x, y, z) {
  console.log(x + y + z)
}

const args = [1, 2, 3]
// apply 方式

fn.apply(null, args)

// 扩展运算符方式

fn(...args)
```

## 剩余操作符

另外一种以三个点 `...` 形式出现的是剩余操作符，与扩展操作符相反，剩余操作符将多个值收集为一个变量，而扩展操作符是将一个数组扩展成多个值。

```javascript
// 配合 ES6 解构的新特性
const [a, ...b] = [1, 2, 3]

console.log(a) // 1
console.log(b) // [2, 3]
```

最后再看一个例子，在日常开发当中非常常见，而且同时利用到扩展操作符和剩余操作符，在 React 开发当中常常会利用一些组件库，为了业务需要我们会将一些组件库提供的组件封装成业务组件方便开发。

```javascipt
import { Button } from 'antd'  // 组件库提供的组件

function MyButton({ isDanger, children, ...others }) {
  return (
    <div>
      {isDanger ? 
        <Button {...others} size="large" type="danger">{children}</Button> :
        <Button {...others} size="small" type="primary">{children}</Button>
      }
    </div>
  )
}
```

