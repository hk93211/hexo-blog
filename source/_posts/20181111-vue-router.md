---
title: vue-router
layout: post
tags: 
  - vue
categories: vue
description: 
cover: /assets/images/bg/1.jpg
top_img: 
---

## 一. 单页应用

以前我们的网页应用都是输入一个url, 前端会请求后台, 后台返回一个新的html文件, 让前端进行渲染, 现在很多单页应用在浏览器地址栏输入url后, 都是不经过后台的, 仅仅是前端的javascript去处理路由的跳转, 那么我们就需要一个称职合理的路由工具来帮我们完成前端路由跳转的一些相关的工作, 那么现在前端框架都会配备自己的路由处理工具, 像vue 使用的是vue-router, react 使用的是react-router, angularjs 使用的是ng-router和ui-router, 还有不跟框架耦合的工具有 history 等等

## 二. 安装

```shell
npm install vue-router --save-dev
```

## 三. 创建路由相关文件

> routes.js

```js
import Todo from '../views/todo/todo.vue';
import Login from '../views/login/login.vue';

export default [
  {
    path: '/',
    redirect: '/app' // 没有匹配到路由名字的时候重定向
  },
  {
    path: '/app/:id', // 冒号后面是路由参数
    props: true, // 如果是true 的话, 会把:id参数当成props传入到Todo组件内部
    // component: Todo, // 默认写法, 路由使用的组件
    component: () => import('../views/todo/todo.vue'), // 动态加载对应的组件写法
    name: 'app', // 路由名称
    meta: { // 路由的一些乱七八糟的参数
      title: 'this is app',
      description: 'adfadfaf'
    },
    // children: [ // 子路由
    //     {
    //         path: 'test',
    //         component: Login
    //     }
    // ]
    beforeEnter(to, from, next) { // 路由的生命周期方法
      console.log('app router before enter');
      next(); // 一定要执行next方法, 不然进入这个钩子后不会往下执行了
    }
  },
  {
    path: '/login',
    component: () => import('../views/login/login.vue')
  },
  {
    path: '/login/exact',
    component: () => import('../views/login/login.vue')
  }
];
```

<hr />

> router.js

```js
import Router from 'vue-router';

import routes from './routes';

// 为什么要写function 的形式, 而不用对象的形式, 对象的形式我们在其他地方import的时候拿到的都是同一个router对象, 而function的形式就拿的是一个新的创建的new Router 对象, 那么为什么要新拿到新的呢? 因为在服务端渲染的时候如果使用一个路由的对象会导致内存溢出
export default () => {
  return new Router({
    routes
  })
}
```

<hr />

> main.js

```js
import Vue from 'vue';
import App from './app.vue';
import VueRouter from 'vue-router';

import createRouter from './router';

const router = createRouter();

Vue.use(VueRouter);

new Vue({
  el: '#root',
  router,
  render: h => h(App)
})
```

<hr />

> app.vue

```js
app.vue 文件中的 template 中使用 vue-router 提供的内置组件

<router-view/>
在main.js里面使用的跟组件App里面使用vue-router提供的内置的组件<router-view/> , 所有的路由相关的组件都会在这个标签底下进行展示

<router-link/>
路由跳转, 相当于一个a标签, 但是vue-router帮我们处理了其中的一些href的功能, 让其页面跳转的功能变成前端路由跳转的功能
```

## 四. 路由的一些参数配置

### mode(路由的模式)

- hash(默认)

- history

  - 其中history路由默认不会在路由后面加#, 一般用于服务端渲染的情况, 对SEO比较友好

> 注意: 使用history模式的时候还要在 webpack的配置文件中的 devServer 配置中加一行配置 historyApiFallback: {index: '/index.html'} , 否则会显示Cannot get /... (原因为 当用户再前端页面进行手动刷新页面时, 如果没有处理, 输入url后会请求到后台对应的地址, 后台没有对此url进行配置的话就会返回404 cannot get... , 在webpack中配置了historyApiFallback属性的话webpack就会帮我们处理 history路由模式的请求, 拦截到并对应到我们的路由的组件 )

### base

- 默认会在我们写的路有前面加上这个配置的名称
  - 例: base: '/home/',

在浏览器地址栏输入对应的地址的时候, localhost:3000 会跳转到 localhost:3000/home/app(在路由配置文件里配置了 redirect 属性为 '/app' 时)

> 注意: 在使用vue-router提供的一些api进行路由跳转的时候会加上base配置的内容, 但是手动在地址栏输入不带base配置的路由的时候还是能显示出来的, 所以这个不是强制的, (此属性不是很常用)

### linkActiveClass

router-link 标签在激活时的 class , (路由模糊匹配)

