---
title: AngularJS
layout: post
tags: 
  - angularjs
categories: angularjs
description: 
cover: /assets/images/bg/13.jpeg
top_img: 
---

## Angularjs是什么

AngularJS是一个功能强大的基于JavaScript开发框架用于创建富互联网应用(RIA)。

## Angularjs的核心特性

- **数据绑定**： 模型和视图组件之间的数据自动同步。
- **适用范围**： 这些对象参考模型。它们充当控制器和视图之间的胶水。
- **控制器**： 　这些Javascript函数绑定到特定的范围。
- **服务**： 　　AngularJS配有多个内置服务，例如 $http 可作为一个XMLHttpRequest请求。这些单一对象在应用程序只实例化一次。
- **过滤器**： 　从一个数组的条目中选择一个子集，并返回一个新的数组。
- **指令**： 　　指令是关于DOM元素标记(如元素，属性，CSS等等)。这些可以被用来创建作为新的，自定义部件的自定义HTML标签。AngularJS设有内置指令(如：ngBind，ngModel...)
- **模板**：　　 这些符合从控制器和模型信息的呈现的视图。这些可以是单个文件(如index.html)，或使用“谐音”在一个页面多个视图。
- **路由**： 　　它是切换视图的概念。
- **模型视图**： MVC是一个设计模式将应用划分为不同的部分(称为模型，视图和控制器)，每个都有不同的职责。 AngularJS并没有传统意义上的实现MVC，而是更接近于MVVM(模型 - 视图 - 视图模型)。 AngularJS团队将它作为模型视图。
- **深层链接**： 深层链接，可以使应用程序状态进行编码在URL中而能够添加到书签。应用程序可从URL恢复到相同的状态。 依赖注入: AngularJS有一个内置的依赖注入子系统，开发人员通过使应用程序从而更易于开发，理解和测试。


## AngularJS的优点

- AngularJS提供一个非常干净和维护的方式来创造单页的应用。
- AngularJS提供数据绑定功能在HTML中，从而给用户提供丰富和响应的体验
- AngularJS代码可进行单元测试。
- AngularJS使用依赖注入和利用关注点分离。
- AngularJS提供了可重用的组件。
- 使用AngularJS，开发人员编写更少的代码，并获得更多的功能。
- 在AngularJS中，视图都是纯HTML页面，并用JavaScript编写控制器做业务处理。

AngularJS应用程序可以在所有主要的浏览器和智能手机，包括Android和iOS系统的手机/平板电脑上运行。

## AngularJS的缺点

- 不安全：因为只是JavaScript一种框架，由AngularJS编写的应用程序是不安全的。服务器端身份验证和授权是必须用来保证应用程序的安全。
- 不可降解：如果应用程序的用户禁用JavaScript，那最后用户看到的只是基本页面，仅此而已。

示例

```html
<!doctype html>
<html>
   <head>
      <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.0-beta.17/angular.min.js"></script>
   <title>第一个AngularJS程序</title>
   </head>
   <body ng-app="myapp">
      <div ng-controller="HelloController" >
         <h2>你好 ！第一个{{helloTo.title}}程序示例</h2>
      </div>
      <script>
         angular.module("myapp", [])
         .controller("HelloController", function($scope) {
            $scope.helloTo = {};
            $scope.helloTo.title = "AngularJS";
         });
      </script>
   </body>
</html>
```

### 包括AngularJS

我们已经包括了AngularJS的JavaScript文件到HTML页面中，所以我们可以用AngularJS：

```html
<head>
  <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
</head>
```

### 指向AngularJS应用程序

接下来我们需要指示HTML的哪一部分包含了AngularJS应用程序。这可以通过ng-app属性到AngularJS应用程序的根HTML元素。可以把它添加到HTML元素或body元素，如下所示：

```html
<body ng-app="myapp"></body>
```

### 视图

ng-controller 告诉AngularJS什么控制器使用在视图中。helloTo.title告诉AngularJS将命名helloTo.title的值写入到HTML的“model”中。

