---
title: JavaScript的module简史
layout: post
tags: 
  - javascript
categories: javascript
description: 
cover: /assets/images/bg/37.jpeg
top_img: 
---

## JavaScript模块化

最开始,JavaScript 往往作为嵌入到 HTML 页面中的用于控制动画与简单的用户交互的脚本语言，我们习惯于将其直接嵌入到 script 标签中：

```html
<!--html-->
<script type="application/javascript">
  // module1 code
  // module2 code
</script>
```

不过随着单页应用与富客户端的流行，不断增长的代码库也急需合理的代码分割与依赖管理的解决方案，

### 命名空间模式

```js
// file app.js
var app = {};

// file greeting.js
app.helloInLang = {
  en: 'Hello world!',
  es: '¡Hola mundo!',
  ru: 'Привет мир!'
};

// file hello.js
app.writeHello = function (lang) {
  document.write(app.helloInLang[lang]);
};
```

所有数据对象与函数都归属于全局对象 app，不过显而易见这种方式对于大型多人协同项目的可维护性还是较差，并且没有解决模块间依赖管理的问题。

### 依赖注入

Martin Fowler 于 2004 年提出了依赖注入（Dependency Injection）的概念，其主要用于 Java 中的组件内通信；以 Spring 为代表的一系列支持依赖注入与控制反转的框架将这种设计模式发扬光大，并且成为了 Java 服务端开发的标准模式之一。依赖注入的核心思想在于某个模块不需要手动地初始化某个依赖对象，而只需要声明该依赖并由外部框架自动实例化该对象实现并且传递到模块内。而五年之后的 2009 年 Misko Hevery 开始设计新的 JavaScript 框架，并且使用了依赖注入作为其组件间通信的核心机制。这个框架就是引领一时风骚，甚至于说是现代 Web 开发先驱之一的 Angular。Angular 允许我们定义模块，并且在显式地声明其依赖模块而由框架完成自动注入。其核心思想如下所示：

```js
// file greeting.js
angular.module('greeter', [])
  .value('greeting', {
    helloInLang: {
      en: 'Hello world!',
      es: '¡Hola mundo!',
      ru: 'Привет мир!'
    },

    sayHello: function(lang) {
      return this.helloInLang[lang];
    }
  });

// file app.js
angular.module('app', ['greeter'])
  .controller('GreetingController', ['$scope', 'greeting', function($scope, greeting) {
    $scope.phrase = greeting.sayHello('en');
  }]);
```

### CommonJS

在 Node.js 横空出世之前，就已经有很多将运行于客户端浏览器中的 JavaScript 迁移运行到服务端的框架；不过由于缺乏合适的规范，也没有提供统一的与操作系统及运行环境交互的接口，这些框架并未流行开来。2009 年时 Mozilla 的雇员 Kevin Dangoor 发表了博客讨论服务端 JavaScript 代码面临的困境，号召所有有志于规范服务端 JavaScript 接口的志同道合的开发者协同讨论，群策群力，最终形成了 ServerJS 规范；一年之后 ServerJS 重命名为 CommonJS。后来 CommonJS 内的模块规范成为了 Node.js 的标准实现规范 其基本语法为 var commonjs = require("./commonjs");，核心设计模式如下所示：

```js
// file greeting.js
var helloInLang = {
  en: 'Hello world!',
  es: '¡Hola mundo!',
  ru: 'Привет мир!'
};

var sayHello = function (lang) {
  return helloInLang[lang];
}

module.exports.sayHello = sayHello;

// file hello.js
var sayHello = require('./lib/greeting').sayHello;
var phrase = sayHello('en');
console.log(phrase);
```

该模块实现方案主要包含 require 与 module 这两个关键字，其允许某个模块对外暴露部分接口并且由其他模块导入使用。

### AMD

就在 CommonJS 规范火热讨论的同时，很多开发者也关注于如何实现模块的异步加载。Web 应用的性能优化一直是前端工程实践中不可避免的问题，而模块的异步加载以及预加载等机制能有效地优化 Web 应用的加载速度。

```js
// file lib/greeting.js
define(function() {
  var helloInLang = {
    en: 'Hello world!',
    es: '¡Hola mundo!',
    ru: 'Привет мир!'
  };

  return {
    sayHello: function (lang) {
      return helloInLang[lang];
    }
    };
});

// file hello.js
define(['./lib/greeting'], function(greeting) {
    var phrase = greeting.sayHello('en');
    document.write(phrase);
});
```

