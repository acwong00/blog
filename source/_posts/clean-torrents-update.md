---
title: 清洗种子脚本更新
date: 2015-05-20 16:27:19
tags: [Node.js,bt种子]
categories: 技术实践
description: 清洗种子脚本更新。
---

[之前的文章](http://blog.acwong.org/2015/03/25/clean-your-torrent-with-node/)当中探讨了使用 Node.js 和 parse-torrent 库来清洗 BT 种子文件。发布了源码之后有些朋友给了我一些反馈意见，有些种子在清洗之后会导致种子失效。

<!-- more -->

## 种子失效的问题

在研究一番之后发现原来的脚本有两个问题。

首先，没有分清楚单文件种子和多文件种子的区别。先看看种子文件的典型结构。

![](http://acwongblog.qiniudn.com/2015-03_torrent-structure.PNG)

对于单文件种子，文件名的信息会直接存在 info 的 name 字段当中，而没有 files 字段。而多文件种子则会把所有文件名的信息存在 files 的 path当中。

第二个问题，对于某些种子文件使用 parse-torrent 库解析之后会出现不同的解析结构，而且仅仅使用当中 info 对象来生成新的清洗后的种子也会导致未知的错误。

## nt 库

为了解决这两个问题，新的脚本采用了一个新的 BT 种子解析库—— [node-torrent](https://github.com/fent/node-torrent)。

使用这个库的好处在于，它在解析各个种子文件时候返回的对象结构比较统一，使用一个 metadata 的对象处理整个种子文件。而且 node-torrent 集成了生产种子文件的 API，不需要再像之前使用 node 的文件系统去生成新的种子文件。

## 新的特性

- 支持批量清洗整个文件夹的种子。
- 支持批量转换整个文件夹的种子为磁力链接。
- 添加了对 comment 和 publisher 的清洗。

[新版本传送门](https://github.com/acwong00/Clean-Torrents)。大家继续支持哦！

感谢你的阅读，有不足之处请为我指出。

