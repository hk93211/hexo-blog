---
title: redux-saga
layout: post
tags: 
  - react
  - redux
categories: react
description: 
cover: /assets/images/bg/31.jpeg
top_img: 
---

## 概述

redux-saga是一个用于管理redux应用异步操作的中间件，redux-saga通过创建sagas将所有异步操作逻辑收集在一个地方集中处理，可以用来代替redux-thunk中间件

- 这意味着应用的逻辑会存在两个地方 (1) reducer负责处理action的stage更新 (2) sagas负责协调那些复杂或者异步的操作

- sagas是通过generator函数来创建的

- sagas可以被看作是在后台运行的进程。sagas监听发起的action，然后决定基于这个action来做什么 (比如：是发起一个异步请求，还是发起其他的action到store，还是调用其他的sagas 等 )

- 在redux-saga的世界里，所有的任务都通过用 yield Effects 来完成 ( effect可以看作是redux-saga的任务单元 )

- Effects 都是简单的 javascript对象，包含了要被 saga middleware 执行的信息

- redux-saga 为各项任务提供了各种 （ Effects创建器 )

- 因为使用了generator函数，redux-saga让你可以用 同步的方式来写异步代码

- redux-saga启动的任务可以在任何时候通过手动来取消，也可以把任务和其他的Effects放到 race 方法里以自动取消

- produce: 生产

- flow: 流动，排出

- 整个流程：ui组件触发action创建函数 ---> action创建函数返回一个action ------> action被传入redux中间件(被 saga等中间件处理) ，产生新的action，传入reducer-------> reducer把数据传给ui组件显示 -----> mapStateToProps ------> ui组件显示

<hr />

## 名词解释

### Effect

一个effect就是一个纯文本javascript对象，包含一些将被saga middleware执行的指令。

- 如何创建 effect ? 使用redux-saga提供的 工厂函数 来创建effect

  - 你可以使用 call(myfunc, 'arg1', 'arg2') 指示middleware调用 myfunc('arg1', 'arg2')

  - 并将结果返回给 yield 了 effect 的那个 generator

### Task

一个 task 就像是一个在后台运行的进程，在基于redux-saga的应用程序中，可以同时运行多个task

- 通过 fork 函数来创建 task

```js
function* saga() {
  ...
  const task = yield fork(otherSaga, ...args)
  ...
}
```

### 阻塞调用 和 非阻塞调用

- 阻塞调用 阻塞调用的意思是： saga 会在 yield 了 effect 后会等待其执行结果返回，结果返回后才恢复执行 generator 中的下一个指令

- 非阻塞调用 非阻塞调用的意思是： saga 会在 yield effect 之后立即恢复执行

### watcher 和 worker

指的是一种使用两个单独的saga来组织控制流的方式

- watcher：监听发起的action 并在每次接收到action时 fork 一个 work

- worker： 处理action，并结束它

### api

> createSagaMiddleware(...sagas)

createSagaMiddleware的作用是创建一个redux中间件，并将sagas与Redux store建立链接

- 参数是一个数组，里面是generator函数列表

- sagas: Array ---- ( generator函数列表 )

<hr />

> middleware.run(saga, ...args)

动态执行 saga。用于 applyMiddleware 阶段之后执行 Sagas。这个方法返回一个 Task 描述对象。

- saga: Function: 一个 Generator 函数
- args: Array: 提供给 saga 的参数 (除了 Store 的 getState 方法)

<hr />

> take(pattern)

----- 暂停Generator，匹配的action被发起时，恢复执行

创建一条 Effect 描述信息，指示 middleware 等待 Store 上指定的 action。 Generator 会暂停，直到一个与 pattern 匹配的 action 被发起。 pattern的规则

1. pattern为空 或者 * ，将会匹配所有发起的action

2. pattern是一个函数，action 会在 pattern(action) 返回为 true 时被匹配 （例如，take(action => action.entities) 会匹配那些 entities 字段为真的 action）。