hello.js 作为整个应用的入口模块，我们使用 define 关键字声明了该模块以及外部依赖；当我们执行该模块代码时，也就是执行 define 函数的第二个参数中定义的函数功能，其会在框架将所有的其他依赖模块加载完毕后被执行。这种延迟代码执行的技术也就保证了依赖的并发加载。从我个人而言，AMD 及其相关技术对于前端开发的工程化进步有着非常积极的意义，不过随着以 npm 为主导的依赖管理机制的统一，越来越多的开发者放弃了使用 AMD 模式。

### UMD

AMD 与 CommonJS 虽然师出同源，但还是分道扬镳，关注于代码异步加载与最小化入口模块的开发者将目光投注于 AMD；而随着 Node.js 以及 Browserify 的流行，越来越多的开发者也接受了 CommonJS 规范。令人扼腕叹息的是，符合 AMD 规范的模块并不能直接运行于实践了 CommonJS 模块规范的环境中，符合 CommonJS 规范的模块也不能由 AMD 进行异步加载，整个 JavaScript 生态圈貌似分崩离析。2011 年中，UMD，也就是 Universal Module Definition 规范正是为了弥合这种不一致性应运而出，其允许在环境中同时使用 AMD 与 CommonJS 规范。Q 算是 UMD 的首个规范实现，其能同时运行于浏览器环境（以脚本标签形式嵌入）与服务端的 Node.js 或者 Narwhal（CommonJS 模块）环境中；稍后，James 也为 Q 添加了对于 AMD 的支持。我们将上述例子中的 greeting.js 改写为同时支持 CommonJS 与 AMD 规范的模块：

```js
(function(define) {
  define(function () {
    var helloInLang = {
      en: 'Hello world!',
      es: '¡Hola mundo!',
      ru: 'Привет мир!'
    };

    return {
      sayHello: function (lang) {
        return helloInLang[lang];
      }
    };
  });
}(
  typeof module === 'object' && module.exports && typeof define !== 'function' ?
  function (factory) { module.exports = factory(); } :
  define
));
```

该模式的核心思想在于所谓的 IIFE（Immediately Invoked Function Expression），该函数会根据环境来判断需要的参数类别，譬如在 CommonJS 环境下上述代码会以如下方式执行：

```js
function (factory) {
  module.exports = factory();
}
```

而如果是在 AMD 模块规范下，函数的参数就变成了 define。正是因为这种运行时的灵活性是我们能够将同一份代码运行于不同的环境中。

### ES2015 Modules

JavaScript 模块规范领域群雄逐鹿，各领风骚，作为 ECMAScript 标准的起草者 TC39 委员会自然也不能置身事外。ES2015 Modules 规范始于 2010 年，主要由 Dave Herman 主导；随后的五年中 David 还参与了 asm.js，emscription，servo，等多个重大的开源项目，也使得 ES2015 Modules 的设计能够从多方面进行考虑与权衡。而最后的模块化规范定义于 2015 年正式发布，也就是被命名为 ES2015 Modules。我们上述的例子改写为 ES2015 Modules 规范如下所示：

```js
// file lib/greeting.js
const helloInLang = {
  en: 'Hello world!',
  es: '¡Hola mundo!',
  ru: 'Привет мир!'
};

export const greeting = {
  sayHello: function (lang) {
    return helloInLang[lang];
  }
};

// file hello.js
import { greeting } from "./lib/greeting";
const phrase = greeting.sayHello("en");
document.write(phrase);
```

ES2015 Modules 作为 JavaScript 官方标准，日渐成为了开发者的主流选择。虽然我们目前还不能直接保证在所有环境（特别是旧版本浏览器）中使用该规范，但是通过 Babel 等转化工具能帮我们自动处理向下兼容。此外 ES2015 Modules 还是有些许被诟病的地方，譬如导入语句只能作为模块顶层的语句出现，不能出现在 function 里面或是 if 里面，并且 import 语句会被提升到文件顶部执行，也就是说在模块初始化的时候所有的 import 都必须已经导入完成，并且 import 的模块名只能是字符串常量，导入的值也是不可变对象；比如说你不能 import { a } from './a' 然后给 a 赋值个其他什么东西。