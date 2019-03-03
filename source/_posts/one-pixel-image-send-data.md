---
title: 204 请求图片快捷发送数据
date: 2019-02-28 20:00:28
tags: [前端,跨域]
categories: 学习笔记
---

在打开 Chrome 查看网络请求时，常常可以看到网站请求一张图片，返回的状态码是 204，这是网站用于发送一些页面数据的常用手段，现在就来探讨一下。

首先 204 状态码表示目前请求成功，但客户端不需要更新现有的页面。因此，这张图片的作用并不是用于展示到页面当中。

然后，我们可以看到请求这张图片的 url 后面必定会带有 query 的参数，其实，这张图片真正的用途就是向服务器传输它 url 后面带有的数据。

这其实是一种被称为**网络信标（Web beacon）**的技术，利用一张不可见的图像 get 请求将信息传送到服务器当中。

对于用户行为搜集、google analysis 之类的服务是是一种常用的手段，相比与 ajax 请求，它的资源开销会更少，而且可以突破 ajax 不能跨域的限制。对于向服务器传输数据但并不需要返回结果的应用场景当中是一种非常好的选择。

现在我们就来模拟一下这个过程。首先创建一个简单的 web 服务。

```javascript
const http = require('http')
const path = require('path')
const url = require('url')

const port = 2345

const requestHandler = (req, res) => {
  const { pathname, query } = url.parse(req.url)
  
  const filePath = `.${pathname}`

  const extname = path.extname(filePath)

  // 打印 query
  console.log(query)

  if (extname === '.gif') {
    const contentType = 'image/gif'
    // 返回 204 响应
    res.writeHead(204, { 'Content-Type': contentType })
    res.end('', 'utf-8')
  }
}

const server = http.createServer(requestHandler)

server.listen(port, err => {
  if (err) {
    return console.log(err)
  }

  console.log(`server is listening on ${port}`)
})
```

浏览器定时请求图片。

```javascript
setInterval(() => {
  const img = new Image()
  img.src = `http://localhost:2345/test.gif?num=${Math.random()}`
}, 3000)
```

这个时候可以看到 web 服务的日志每隔三秒就会收到一个名为 `num` 的参数，参数的值是一个随机的浮点数。