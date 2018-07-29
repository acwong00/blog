---
title: 《你不知道的 JavaScript 上卷》对象笔记
date: 2018-07-29 12:51:29
tags: [JavaScript]
categories: 学习笔记
---

## typeof null 为何返回 object

因为不同的对象在底层到表示为二进制，在 JavaScript 中二进制前三位都为 0 的话会判断为 `object` 类型，由于 `null` 二进制表示全为 0，所以就被判断为 `object`。

## 字面量和对象

```javascript
var strPrimitive = 'I am a string'
console.log(strPrimitive.length) // 13
console.log(strPrimitive.charAt(3)) // m
```

`strPrimitive` 是以文字形成创建，是一个字面量并不是一个对象，当调用诸如 `length`、`charAt` 这些方法时，引擎会自动将其转换为 `new String('I am a string')`。类似的还有布尔型和数值型变量。

- `null`、`undefined` 只有文字形式，没有构造形式。
- `Date` 只有构造形式，没有文字形式。
- `String`、`Number`、`Boolean` 文字形式创建字面量，构造形式创建对象。
- `Object`、`Array`、`Function`、`RegExp` 无论使用文字形式或构造形式创建，均为对象。
- `Error` 一般为抛出异常时自动创建，亦可以 `new Error()` 形式创建。

## 键访问

`myObject[..]` 这种形式访问对象的属性称为键访问，如将 `string` 字面量以外的值用于键访问，那该值会被转为字符串。

```javascript
var myObject = {}

myObject[true] = 'foo'
myObject[3] = 'bar'
myObject[myObject] = 'baz'

console.log(myObject['true']) // foo
console.log(myObject['3']) // bar
console.log(myObject['[object Object]']) // baz
```

## 方法访问

即使对象内定义的函数技术上并不属于该对象，而是通过该对象调用函数的时候才动态绑定上去。

## 深复制 JSON 安全的对象

对于字符安全的对象可以巧妙利用 `JSON` 对象的方法来进行复制

```javascript
var newObj = JSON.parse(JSON.stringify(oldObj))
```

## 属性描述符

ES5 以后所有对象的属性都具备属性描述符。

```javascript
var myObject = {
  a: 2
}

Object.getOwnPropertyDescriptor(myObject, 'a')
// {
//    value: 2,  
//    writable: true,
//    enumerable: true,
//    configurable: true
// }
```

`writable` 代表是否可以修改该属性的值，若为 `false` 则不能修改。

`configurable` 代表是否可以使用 `defineProperty` 来修改属性描述符。若为 `true` 还同时会禁止删除该属性。

`enumerable` 代表该属性是否可枚举，例如使用 `for..in` 循环时，就不会出现 `enumerable` 为 `false` 的属性。

**参考**

[你不知道的JavaScript（上卷）](https://book.douban.com/subject/26351021/)