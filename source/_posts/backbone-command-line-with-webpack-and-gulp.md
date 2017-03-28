---
title: Webpack 和 Gulp 构建伪命令行项目
date: 2015-04-22 14:26:30
tags: [Backbone,webpack,gulp,前端模块化]
categories: 技术实践
description: 利用 Webpack 和 Gulp 构建 Backbone 伪命令行项目
---

[上一篇文章](http://blog.acwong.org/2015/04/13/backbone-command-line/)分享了我的一个 Backbone 小项目的实践过程。在项目上线之前先看看 *index.html*。

```html
<script src="./js/command-model.js"></script>
<script src="./js/command-collection.js"></script>
<script src="./js/command-view.js"></script>
<script src="./js/message-view.js"></script>
<script src="./js/app-view.js"></script>     
<script src="test.js"></script>
```

显然这样的写法是不符合 Web 性能优化原则的。我们应该把多个文件尽量构建成一个单独的文件，减少客户端请求资源的次数。

本文就通过 Webpack 和 Gulp 两个工具介绍将这个 Backbone 伪命令行项目模块化和构建上线的实践过程。

<!-- more -->

## Webpack

Webpack 是德国开发者 Tobias Koppers 开发的模块加载器，是前端模块化开发的有力竞争者。

Webpack 特点之一是把所有资源都当成模块，css，js，图片，模版文件等等。另外，Webpack 除了作为一个模版加载器之外还具有 Gulp 和 Grunt 一部分的构建功能。

## 伪命令行模块化

### 以 CommonJS 改写伪命令行项目

Webpack 支持 CommonJS 和 AMD 的语法，这里选用了 CommonJS 方式对原来的代码进行改写。

在原来的代码当中我们创建了一个名为 `app` 的全局变量，我们就通过这个全局的变量来引用项目各个部分的方法。

因此改写的方法也相当简单，就是把 `app` 变量去掉，然后把各个文件写成独立的模块。

例如:

```javascript
// command-model.js
var CommandModel = Backbone.Model.extend({
    default: {
        name: '',
        messages: []
    }
});

module.exports = CommandModel;
```

```javascript
// command-collection.js
var CommandModel = require("./command-model.js");

var CommandCollection = Backbone.Collection.extend({
    model: CommandModel
});

module.exports = CommandCollection;
```

### 将模版文件分离

改写完 js 模块之后，还有一些东西很应该被分类开来。 *command-view.js* 和 *message-view.js* 分别对应着两个模版。通常的做法会把 模版文件写在 *index.html* 当中，用 `<script>` 标签包裹起来。

```html
<script id="commandTemplate" type="text/template">
    <label><%- prompt %></label>
</script>
<script id="messageTemplate" type="text/template">
    <div <%= color ? ('style="color:' + color + '"') : '' %>>
        <%= link ? ('<a href="' + link + '">') : '' %>
            <%= message %>
        <%= link ? ('</a>') : '' %>
    </div>
</script>
```

把模版文件分离开来会使我们的维护更加方便。

首先，把这两个模版分离开来，写成两个 html 文件。

```html
<!-- commandTemplate.html -->
<label><%- prompt %></label>
```

```html
<!-- messageTemplate.html -->
<div <%= color ? ('style="color:' + color + '"') : '' %>>
    <%= link ? ('<a href="' + link + '">') : '' %>
        <%= message %>
    <%= link ? ('</a>') : '' %>
</div>
```

Webpack 把除了 js 之外的资源作为模块加载的时候，需要用到不同的加载
器，对于 html 文件这里使用 [html-loader](https://github.com/webpack/html-loader)。它会将 html 文件加载成 String 形式。

然后就可以在 js 文件当中引用模版了。

```javascript
// 要添加 html! 前缀才会用 html-loader 加载
var commandTemplate = require('html!../templates/commandTemplate.html');
```

### webpack.config.js

在运行 `webpack` 命令之前要先安装 Webpack。

```
npm install webpack -g
```

先全局安装以便可以使用 `webpack` 命令。

```
npm install webpack html-loader --save-dev
```

然后在项目中安装 Webpack 和 html-loader。

Webpack 运行根据一个名为 webpack.config.js 的文件配置。这里简单写一下。

```javascript
module.exports = {
    entry: './test.js',
    output: {
        filename: './dist/all.js'
    }
};
```

在命令行模式下运行 `webpack` 命令，打包就可以完成了。

### 压缩代码

在上线之前，我们还应该将代码进行压缩尽量把文件的体积减到最少。然而，我们可以看到 Webpack 打包后的 *all.js* 文件不仅没有压缩，而且代码当中的注释也没有去掉。

Webpack 同样提供了 UglifyJsPlugin 的插件来进行压缩代码操作。但是在我尝试的过程中，这个插件和 html-loader 配合使用的时候会出现错误，因此在这里我使用了 Gulp 来进行代码压缩的工作。

Webpack 与 Gulp 配合使用也相当简单，只需要安装 [gulp-webpack](https://github.com/shama/gulp-webpack)。

安装 Gulp 和其他所需的工具。

```
npm install gulp gulp-jshint gulp-rename gulp-uglify gulp-webpack --save-dev
```

写 *gulpfile.js*。

```javascript
var gulp = require('gulp'),
    jshint = require('gulp-jshint'),
    webpack = require('gulp-webpack'),
    uglify = require('gulp-uglify'),
    rename = require('gulp-rename');

gulp.task('lint', function  () {
    gulp.src('./js/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('default'));
});

gulp.task('webpack', function () {
    gulp.src('./test.js')
        .pipe(webpack())
        .pipe(gulp.dest('dist/'))
        .pipe(rename('all.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest('./dist'));
});

gulp.task('default', function(){
    gulp.run('lint', 'webpack');
});
```

运行 `gulp` 命令，构建完成。

## 最后

完整的 demo 可以看我的博客 [~~about 页面~~](http://blog.acwong.org/#)。

源代码请点[这里](https://github.com/acwong00/blog-demo-code/tree/master/backbone-command-line)。

感谢您的阅读，有不足之处请为我指出。






