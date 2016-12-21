---
title: JavaScript 设计模式笔记（八）—— 模板方法模式
date: 2016-12-13 13:58:44
tags: [JavaScript,设计模式,TypeScript]
categories: 学习笔记
description: JavaScript 设计模式笔记 —— 模板方法模式
---

## 定义

模板方法模式的定义为：

> 模板方法（TemplateMethod）定义了一个操作中的算法的骨架，而将一些步骤延迟到子类中。模板方法使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。

模板方法模式由两部分组成，第一部分是抽象父类，第二部分是具体实现的子类。抽象父类封装了子类的算法框架，同时实现了一些公共方法及算法的执行顺序。而子类则继承父类，对部分父类方法进行重写。

<!-- more -->

## Coffee or Tea

讲解模板方法模式的经典例子 —— Coffee or Tea，首先分别定义冲咖啡和冲茶的方法：

```javascript
var Coffee = function() {};

Coffee.prototype.boilWater = function() {
  console.log('把水煮沸');
};

Coffee.prototype.brewCoffeeGriends = function() {
  console.log('用沸水冲炮咖啡');
};

Coffee.prototype.pourInCup = function() {
  console.log('把咖啡倒进杯子');
};

Coffee.prototype.addSugarAndMilk = function() {
  console.log('加糖和牛奶');
};

Coffee.prototype.init = function() {
  this.boilWater();
  this.brewCoffeeGriends();
  this.pourInCup();
  this.addSugarAndMilk();
};

var coffee = new Coffee();
coffee.init();
```

```javascript
var Tea = function() {};

Tea.prototype.boilWater = function() {
  console.log('把水煮沸');
};

Tea.prototype.steepTeaBag = function() {
  console.log('用沸水浸泡茶叶');
};

Tea.prototype.pourInCup = function() {
  console.log('把茶水倒进杯子');
};

Tea.prototype.addLemon = function() {
  console.log('加柠檬');
};

Tea.prototype.init = function() {
  this.boilWater();
  this.steepTeaBag();
  this.pourInCup();
  this.addLemon();
};

var tea = new Tea();
tea.init();
```

观察上述两个方法，可以发现冲茶和冲咖啡的步骤其实大同小异，可以总结为下面几个步骤：

1. 把水煮沸
2. 用沸水泡原材料
3. 把饮料倒进杯子
4. 加调料

因此可以将两个方法抽象为一个冲饮料的类：

```javascript
var Beverage = function() {};

Beverage.prototype.boilWater = function() {
  console.log('把水煮沸');
};

// 空方法，应由子类重写
Beverage.prototype.brew = function() {};
// 空方法，应由子类重写
Beverage.prototype.pourInCup = function() {};
// 空方法，应由子类重写
Beverage.prototype.addCondiments = function() {};

Beverage.prototype.init = function() {
  this.boilWater();
  this.brew();
  this.pourInCup();
  this.addCondiments();
};
```

`Coffee` 类和 `Tea` 类继承 `Beverage` 类重写父类的空方法：

```javascript
var Coffee = function() {};

Coffee.prototype = new Beverage();

Coffee.prototype.brew = function() {
  console.log('用沸水冲泡咖啡');
};

Coffee.prototype.pourInCup = function() {
  console.log('把咖啡倒进杯子');
};

Coffee.prototype.addCondiments = function() {
  console.log('加糖和牛奶');
};

var coffee = new Coffee();
coffee.init();
```

```javascript
var Tea = function() {};

Tea.prototype = new Beverage();

Tea.prototype.brew = function() {
  console.log('用沸水浸泡茶叶');
};

Tea.prototype.pourInCup = function() {
  console.log('把茶水倒进杯子');
};

Tea.prototype.addCondiments = function() {
  console.log('加柠檬');
};

var tea = new Tea();
tea.init();
```

## 抽象类

上述代码中的 `Beverage` 是一个抽象类，与普通的类不同，抽象类是不能被实例化的，抽象类一定需要被继承重写。

### 抽象方法和具体方法

在抽象类里面没有被具体实现的方法称为抽象方法（如 `Beverage` 中的 `brew`、`pourInCup` 和 `addCondiments`），当子类继承抽象类的时候必须重写父类的抽象方法。

另外，子类里面实现一些共同的方法可以提取出来在抽象类里面实现，称为具体方法（如 `Beverage` 中的 `boilWater`）。

### 模板方法

模板方法模式里面所说的模板方法就是定义了算法步骤的方法（如 `Beverage` 中的 `init`）。子类只要继承了抽象类就可以使用模板方法作出正确的实现。

## JavaScipt 实现抽象类的缺点

由于 JavaScript 并没有提供抽象类的支持，同时也没有类型检查的机制，所以没有办法保证子类完成重写了父类的抽象方法。

### 解决方案

#### 模拟接口检查

利用 JavaScript 来模拟静态语言的接口，进行接口检查，这样可以确保子类重写了父类的抽象方法，但是这样会增加程序的复杂性，同时添加了一些与业务无关的代码。

#### 在抽象类抛出错误

可以在抽象类的抽象方法里面抛出错误，这样如果子类没有实现某个方法就可以在程序运行的时候得到一个错误。缺点在于在程序运行得知错误。

```javascript
Beverage.prototype.brew = function() {
  throw new Error('子类必须重写 brew 方法');
};
```

#### 使用类库

可以使用一些有类型检查的类库来实现代码，下面用 TypeScript 来实现上述代码：

```typescript
abstract class Beverage {
  constructor() {}

  boilWater() : void {
    console.log('把水煮沸');  
  }

  abstract brew() : void;

  abstract pourInCup() : void;

  abstract addCondiments() : void;

  init() : void {
    this.boilWater();
    this.brew();
    this.pourInCup();
    this.addCondiments();
  }
}

class Tea extends Beverage {
  constructor() {
    super()
  }

  brew() : void {
    console.log('用沸水浸泡茶叶');
  }

  pourInCup() : void {
    console.log('把茶倒进杯子');
  }

  addCondiments() : void {
    console.log('加柠檬');
  }
}

let tea : Tea;
tea = new Tea();

tea.init();
```

如果实例化抽象类，编译时会抛出错误：

```typescript
tea = new Beverage();
// Cannot create an instance of the abstract class 'Beverage'.
```

同样如果子类没有实现某个抽象方法也会抛出错误 

`Non-abstract class 'Tea' does not implement inherited abstract member 'addCondiments' from class 'Beverage'.`

## 钩子方法

父类方法定义的算法框架一般情况下可以适应大部分的子类，但对于部分特殊的子类就需要使用到钩子方法。

如果有一些顾客不喜欢在咖啡里面加牛奶和糖，就需要用钩子方法重写：

```javascript
Beverage.prototype.customerWantsCondiments = function() {
  return true; // 默认加调料
};

Beverage.prototype.init = function() {
  this.boilWater();
  this.brew();
  this.pourInCup();
  if (this.customerWantsCondiments()) {
    this.addCondiments();
  }
};
```

```javascript
Coffee.prototype.customerWantsCondiments = function() {
  return window.confirm('请问需要加牛奶和糖吗？');
};
```

## 总结

模板方法模式可以很方便提高系统扩展性，实现一个算法不变的部分将可变的部分交给子类实现，同时使用钩子可以很容易进行扩展。

**参考**

[JavaScript设计模式与开发实践](https://book.douban.com/subject/26382780/)