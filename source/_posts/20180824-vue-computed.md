---
title: vue-computed
layout: post
tags: 
  - vue
categories: vue
description: 
cover: /assets/images/bg/35.jpeg
top_img: 
---


## 什么是computed 计算属性

所有的计算属性都以函数的形式写在 Vue 实例内的 computed选项内，最终返回计算后的结果, 用于减少模板中的代码臃肿

## 用法

```html
<div id="app">总价: {{price}}</div>

<script>
  const app = new Vue({
  el: '#root',
  template: '<h1>hello world {{text}}</h1>',
  data: {
    money1: 1,
    money2: 2,
  },
  computed: {
    price() {
      return this.money1 + this.money2;
    }
  }
})
</script>
```

还有一种写法(包含getter和setter)

```html
<div id="app">总价: {{price}}</div>

<script>
  const app = new Vue({
  el: '#root',
  template: '<h1>hello world {{text}}</h1>',
  data: {
    money1: 1,
    money2: 2,
  },
  computed: {
    price {
      get() {
        return this.money1 + this.money2;
      },
      set(newValue) {
        this.money1 = newValue / 3 * 1;
        this.money2 = newValue / 3 * 2;
      }
      
    }
  }
})
</script>
```

当执行 this.price = xxx 的时候setter就会被调用

绝大多数情况下，我们只会用默认的 getter方法来读取一个计算属性，在业务中很少用到setter

计算属性还有两个很实用的小技巧容易被忽略:

- 1. 计算属性可以依赖其他计算属性
- 2. 计算属性不仅可以依赖当前 Vue 实例的数据，还可以依赖其他实例的数据，


## 对比methods

计算属性能做到的事情, methods上同样能做到, 那么vue为什么还要定义一个属性来专门用作计算属性用呢?

原因就是: 计算属性是基于它的依赖缓存的。 一个计算属性所依赖的数据发生变化时，它才会重新取值，所以只要计算属性依赖的值不改变，计算属性也就不更新

使用计算属性还是 methods 取决于你是否需要缓存，当遍历大数组和做大量计算时，应当使用 计算属性，除非你不希望得到缓存

> 注意, 类的动态绑定也可以使用计算属性