---
title: Node.js 清洗万恶的种子
date: 2015-03-25 13:48:45
tags: [bt种子,磁力链接,Node.js]
categories: 技术实践
description: 使用 Node.js 脚本清洗种子。
---

## 万恶的种子

torrent文件，又被称为种子，原来只是用于记录 bt下载当中所需信息的一种文件。但是随着互联网的极大发展，一些人士将一些邪恶的信息注入到了小小的 torrent文件当中，种子从此变成了邪恶的代名词。

2012 年，一部名为 ABS-130 的日本影片引起了网络的震动，网络上纷纷出现了 “当初求种像条狗，如今*完嫌人丑”的现象，成为了 2012 年互联网的一件大事件。

2014年，净网行动如火如荼地进行，各大互联网公司都作出了表率，一时之间XX云、X雷都把万恶的种子拒之门外。净网行动万岁！！（还我苍老师！！）

各大网盘、下载应用都从种子当中提取关键信息，将种子拒之门外。这些关键信息究竟藏在哪里？让我们一探究竟。

<!-- more -->

## 种子文件结构

以下内容来自维基百科

> .torrent种子文件本质上是文本文件，包含Tracker信息和文件信息两部分。Tracker信息主要是BT下载中需要用到的Tracker服务器的地址和针对Tracker服务器的设置，文件信息是根据对目标文件的计算生成的，计算结果根据BitTorrent协议内的Bencode规则进行编码。它的主要原理是需要把提供下载的文件虚拟分成大小相等的块，块大小必须为2k的整数次方（由于是虚拟分块，硬盘上并不产生各个块文件），并把每个块的索引信息和Hash验证码写入种子文件中；**所以，种子文件就是被下载文件的“索引”**。

![种子结构](http://acwongblog.qiniudn.com/2015-03_torrent-structure.PNG)

上图是一个典型种子的结构，那些被识别出来的**邪恶关键字**就藏在 name 和 file 当中。name 包含了该种子的名字，如：*abcd-123 性感XXXX*。而 file 当中的 path 则包含了要下载的所有文件的信息，如：*草X社区最新地址.txt*等等。

## Node.js 和 parse-torrent 库

为了寻找出种子当中的邪恶信息我们请出了 Node.js 和 parse-torrent库 作为助手。

实验准备：

- 种子一枚
- 安装 Node.js 电脑一台

首先我们利用 npm 安装 parse-torrent 库，它帮助我们快速找到种子内的信息。

```
npm install parse-torrent
```

```javascript
var fs = require("fs");
var parseTorrent = require('parse-torrent');

var info = parseTorrent(fs.readFileSync('my.torrent'));
console.log(info);
```

这个库会将种子的信息解析出来，以对象的形式返回给我们。

查看结果：

name:

![种子信息文件名](http://acwongblog.qiniudn.com/2015-03_torrent-info-name.PNG)

files:

![种子信息文件名](http://acwongblog.qiniudn.com/2015-03_torrent-info-files.PNG)

可以看到用 parse-torrent 库解析出来的 name 和 files 的信息都是以 Buffer 形式存储。

## 清洗种子

如何将种子里的邪恶信息清洗掉，把万恶的种子扼杀在摇篮之中，最重要的就算要清除调 name 和 files 里面 path 的信息。

```javascript
function cleanInfo (info) {
    // 将种子名用 md5 加密
    info.name = md5(info.name);
    info['name.utf-8'] = md5(info['name.utf-8']);
    var files = info.files;
    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        for (var key in file) {
            if (key == "path" || key == "path.utf-8") {
                for (var j = 0; j < file[key].length; j++) {
                    var text = file[key][j].toString();
                    var dotIndex = text.lastIndexOf(".");
                    // 将种子名用 md5 加密
                    file[key][j] = md5(text.slice(0,dotIndex)) + text.slice(dotIndex,text.length);
                }
            }
        }
    }
    return info;
}
```

```javascript
// 将清洗干净后的 info 对象重新生成一个 torrent 文件
var buf = parseTorrent.toTorrentFile({
    info: cleanInfos[i]
});
fs.writeFile(dir + "/" + cleanInfos[i].name + ".torrent", buf);
```

经过这样之后，我们的邪恶种子文件就变成这样了：

![清洗后种子信息](http://acwongblog.qiniudn.com/2015-03_clean-torren-info.PNG)

## 实战阶段

首先准备一个种子，进行XX云的离线下载。

![种子](http://acwongblog.qiniudn.com/2015-03_torrent.PNG)

一开始它是被拒绝的。

![拒绝](http://acwongblog.qiniudn.com/2015-03_36000.PNG)

然后运行脚本进行清洗。

```
node cleanTorrent IPTD-XXX.torrent
```

下载成功了！

![下载成功](http://acwongblog.qiniudn.com/2015-03_download-success.PNG)

脚本源码放在[这里](https://github.com/acwong00/Clean-Torrents)了，要去看一下我的下载内容了！！！

![温馨提示](http://acwongblog.qiniudn.com/2015-03_tips.PNG)

![oh no](http://acwongblog.qiniudn.com/2015-03_baoman.jpg)

（**都脱了你给我看这个！！！）

## 最后

本文纯属技术讨论，感谢你的阅读，有不足之处请为我指出。
