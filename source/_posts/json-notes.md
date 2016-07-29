---
title: JSON 笔记
date: 2015-03-05 14:27:31
tags: [JSON, JavaScript, JavaScript对象]
categories: 学习笔记
description: 有关 JSON 知识的总结。
---

JSON 全称为 JavaScript Object Notation(JavaScript对象表示法)，它利用与 JavaScript 对象相似的表示方法来表示数据。虽然 JSON 脱胎于 JavaScript，但是 JSON 并不属于 JavaScript 的一部分，很多的语言都可以解析和序列化 JSON。

<!-- more -->

## JSON 语法

JSON 可以表示以下三种类型的值：

- 简单值
- 对象
- 数组

**简单值**包括字符串、数值、布尔值和 null。**但是要注意的是 JSON 不能表示 JavaScript 当中的一种特殊值 undefinde**。

**对象**，与 JavaScript对象相似，表示无序的键值对。键值对中的值可以是简单值，也可以是对象或数组。

**数组**，与 JavaScript数组相似，表示一组有序的值，数组的值可以是简单值，也可以是对象或数组。

举个例子：

```
{
    "name": "acwong",
    "age": 23,
    "address": {
        "province": "GuangDong",
        "city": "GuangZhou"
    },
    "friends": ["bc", "cc", "dc"],
    "blog": "http://acwong.org"
}
```

需要注意的是，也是与 JavaScript对象表示方法的不同之处，JSON 字符串当中对象的属性必须加上**双引号**。

```
// 正确示范
{
    "name": "acwong"
}

// 错误示范
{
    name: "acwong"
}
// 单引号也是错误的
{
    'name': 'acwong'
}
```

## JavaScript 与 JSON

### JSON 对象

在 JSON 诞生之初 JavaScript 处理 JSON 的方式基本就靠 `eval()` 函数。

`eval()` 函数可以解析 JSON 然后返回 JavaScript 数组。但是由于 `eval()` 存在安全的风险，因此在 EMCAScript 5 开始有了一个新的全局对象 **JSON对象**用来处理 JSON。

### 序列化 JSON

JavaScript 使用 JSON对象的 `stringify()` 方法来序列化 JSON。

```javascript
var person = {
    name: "acwong",
    age: 23,
    address: {
        province: "GuangDong",
        city: "GuangZhou"
    },
    friends: ["bc", "cc", "dc"],
    blog: "http://acwong.org"
};

var jsonText = JSON.stringify(person);

console.log(jsonText);
// {"name":"acwong","age":23,"address":{"province":"GuangDong","city":"GuangZhou"},"friends":["bc","cc","dc"],"blog":"http://acwong.org"}
```

`JSON.stringify()` 方法在默认情况下输出的 JSON字符串不包含空格字符和缩进。

如果 JavaScript对象当中包含不被 JSON 支持的类型（如：undefined，函数）会自动被 `stringigy()` 方法忽略。

```javascript
var person = {
    name: "acwong",
    blog: undefined,
    todo: function() {
        return "sleep";
    }
};

var jsonText = JSON.stringify(person);

console.log(jsonText);
// {"name":"acwong"}
```

`JSON.stringify()` 方法包含三个参数，第一个参数就是要序列化的 JavaScript对象。第二个参数完成**过滤**输出结果功能。第三个参数控制输出字符串的**缩进**。

#### 过滤输出结果

第二个参数完成过滤输出结果功能。

当传入的第二个参数为**数组**时，输出的 JSON字符串只会保留包含在该数组里面的属性值。

```
var person = {
    name: "acwong",
    age: 23,
    address: {
        province: "GuangDong",
        city: "GuangZhou"
    },
    friends: ["bc", "cc", "dc"],
    blog: "http://acwong.org"
};

var jsonText = JSON.stringify(person, ["name","blog"]);

console.log(jsonText);
// {"name":"acwong","blog":"http://acwong.org"}
```

