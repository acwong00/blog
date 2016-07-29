---
title: 不在HTML5标准中的特性 —— 浅谈原生拖放
date: 2014-11-08 14:54:36
tags: [HTML5,事件,原生拖放,Drag and Drop]
categories: 技术研究
description: 简单介绍 HTML5 原生拖放特性以及该特性目前存在的一些缺陷。
---

## 久等的HTML5标准

2014年10月28日，W3C正式公布了耗时8年时间制订的 HTML5 标准。尽管标准在最近才正式公布，但 HTML5 激动人心的特性一早就被开发者热议了。在这份标准当中有一个我们熟悉的身影并没有出现，那就是原生拖放 —— Drag and Drop。

> 10月28日发布的[HTML5版本](http://www.w3.org/TR/html5/)当中没有原生拖放。

> 而制订当中的[HTML5.1版本](http://www.w3.org/html/wg/drafts/html/master/editing.html#dnd)当中则可以看到。

没有人知道HTML5标准为什么没有了原生拖放特性，我想可能与其设计上的缺陷有关，在谈这个问题之前，先简单介绍一下原生拖放的特性。

<!-- more -->

## Drag and Drop 简介

### 可拖动属性

图像、链接和文本是浏览器默认可以被拖动的，HTML5 为所有的HTML元素都提供了一个**draggable**属性，当这个属性的值为**true**的时候，元素被视为可以拖动。

```html
<!-- 禁止元素被拖动 -->
<a href="#" alt="不能拖动我" draggable="true">不能拖动我</a>

<!-- 让元素可以被拖动 -->
<div draggable="false">可以被拖动</div>
```

### 拖放事件

利用拖放事件，我们可以控制拖放过程中的各个阶段。

对于被拖放的元素包括下列事件：

- dragstart *鼠标点击被拖动元素开始拖动时在该元素触发*       
- drag *拖动元素时频繁在被拖动元素触发*
- dragend *拖动停止并放置之后触发*

对于目标放置元素包括下列事件

- dragenter *元素被拖动时鼠标进入目标放置元素时触发*
- dragover *元素被拖动时鼠标在目标放置元素时频繁触发*
- dragleave *元素被拖动时鼠标离开目标放置元素时触发*
- drop *元素被拖动到目标放置元素并放开鼠标进行放置时触发*

可以看出，拖放特性的核心就是拖动一个元素放置到一个目标元素当中。

### dataTransfer

我认为原生拖放当中最令人兴奋的特性就是可以利用拖放事件传递数据，这样使浏览器原生就可以支持类似于桌面应用的拖放交互功能。

要使用数据传输功能就需要一个名为 dataTransfer 的接口。

dataTransfer 主要包括 getData() 和 setData() 方法。 setData() 用于保存值，getData() 用于获得 setData() 保存的值。

> dataTransfer.setData(format, data)

> dataTransfer.getData(format)

format 参数支持MIME数据类型。

一个小例子 [传送门](http://jsfiddle.net/acwong/00p1mppp/2/embedded/result/)。

### dropEffect 和 effectAllowed

dataTransfer 接口还有两个有趣的属性。

**dropEffect** 浏览器会根据不同的值显示不同类型的光标，提升用户放置后的行为。 dropEffect 包括以下几个值:

- none *不能把拖动的元素放置在这里*
- move *把元素移动到这里*
- copy *把元素复制到这里*
- link *放置到这里后打开链接*

浏览器仅仅会帮你改变光标的类型，但是要实现怎样的效果都是要开发者自己去实现。

**effectAllowed** 搭配 dropEffect 使用，表示允许dropEffect的哪种行为，它的值有以下几种：

- none *被拖动元素不能有任何行为*
- copy *允许值为 "copy" 的放置行为*
- link *允许值为 "link" 的放置行为*
- move *允许值为 "move" 的放置行为*
- copyLink *允许值为 "copy" 和 "link" 的放置行为*
- copyMove *允许值为 "copy" 和 "move" 的放置行为*
- linkMove *允许值为 "link" 和 "move" 的放置行为*
- all *允许所有放置行为*

便于理解请看例子 [传送门](http://help.dottoro.com/external/examples/ljffjemc/dropEffect_1.htm)

## Drag and Drop 的坑

### Drag and Drop 的历史

与其他的 HTML5 特性不同，Drag and Drop 的[浏览器兼容性](http://fmbip.com/litmus#html5-web-applications)可以说鹤立鸡群。

[![addEventListener](http://acwongblog.qiniudn.com/dnd-compatibility.PNG)](http://acwongblog.qiniudn.com/dnd-compatibility.PNG)

拖放功能最早在IE4时候就被引入，而在目前的拖放模型则是基于IE5.5的模型建立的。由于这个原因导致了原生拖放当中出现了各种不同的坑。

### 我开发中遇到的问题

前阵子做了一个360度全景效果的demo，一开始想到用drag事件来做。

首先准备图片:

```html
<div id="container">
    <div id="panorama">
        <img src="images/0.jpg" alt="">
        <img src="images/1.jpg" alt="">
        <img src="images/2.jpg" alt="">
        .......
        <img src="images/74.jpg" alt="">
        <img src="images/75.jpg" alt="">
        <img src="images/76.jpg" alt="">
    </div>
</div>
```

然后利用 drag 事件频繁发生，在 drag 事件触发时，判断鼠标位移，然后显示下一张图片，利用人的视觉残留，做出360度全景图片的效果。(使用了 jQuery 库)

```javascript
var panorama = $('#panorama');
var images = panorama.find('img');
var len = images.length;
var start_X = 0;
var start_Y = 0;

panorama.on('dragstart', function(event) {
	start_X = event.originalEvent.x;
	start_Y = event.originalEvent.y;
});

panorama.on('drag', function(event) {
	var mouse_X = event.originalEvent.x;
	var mouse_Y = event.originalEvent.y;

	if (mouse_X - start_X > 0) {
		moveImg('right');
		start_X = mouse_X;
	} else if (start_X - mouse_X > 0) {
		moveImg('left');
		start_X = mouse_X;
	}		
});

function moveImg(dir) {
	var current_img = panorama.find('img:visible');
	var index = current_img.index();
	if (dir === 'right') {
		if (index + 1 === len) {
			images.eq(0).show().siblings().hide();
		} else {
			images.eq(index + 1).show().siblings().hide();
		}
	} else {
		if (index - 1 === 0) {
			images.eq(len - 1).show().siblings().hide();
		} else {
			images.eq(index - 1).show().siblings().hide();
		}
	}
}
```

**[demo](http://jsfiddle.net/acwong/xpk5932b/)**

完成demo之后发现，浏览器对图片有默认的拖动效果。

[![图片默认拖动效果](http://acwongblog.qiniudn.com/drag360.PNG)](http://acwongblog.qiniudn.com/drag360.PNG)

要去掉这个效果可以在 dragstart 或 mousedown 事件中调用 event.preventDefault() 方法。但是无论使用上述哪一种方法都会导致 drag 事件失效。找了很多资料也没有找到很好的解决方法。所以最后我还是老老实实地用了 mouse 事件的方法重写了一遍。

**[demo](http://jsfiddle.net/acwong/xpk5932b/1/)**

### 其他

除了图片默认拖动效果的小问题之外，在网络上也有许多使用 drag and drop 的吐槽，像[这一篇](https://ghsky.com/2012/09/talk-about-html5-drag-and-drop.html)说出了很多拖放特性相关事件在使用上的很多坑。

当然还有PPK对拖放特性的[吐槽](http://www.quirksmode.org/blog/archives/2009/09/the_html5_drag.html)。09年的时候PPK就说应该把拖放特性在 HTML5 里面删除。

> The module should be removed from the HTML5 specification straight away, and conforming browsers should disable it at their earliest opportunity pending a complete rewrite from the ground up.

## 最后

原生拖放的设计的确是极大地提高了浏览器与用户的交互性，但是基于 IE5.5 设计的 HTML5 原生拖放却并不是十分好用，使用过程中总会遇到一些麻烦，而且我认为 dropEffect 和 effectAllowed 略显鸡肋并且难以理解。我想这些都是 HTML5 暂时没有这个特性的原因。

希望后续的版本原生拖放成为一个让人眼前一亮的功能。

感谢您的阅读，有不足之处请在评论为我指出。

**参考**

1. [dropEffect property (dataTransfer)](http://help.dottoro.com/ljffjemc.php)
2. [JavaScript高级程序设计(第3版)](http://book.douban.com/subject/10546125/)
3. [浅谈 HTML5 的 Drag and Drop](https://ghsky.com/2012/09/talk-about-html5-drag-and-drop.html)
4. [The HTML5 drag and drop disaster](http://www.quirksmode.org/blog/archives/2009/09/the_html5_drag.html)
5. [Why is event.preventDefault() in dragstart interrupting furthur drag events from executing? -- stackoverflow](https://stackoverflow.com/questions/19036977/why-is-event-preventdefault-in-dragstart-interrupting-furthur-drag-events-from?nsukey=nAJoypRJ%2FY1BrOvXfa1fWU2dcz2tJ4S0mv0B4f5G0a%2B6zdcX0XO6q9QGbfadlJ1eeYaogaKSDjRa4xL4wzNLIQ%3D%3D)