### linkExactActiveClass

router-link 标签在激活时的 class , (完全匹配)

### scrollBehavior

```js
scrollBehavior(to, from, savedPosition) {
  // to, from 都是完整的路由对象, 里面包含着完整的路由信息
  if (savedPosition) {
    // 如果之前的页面有过一定的滚动行为, 返回的时候还是在滚动的位置
    return savedPosition;
  } else {
    return { x: 0, y: 0 }
  }
}
```


### parseQuery

自定义将路由上的参数 从字符串转成对象的方法(不常用)

```js
parseQuery(query) {
  // query 是一个字符串, 可以自定义将字符串转对象的方法(虽然vue会自己帮我们处理, 会默认将路由上的query参数字符串转成object, 但是我们仍然可以自定义)
}
```

### stringifyQuery

自定义将的参数 从对象转成路由上的字符串的方法(不常用)
```js
stringifyQuery(obj) {
  // obj 是一个对象, 我们可以自定义将对象转成路由上的字符串的方法(虽然vue会自己帮我们处理, 但是我们仍然可以自定义)
}
```

### fallback:

true 或者 false

设置为true时, 如果浏览器不支持history模式, 会自动帮我们跳回hash模式

## 五. 路由命名

在 routes.js 文件里, 配置name属性, 配置了路由的name后, 可以在 router-link 标签中的 :to属性设置 "{name: 'app'}" 这种写法

## 六. 路由参数

meta: object

```js
{
  title: 'this is app',
  des: 'description'
}
```

children: array

```js
[
  path: 'test',
  component: App,
  children: [
    {
      path: 'test/children1',
      component: TestChildren1
    },
    {
      path: 'test/children2',
      component: TestChildren2
    },
  ]
]
// 注意, 每使用一个children, 对应的当层的component的template中一定要至少一个<router-view></router-view>标签
```

## 七. 路由动画

要想让路由标签的内容有动画显示, 就可以直接在外层包裹一个 `<transition name="fade">` 标签(其中标签的name属性可以自定义), 然后在样式文件中定义几个类:

```js
.fade-enter-active,  .fade-leave-active {
  transition: opacity 0.5s;
}

.fade-enter,  .fade-leave-to {
  opacity: 0
}
```


## 八. 路由传参

在 routes.js 文件中的 path 中使用 ``:id`` 这种形式

路由参数会保存进对应的组件文件中路由参数对象(this.$route)中的 params 属性中

路由的query参数会对应存进组件文件中路由参数对象(this.$route)中的 query 属性中

如果配置props为true 的话, 路由的参数会传到组件的 props 中, 在组件中使用路由中的参数就变的非常方便 

props 还可以传一个对象, 可以自定义要传入的参数:

```js
props: { id: '123', name: 'haha' }
```

props 还可以传一个方法, 可以自定义要传入的参数, 方法接收一个参数, 该参数为完整的route对象, 例:

```js
props: (route) => ({ id: route.query.b })
```

推荐使用此种路由传参的处理方法,尽量不要在组件中使用this.$route 的这种写法, 可以让组件跟路由解耦, 这样组件的复用性会变得更高

## 九. 命名视图

一个页面有两个部分, 在不同的路由下, 显示不同的东西, 要怎么办呢, 就要在>标签上给他命名 例如: 和 < router-view name="b">

在routes.js中 的 component 属性要变成一个对象 components: { a: App, b: Login }

## 十. 导航守卫

在main.js中, 全局导航守卫的钩子函数:

```js
const router = createRouter();

// 其中 to 和 from 为完整的路由对象, next为路由跳转的方法, 如果不调用, 则路由不会往下跳转了
// 此钩子可以做一些数据的校验, 校验不通过则不让路由跳转, 或者跳转到指定的页面
// 在此处理就不用在跳转到了指定的页面后再去判断, 如果跳转后再判断那么逻辑会变得非常复杂, 而且对应的页面都要去加对应的判断
router.beforeEach((to, from, next) => {
  console.log('before each invoked');
  function  checkLogin() {
    // 校验是否登录... 
  }
  if (!checkLogin()) {
    // next('/login');
    // next({ path: '/login' })
    next({ name: 'login', replace: true })
  } else {
    next();
  }
});

// 其中 to 和 from 为完整的路由对象, next为路由跳转的方法, 如果不调用, 则路由不会往下跳转了

router.beforeResolve((to, from, next) => {
    console.log('before resolve invoked');
    next();
});

// 其中 to 和 from 为完整的路由对象, 此处没有next方法, 因为路由已经跳转了
router.afterEach((to, from) => {
    console.log('after each invoked');
});
```