当传入的第二个参数为**函数**，该函数包含两个参数，分别是 JavaScript对象的属性名和属性值。输出的 JSON字符串会受到该函数的返回值影响。

```javascript
// 省略 person对象
var jsonText = JSON.stringify(person, function(key, value) {
    if (key === "name") {
        return "ac";
    } else if (key === "age") {
        value++;
        return value;
    } else {
        return value;
    }
});

console.log(jsonText);
// {"name":"ac","age":24,"address":{"province":"GuangDong","city":"GuangZhou"},"friends":["bc","cc","dc"],"blog":"http://acwong.org"}

```

#### 控制缩进

第三个参数控制输出字符串的**缩进**。

当第三个参数传入一个**数值**的时候，表示输出字符串缩进的空格数。

```javascript
// 省略 person对象
var jsonText = JSON.stringify(person, null, 2);

console.log(jsonText);
```

```javascript
// 输出
{
  "name": "acwong",
  "age": 23,
  "address": {
    "province": "GuangDong",
    "city": "GuangZhou"
  },
  "friends": [
    "bc",
    "cc",
    "dc"
  ],
  "blog": "http://acwong.org"
}
```

当第三个参数传入一个**字符串**时，输出结果会以该字符串作为缩进符号。

```javascript
// 省略 person对象

// 使用 * 号缩进
var jsonText = JSON.stringify(person, null, "*");

console.log(jsonText);
```

```javascript
// 输出
 {
*"name": "acwong",
*"age": 23,
*"address": {
**"province": "GuangDong",
**"city": "GuangZhou"
*},
*"friends": [
**"bc",
**"cc",
**"dc"
*],
*"blog": "http://acwong.org"
}
```

```javascript
// 省略 person对象

// 使用制表符(Tab)缩进
var jsonText = JSON.stringify(person, null, "\t");

console.log(jsonText);
```

```javascript
// 输出
 {
	"name": "acwong",
	"age": 23,
	"address": {
		"province": "GuangDong",
		"city": "GuangZhou"
	},
	"friends": [
		"bc",
		"cc",
		"dc"
	],
	"blog": "http://acwong.org"
}
```

#### 自定义序列化

如果上述的方法都不能满足要求，还可以在要序列化的 JavaScript对象当中加入 `toJSON()` 函数，可以返回任何想返回的值。

```javascript
var person = {
    name: "acwong",
    age: 23,
    address: {
        province: "GuangDong",
        city: "GuangZhou"
    },
    friends: ["bc", "cc", "dc"],
    blog: "http://acwong.org",
    toJSON: function() {
        this.name = "ac";
        return "yoyo " + this.name;
    }
};

var jsonText = JSON.stringify(person);

console.log(jsonText);
//  "yoyo ac"
```

### 解析 JSON

JavaScript 使用 JSON对象的 `parse()` 方法来解析 JSON。

```
var jsonText = '{"name":"acwong","age":23,"address":{"province":"GuangDong","city":"GuangZhou"},"friends":["bc","cc","dc"],"blog":"http://acwong.org"}';

var person = JSON.parse(jsonText);

console.log(person);
```

![parse-json](http://acwongblog.qiniudn.com/2015-03_parse-json.PNG)

`JSON.parse()` 同样可以传入一个函数作为参数，对键值对进行操作。

```
var jsonText = '{"name":"acwong","age":23,"blog":"http://acwong.org"}';

var person = JSON.parse(jsonText);

console.log(person);
```

![parse-json-with-fun](http://acwongblog.qiniudn.com/2015-03_parse-json-with-fun.PNG)

## JSON 的好处

1. 与 XML 一样可以表示复杂的数据结构。
2. 比 XML 轻量得多。
3. 语法简单易懂。
4. 由于其轻量级，在传输的时候占用的资源相对较少。

感谢您的阅读，有不足之处请为我指出。

**参考**

[JavaScript高级程序设计(第3版)](http://book.douban.com/subject/10546125/)
