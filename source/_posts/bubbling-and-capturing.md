---
title: 浅谈事件冒泡与事件捕获
date: 2014-10-28 21:38:24
tags: [JavaScript,事件]
categories: 技术研究
description: 浅谈事件冒泡与事件捕获的概念和区别，介绍事件冒泡机制在事件代理中的使用。
---

## 事件冒泡与事件捕获

事件冒泡和事件捕获分别由微软和网景公司提出，这两个概念都是为了解决页面中**事件流**（事件发生顺序）的问题。


{% code HTML lang:html %}
    <div id="outer">
        <p id="inner">Click me!</p>
    </div>
{% endcode %}

上面的代码当中一个div元素当中有一个p子元素，如果两个元素都有一个click的处理函数，那么我们怎么才能知道哪一个函数会首先被触发呢？

为了解决这个问题微软和网景提出了两种几乎完全相反的概念。

<!-- more -->

### 事件冒泡

微软提出了名为**事件冒泡**(event bubbling)的事件流。事件冒泡可以形象地比喻为把一颗石头投入水中，泡泡会一直从水底冒出水面。也就是说，事件会从最内层的元素开始发生，一直向上传播，直到document对象。

因此上面的例子在事件冒泡的概念下发生click事件的顺序应该是***p -> div -> body -> html -> document***

### 事件捕获

网景提出另一种事件流名为**事件捕获**(event capturing)。与事件冒泡相反，事件会从最外层开始发生，直到最具体的元素。

上面的例子在事件捕获的概念下发生click事件的顺序应该是***document -> html -> body -> div -> p***

## addEventListener的第三个参数

“DOM2级事件”中规定的事件流同时支持了事件捕获阶段和事件冒泡阶段，而作为开发者，我们可以选择事件处理函数在哪一个阶段被调用。

addEventListener方法用来为一个特定的元素绑定一个事件处理函数，是JavaScript中的常用方法。addEventListener有三个参数：

> element.addEventListener(event, function, useCapture)

第一个参数是需要绑定的事件，第二个参数是触发事件后要执行的函数。而第三个参数默认值是false，表示在事件冒泡的阶段调用事件处理函数，如果参数为true，则表示在事件捕获阶段调用处理函数。请看[例子](http://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_element_addeventlistener_capture)。

## 事件代理

在实际的开发当中，利用事件流的特性，我们可以使用一种叫做事件代理的方法。

{% code HTML lang:html %}
    <ul id="color-list">
        <li>red</li>
        <li>yellow</li>
        <li>blue</li>
        <li>green</li>
        <li>black</li>
        <li>white</li>
    </ul>
{% endcode %}

如果点击页面中的li元素，然后输出li当中的颜色，我们通常会这样写:

{% code JavaScript lang:javascript %}
    (function(){
        var color_list = document.getElementById('color-list');
        var colors = color_list.getElementsByTagName('li');
        for(var i=0;i<colors.length;i++){
            colors[i].addEventListener('click',showColor,false);
        };
        function showColor(e){
            var x = e.target;
            alert("The color is " + x.innerHTML);
        };
    })();
{% endcode %}

利用事件流的特性，我们只绑定一个事件处理函数也可以完成：

{% code JavaScript lang:javascript %}
    (function(){
        var color_list = document.getElementById('color-list');
        color_list.addEventListener('click',showColor,false);
        function showColor(e){
            var x = e.target;
            if(x.nodeName.toLowerCase() === 'li'){
                alert('The color is ' + x.innerHTML);
            }
        }
    })();
{% endcode %}

使用事件代理的好处不仅在于将多个事件处理函数减为一个，而且对于不同的元素可以有不同的处理方法。假如上述列表元素当中添加了其他的元素（如：a、span等），我们不必再一次循环给每一个元素绑定事件，直接修改事件代理的事件处理函数即可。

### 冒泡还是捕获？

对于事件代理来说，在事件捕获或者事件冒泡阶段处理并没有明显的优劣之分，但是由于事件冒泡的事件流模型被所有主流的浏览器兼容，从兼容性角度来说还是建议大家使用事件冒泡模型。

### IE浏览器兼容

IE浏览器对addEventListener兼容性并不算太好，只有IE9以上可以使用。

[![addEventListener](http://acwongblog.qiniudn.com/acwongblogaddEventListener.PNG)](http://acwongblog.qiniudn.com/acwongblogaddEventListener.PNG)

要兼容旧版本的IE浏览器，可以使用IE的attachEvent函数

> object.attachEvent(event, function)

两个参数与addEventListener相似，分别是事件和处理函数，默认是事件冒泡阶段调用处理函数，要注意的是，写事件名时候要加上"on"前缀（"onload"、"onclick"等）。

感谢您的阅读，有不足之处请在评论为我指出。

**参考**

1. [HTML DOM addEventListener() Method -- w3schools](http://www.w3schools.com/jsref/met_element_addeventlistener.asp)
2. [JavaScript高级程序设计(第3版)](http://book.douban.com/subject/10546125/)
3. [attachEvent method -- MSDN](http://msdn.microsoft.com/en-us/library/ie/ms536343.aspx)
4. [What is event bubbling and capturing -- Stack Overflow](https://stackoverflow.com/questions/4616694/what-is-event-bubbling-and-capturing?nsukey=zA51Jl1Abrk%2FRkPZVPbCjx4J80CbKY93tVZAAejv4ySodF5MTEOdxPCiy4RFfLE5hPcgmYVt2Y4ma7A5hHfbXg%3D%3D)


