---
title: Backbone实践 —— 伪命令行制作
date: 2015-04-13 17:10:56
tags: [Backbone]
categories: 技术实践
description: 利用 Backbone 库在前端模仿命令行系统。
---

最近学习了一下 Backbone 这个库，对于想学习制作单页应用的朋友来说，Backbone 确实是一个不错的选择。为了让自己更加熟悉 Backbone，最近用它制作了一个伪命令行应用来装修了本人博客的 [about 页面](http://blog.acwong.org/#)。

<!-- more -->

## 构思

说是“伪”命令行，当然没有真命令行那么多复杂的功能(⊙ˍ⊙)，它主要的功能就是，当输入一个命令的时候在伪命令行界面打印出相应的信息。

## 准备

### 文件结构


![文件结构](http://acwongblog.qiniudn.com/2015-04_commandline-files-structure.PNG)

文件结构非常简单，*index.html* 是应用的页面，*main.css* 样式文件，*test.js* 是测试的数据，js文件夹中存放了应用的 JavaScript 代码。

### index.html 和 main.css

```html
<div id="container">
    <div id="terminal">
        <div id="terminalPrint"></div>
        <div id="command">
            <input type="text" id="commandInput" />
        </div>
    </div>
</div>
```

*index.html* 结构也非常简单，*terminal* 下包含两个 `div`, *terminalPrint* 用于显示打印的信息，*command* 用于输入命令。

*main.css* 文件就不多说了，就是把页面做到很像命令行的样子。

![命令行的样子](http://acwongblog.qiniudn.com/2015-04_command-line-view.PNG)

## JavaScript 部分

首先在 *index.html* 文件当中引入 Backbone 和它依赖的库，除了 Backbone 强依赖的 underscore.js 之外这里还引入了 jQuery。

```html
<!-- </body> 前引入 -->
<!-- 这里使用了百度静态资源公共库 -->
<script src="http://apps.bdimg.com/libs/jquery/1.9.1/jquery.js"></script>
<script src="http://apps.bdimg.com/libs/underscore.js/1.7.0/underscore-min.js"></script>
<script src="http://apps.bdimg.com/libs/backbone.js/1.1.2/backbone-min.js"></script>
```

### Model & Collection

这里定义了一个 Model 用来表示命令的属性。包含两部分，`name` 代表命令的名称。`messages` 表示该命令要打印的信息，这里我用了数组来表示信息，每一项代表一行的信息。

```javascript
// command-model.js

var app = app || {}; // 全局变量

app.CommandModel = Backbone.Model.extend({
    default: {
        name: '',
        messages: []
    }
});
```

建立一个 Collection 用于保存命令的集合。

```javascript
// command-collection.js

var app = app || {};

app.CommandCollection = Backbone.Collection.extend({
    model: app.CommandModel
});
```

### View

View 我认为是 Backbone 较为重要的一个部分，我理解 View 的工作是根据应用发生的事件去重新渲染页面。在这里我为应用定义了3个 View，分别是对于整个应用的 `AppView`，用于显示命令输入行的 `CommandView` 和为了让打印信息具有更强大功能的 `MessageView`。

#### MessageView

首先介绍 MessageView，上文提到过 `CommandModel` 是用来定义命令和命令打印的信息，其中打印的信息是一个数组。我的设想是数组当中每一项包含一个对象，分别含有3个属性：

- `messages` 保存打印到命令行的信息
- `color`    打印信息的颜色
- `link`     打印信息的链接

因此，在 `MessageView` 初始化的函数当中就为它定义了一个默认的对象。

```javascript
// message-view.js

app.MessageView = Backbone.View.extend({
    // 省略其他代码

    initialize: function (model) {
        var defaults = {
            messages: "",
            color: "rgb(57, 219, 31)",
            link: ""
        };

        this.model = $.extend(defaults, model);
    },

    render: function () {
        this.$el.html(this.template(this.model));
        return this;
    }
});
```

当创建 `MessageView` 的时候需要为它传入对象(就是存储在 `CommandModel` `messages` 数组当中的每一项)。

`MessageView` 对应的模版如下：

```
<script id="messageTemplate" type="text/template">
    <div <%= color ? ('style="color:' + color + '"') : '' %>>
        <%= link ? ('<a href="' + link + '">') : '' %>
            <%= message %>
        <%= link ? ('</a>') : '' %>
    </div>
</script>
```

根据 `color` 为信息添加相应的颜色样式，根据 `link` 的值为打印内容添加链接。

#### CommandView

`CommandView` 比较简单，只是用来显示输入命令的那一行，主要任务就算显示提示信息也就是 prompt。

```javascript
//command-view.js

app.CommandView = Backbone.View.extend({
    // 省略其他代码

    initialize: function (prompt) {
        this.prompt = prompt;
        this.render();
    },

    render: function () {
        this.$el.html(this.template({prompt: this.prompt}));
        return this;
    }
});
```

`CommandView` 对应的模版如下：

```
<script id="commandTemplate" type="text/template">
    <label><%- prompt %></label>
</script>
```

**一个小点**

可以看到上面两个 View 的 `render` 函数都返回了 `this`，这是一种推荐的做法，可以方便链式调用。

#### AppView

`AppView` 比较复杂，主要工作是完成整个应用的初始化和监听各种事件发生。

首先是应用的初始化。

```javascript
// app-view.js

app.AppView = Backbone.View.extend({
    initialize: function(commands, prompt, greeting) {
		
        // 获得 DOM 对象
        this.$printEl = this.$('#terminalPrint');
        this.$input = this.$('#commandInput');
        this.$command = this.$('#command');
		
        // 初始化命令输入行
        this.commandView = new app.CommandView(prompt);
        this.$command.prepend(this.commandView.render().el);
		
        // 打印欢迎信息
        this.messages = greeting;
        this.renderMessage();
		
        // 保存命令的集合
        this.collection = new app.CommandCollection(commands);
    }

	// 省略其他代码
});
```

由于这里的应用没有后台系统，所以所有的数据都是通过参赛在创建应用的时候传进去。`commands` 保存着命令的集合、`prompt` 提示信息、`greeting` 欢迎信息。

打印到命令行的信息这里一律用 `renderMessage` 函数来处理。

```javascript
renderMessage: function(value) {
    for (var i = 0; i < this.messages.length; i++) {
        this.messageView = new app.MessageView(this.messages[i]);
        this.$printEl.append(this.messageView.render().el);
    }
}
```

传入一个数组为需要打印的信息，然后为每一条信息创建一个 `MessageView` 来显示。

然后定义应用发生的事件。

```javascript
events: {
    'click': 'inputFocus',
    'keypress #commandInput': 'runCommand'
}
```

其中 `inputFocus` 是用于点击应用的时候将焦点聚集在命令输入框，不作详细介绍，这里主要介绍一下输入命令时发生的 `runCommand`。

```javascript
runCommand: function(e) {
    // 输出信息超过30行自动删除
    if (this.$printEl.children('div').length > 30) {
        var len = this.$printEl.children('div').length - 30;
        for (var i = 0; i < len; i++) {
            this.$printEl.children('div').eq(i).remove();
        }
    }

    if (e.which === 13) {
		// 打印输入的命令
        var value = this.$input.val().trim();
        this.$printEl.append("<div>" + this.commandView.prompt + " " + value + "</div>");
        this.$input.val('');

        if (value === '') {
            return;
        }

        if (this.collection.findWhere({command: value})) {
            // 获得相应命令对应的信息
            this.model = this.collection.findWhere({
                command: value
            });
            this.messages = this.model.get("messages");
        } else {
            this.messages = this.errorMessage;
        }
        this.renderMessage();
    }
}
```

该函数传入事件对象，当用户点击回车的时候，首先在命令行界面打印用户输入的命令，然后如果找到该命令就打印相应的 `messages` 信息，否则打印错误信息。

## 运行应用

将 `AppView` 的参数定义好并且传入就可以启动应用了。

```javascript
$(function(){
    var commands = [{
        command: "Hello",
        messages: [{
            message: "Good morning!",
            color: "yellow"
        }]
    }],
        prompt = "js >",
        greeting = [{
            message: "Wellcome!"
        }];

    new app.AppView(commands, prompt, greeting);
});
```

![demo截图](http://acwongblog.qiniudn.com/2015-04_command-line-demo-view.PNG)

## 最后

完整的 demo 可以看我的博客 [~~about 页面~~](http://blog.acwong.org/about/)。

源代码请点[这里](https://github.com/acwong00/blog-demo-code/tree/master/backbone-command-line/old_demo)。

我只是一个 Backbone 初学者，有些实现方法可能不够合理，希望看到这篇文章的您多多与我交流。

[下一篇文章](http://blog.acwong.org/2015/04/22/backbone-command-line-with-webpack-and-gulp/)会说一下如何构建这个小项目。

感谢您的阅读，有不足之处请为我指出。
