---
title: Node.js 练习 —— 操作 MySQL 和 Redis
date: 2015-03-03 15:28:04
tags: [MySQL,Redis,关系型数据库,NoSQL数据库,Node.js]
categories: 技术实践
description: Node.js 小练习，生成随机激活码并把生成的激活码分别保存到 MySQL 和 Redis 当中。
---

新年新气象，博客换了一个新主题，继续 Node.js 小练习。

这次小联系的内容是生成随机激活码并把生成的激活码分别保存到 MySQL 和 Redis 当中。

题目来源 [Python 练习册](https://github.com/Show-Me-the-Code/show-me-the-code)。

## 题目0001

> 第 0001 题：做为 Apple Store App 独立开发者，你要搞限时促销，为你的应用生成激活码（或者优惠券），使用 Python 如何生成 200 个激活码（或者优惠券）？

<!-- more -->

这个题目需要我们生成 200个激活码。生成激活码有许多不同的方式，为了简单起见这里直接用 UUID 来代替。

**UUID(Universally Unique Identifier)** 可以帮助我们简单地创建随机而且不重复的字符串。

### node-uuid

在 Node.js 中使用 [node-uuid](https://github.com/broofa/node-uuid) 库来生成 UUID。该库可以简单地生成符合 RFC4122 标准的版本1 和版本4的UUID。版本1和版本4之间的区别是版本1根据时间戳来生成，而版本4是随机生成。

安装 node-uuid
```
npm install node-uuid
```

```javascript
// code.js
var uuid = require('node-uuid')

function getCode(number) {
    var codes = [];
    for (var i=0; i < number; i++) {
        codes.push(uuid.v4());
    }
    return codes
}

console.log(getCode(200));
```

运行 *code.js*

```
node code
```

结果

![Node.js 生成 UUID](http://acwongblog.qiniudn.com/2015-03_node-uuid.PNG)

## 题目0002

> 第 0002 题：将 0001 题生成的 200 个激活码（或者优惠券）保存到 MySQL 关系型数据库中。

首先，我们使用 `exports` 将上一题当中 `getCode` 可以被调用：

```javascript
// code.js
exports.getCode = getCode;
```

### node-mysql

要使用 Node.js 操作 MySQL 数据库，这里使用 [node-mysql](https://github.com/felixge/node-mysql/) 库。

```
npm install mysql
```

直接上代码：

```javascript
// code_insert_mysql.js
var mysql = require('mysql');
var code = require('./code.js'); // 引入上一题的 code.js

var codes = code.getCode(200);

// 创建连接
var conn = mysql.createConnection({
    host: 'localhost',
    user: 'test0002',
    password: 'test0002',
    database: 'test0002'
});

conn.connect(function(err){
    if (err) {
        console.error(err);
        return;
    }
});

var sql_create_table = 'CREATE TABLE IF NOT EXISTS code( ' +
                       'id SMALLINT AUTO_INCREMENT,' +
                       'code CHAR(20),' +
                       'PRIMARY KEY(id)' +
                       ')';
conn.query(sql_create_table, function(err, res){
    if (err) {
        console.log(err);
        return;
    }
    for (var i=0; i < codes.length; i++) {
        var sql_insert_code = "INSERT code VALUES('code','" + codes[i] + "')";
        conn.query(sql_insert_code, function(err, res){
            if (err) {
                console.error(err);
                return;
            }
            console.log(res);
        });
    }
    conn.end(); // 关闭连接
});
```

运行：

```
node code_insert_mysql
```

进入 MySQL 查询一下就可以看到数据了。

```
SELECT * FROM code;
```

![node-mysql](http://acwongblog.qiniudn.com/2015-03_node-mysql.PNG)


## 题目0003

> 第 0003 题：将 0001 题生成的 200 个激活码（或者优惠券）保存到 Redis 非关系型数据库中。

### node_redis

使用 Node.js 操作 Redis，这里使用 [node_redis](https://github.com/mranney/node_redis) 库。

```
npm install redis
```

直接上代码：

```javascript
// code_insert_redis.js
var redis = require('redis');
var code = require('./code.js');

var client = redis.createClient();
var codes = code.getCode(200);

// 用 LIST 形式存储，KEY 为 codes
client.rpush('codes', codes, function(err, res){
    if (err) {
        console.log(err);
        return;
    }
    console.log(res); // 输出 1
    client.quit();
});
```

运行：

```
node code_insert_redis
```

查看结果

```
lrange codes 0 -1
```

![node-redis](http://acwongblog.qiniudn.com/2015-03_node-redis.PNG)

感谢您的阅读，有不足之处请为我指出。