```html
<div ng-controller="HelloController" >
  <h2>Welcome {{helloTo.title}} to the world of Yiibai tutorials!</h2>
</div>
```


### 控制器

此代码注册一个名为HelloController的控制器功能，在myapp模块。 我们将学习更多关于它们在各自的模块和控制器章节。控制器函数注册在Angular中，通过angular.module(...).controller(...) 的函数来调用。 传递给控制器函数的$scope参数是模型。控制器函数增加了helloTo的 JavaScript对象，并在该对象它增加了一个标题字段。

```html
<script>
   angular.module("myapp", [])
   .controller("HelloController", function($scope) {
      $scope.helloTo = {};
      $scope.helloTo.title = "AngularJS";
    });
</script>
```


## AngularJS 控制器

略

## AngularJS 过滤器

内置过滤器:
uppercase：转换文本为大写文字。
lowercase：转换文本为小写文字。
currency：以货币格式格式化文本。
filter：过滤数组到根据提供标准的一个子集。
orderby：排序基于提供标准的数组。

```html
// 大写过滤器
Enter first name:<input type="text" ng-model="student.firstName">
Enter last name: <input type="text" ng-model="student.lastName">
Name in Upper Case: {{student.fullName() | uppercase}}

// 小写过滤器
Enter first name:<input type="text" ng-model="student.firstName">
Enter last name: <input type="text" ng-model="student.lastName">
Name in Upper Case: {{student.fullName() | lowercase}}

// 货币过滤器
Enter fees: <input type="text" ng-model="student.fees">
fees: {{student.fees | currency}}

// 过滤过滤器
Enter subject: <input type="text" ng-model="subjectName">
Subject:
<ul>
  <li ng-repeat="subject in student.subjects | filter: subjectName">
    {{ subject.name + ', marks:' + subject.marks }}
  </li>
</ul>

// 排序过滤器
Subject:
<ul>
  <li ng-repeat="subject in student.subjects | orderBy:'marks'">
    {{ subject.name + ', marks:' + subject.marks }}
  </li>
</ul>
```


## AngularJS HTML DOM

1. ng-disabled： 禁用给定的控制
2. ng-show： 显示了一个给定的控制
3. ng-hide： 隐藏一个给定的控制
4. ng-click： 表示一个AngularJS click事件

```html
// ng-disabled
<input type="checkbox" ng-model="enableDisableButton">Disable Button
<button ng-disabled="enableDisableButton">Click Me!</button>

// ng-show
<input type="checkbox" ng-model="showHide1">Show Button
<button ng-show="showHide1">Click Me!</button>

// ng-hide 指令
<input type="checkbox" ng-model="showHide2">Hide Button
<button ng-hide="showHide2">Click Me!</button>

// ng-click 指令
<p>Total click: {{ clickCounter }}</p></td>
<button ng-click="clickCounter = clickCounter + 1">Click Me!</button>
```


## AngularJS 模块

AngularJS支持模块化方法。模块用于单独的逻辑表示服务，控制器，应用程序等。为保持代码简洁，我们在单独的 js 文件中定义模块，并将其命名为 module.js文件。 在这个例子中，我们要创建两个模块。

- 应用模块 - 控制器用于初始化应用程序。
- 控制器模块 - 用于定义控制器。

### 应用模块

```js
var mainApp = angular.module("mainApp", []);
```

在这里，我们声明了使用 angular.module 函数的应用程序mainApp模块。我们已经传递一个空数组给它。这个数组通常包含依赖模块。

### 控制器模块

```js
mainApp.controller("studentController", function($scope) {
   $scope.student = {
      firstName: "Mahesh",
      lastName: "Parashar",
      fees:500,
      subjects:[
         {name:'Physics',marks:70},
         {name:'Chemistry',marks:80},
         {name:'Math',marks:65},
         {name:'English',marks:75},
         {name:'Hindi',marks:67}
      ],
      fullName: function() {
         var studentObject;
         studentObject = $scope.student;
         return studentObject.firstName + " " + studentObject.lastName;
      }
   };
});
```