3. pattern是一个字符串，action 会在 action.type === pattern 时被匹配

4. pattern是一个数组，会针对数组所有项，匹配与 action.type 相等的 action （例如，take([INCREMENT, DECREMENT]) 会匹配 INCREMENT 或 DECREMENT 类型的 action）

<hr />

> fork(fn, ...args)

----- 无阻塞的执行fn，执行fn时，不会暂停Generator ----- yield fork(fn ...args)的结果是一个 Task 对象

task对象 ---------- 一个具备某些有用的方法和属性的对象

创建一条 Effect 描述信息，指示 middleware 以 无阻塞调用 方式执行 fn。

- fn: Function - 一个 Generator 函数, 或者返回 Promise 的普通函数

- args: Array - 一个数组，作为 fn 的参数

- fork 类似于 call，可以用来调用普通函数和 Generator 函数。但 fork 的调用是无阻塞的，在等待 fn 返回结果时，middleware 不会暂停 Generator。 相反，一旦 fn 被调用，Generator 立即恢复执行。

- fork 与 race 类似，是一个中心化的 Effect，管理 Sagas 间的并发。 yield fork(fn ...args) 的结果是一个 Task 对象 —— 一个具备某些有用的方法和属性的对象。

- fork: 是分叉，岔路的意思 ( 并发 )

<hr />

> join(task)

----- 等待fork任务返回结果(task对象)

创建一条 Effect 描述信息，指示 middleware 等待之前的 fork 任务返回结果。

- task: Task - 之前的 fork 指令返回的 Task 对象

- yield fork(fn, ...args) 返回的是一个 task 对象

<hr />

> cancel(task)

创建一条 Effect 描述信息，指示 middleware 取消之前的 fork 任务。

- task: Task - 之前的 fork 指令返回的 Task 对象

- cancel 是一个无阻塞 Effect。也就是说，Generator 将在取消异常被抛出后立即恢复。

<hr />

> select(selector, ...args)

----- 得到 Store 中的 state 中的数据 创建一条 Effect 描述信息，指示 middleware 调用提供的选择器获取 Store state 上的数据（例如，返回 selector(getState(), ...args) 的结果）。

- selector: Function - 一个 (state, ...args) => args 函数. 通过当前 state 和一些可选参数，返回当前 Store state 上的部分数据。

- args: Array - 可选参数，传递给选择器（附加在 getState 后）

- 如果 select 调用时参数为空( --- 即 yield select() --- )，那 effect 会取得整个的 state （和调用 getState() 的结果一样）

> 重要提醒：在发起 action 到 store 时，middleware 首先会转发 action 到 reducers 然后通知 Sagas。这意味着，当你查询 Store 的 state， 你获取的是 action 被处理之后的 state。

<hr />

> put(action)
----- 发起一个 action 到 store 创建一条 Effect 描述信息，指示 middleware 发起一个 action 到 Store。

- action: Object - 完整信息可查看 Redux 的 dispatch 文档

- put 是异步的，不会立即发生

<hr />

> call(fn, ...args) 阻塞执行，call()执行完，才会往下执行

----- 执行 fn(...args) ----- 对比 fork(fn, ...args) 无阻塞执行 创建一条 Effect 描述信息，指示 middleware 调用 fn 函数并以 args 为参数。

- fn: Function - 一个 Generator 函数, 或者返回 Promise 的普通函数

- args: Array - 一个数组，作为 fn 的参数

- fn 既可以是一个普通函数，也可以是一个 Generator 函数

<hr />

> race(effects)

effects: Object : 一个{label: effect, ...}形式的字典对象

同时执行多个任务

当我们需要 yield 一个包含 effects 的数组， generator 会被阻塞直到所有的 effects 都执行完毕，或者当一个 effect 被拒绝 （就像 Promise.all 的行为）时，才会恢复执行Generator函数 ( yield后面的语句 )。