---
title: JavaScript 设计模式笔记（六）—— 命令模式
date: 2016-11-30 16:56:56
tags: [JavaScript,设计模式]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 命令模式
---

## 定义

在软件设计中，需要向某些对象发送请求，但是不知道请求的接受者是谁，也不知请求的操作是什么，命令模式（Command）将请求封装成一个对象，在运行时再指定具体的接收者，请求者只需要如何发送请求，并不需要知道如何完成请求。

命令模式可以使请求者和接收者完全解耦。

<!-- more -->

## 传统面向对象编程的例子

要使用电视遥控来控制电视的开关，电视机是命令的接收者，遥控是命令的请求者，但是制作遥控器和编写电视开关操作的人员是相互独立的，所以遥控器只需要留下相应的接口。

```html
<button id="button1">open</button>
<button id="button2">close</button>
```

```javascript
var button1 = document.getElementById('button1');
var button2 = document.getElementById('button2');

// 留下设置命令的方法
var setCommand = function(button, command) {
  button.onclick = function() {
    command.execute();
  };
};
```

然后实现按钮操作的人员编写相应的命令。

```javascript
// 点击按钮要实现的函数
var TV = {
  open: function() {
    console.log('open');
  },
  close: function() {
    console.log('close');
  }
};

// 封装命令类
var OpenTVCommand = function(receiver) {
  this.receiver = receiver;
};

OpenTVCommand.prototype.execute = function() {
  this.receiver.open();
};

var CloseTVCommnd = function(receiver) {
  this.receiver = receiver;
};

CloseTVCommand.prototype.execute = function() {
  this.reveiver.close();
};

// 生成命令
var openTVCommand = new OpenTVCommand(TV);
var closeTVCommand = new CloseTVComman(TV);

setCommand(button1, openTVCommand);
setCommand(button2, closeTVCommand);
```

## 使用闭包实现的例子

由于 JavaScript 并不是严格的面向对象语言，因此上述的例子可以用闭包来实现。

```javascript
var OpenTVCommand = function(receiver) {
  return {
    execute: function() {
      reveiver.open()
    }
  };
}
```

## 撤销和重做

命令模式不仅可以实现执行命令，还可以很方便实现撤销和重做的操作。

现在要做一个简单的下围棋程序，有下棋、悔棋、重播三个操作。

```html
<div>
  输入棋盘座标：<input id="play">
</div>
<div>
  <button id="undo">悔棋</button>
  <button id="replay">重播</button>
</div>
```

```javascript
var playInput = document.getElementById('play');
var undoBtn = document.getElementById('undo');
var replayBtn = document.getElementById('replay');

var Cheek = {
  posStack: [], // 储存棋盘所以座标
  play: function(pos) {
    console.log('下(' + pos[0] + ', ' + pos[1] + ')');
    this.posStack.push(pos);
  },
  undo: function() {
    var pos = this.posStack.pop();
    console.log('悔(' + pos[0] + ', ' + pos[1] + ')');
  }
};

var commandStack = []; // 储存下棋命令

var PlayCommand = function(receiver, pos) {
  this.receiver = receiver;
  this.pos = pos;
};

PlayCommand.prototype.execute = function() {
  this.receiver.play(this.pos);
};

PlayCommand.prototype.undo = function() {
  this.receiver.undo();
};

playInput.onkeypress = function(e) {
  if (e.keyCode === 13) {
    command = new PlayCommand(Cheek, this.value.split(','));
    command.execute();
    commandStack.push(command);
    this.value = '';
  }
};

undoBtn.onclick = function() {
  command = commandStack.pop();
  if (command) {
    command.undo();
  }
};

replayBtn.onclick = function () {
  commandStack.forEach(function(command) {
    command.execute();
  });
};

```

## 宏命令

有玩过魔兽世界的朋友都知道魔兽世界里面有一个叫宏的功能，可以将多个技能或者动作绑定到一个键去施放（例如圣骑士的无敌加炉石）。在命令模式当中同样可以使用宏命令。

```javascript
var openPCCommand = {
  execute: function() {
    console.log('开机');
  }
};

var openQQCommand = {
  execute: function() {
    console.log('打开QQ');
  }
};

var openMusicCommand = {
  execute: function() {
    console.log('打开音乐');
  }
};

var MarcoCommand = function() {
  return {
    commandList: [],
    add: function(command) {
      this.commandList.push(command);
    },
    execute: function() {
      for(var i = 0, command; command = this.commandList[i++];) {
        command.execute()
      }
    }
  };
};

var marcoCommand = MarcoCommand();
marcoCommand.add(openPCCommand);
marcoCommand.add(openQQCommand);
marcoCommand.add(openMusicCommand);

marcoCommand.execute(); // 开机 打开QQ 打开音乐
```

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)