---
title: react之setState的坑
layout: post
tags: 
  - react
categories: react
description: 
cover: /assets/images/bg/3.jpeg
top_img: 
---

## setState
今天发现有很多文章在说setState的坑,吐槽之声也不少.其实我就碰到过一个 setState不会立即改变数据:

```js
this.setState({
  name: "name"
})
console.log(`name is ${this.state.name}`); // name is ""
```

所以如果需要获取,就需要在回调函数里去做:

```js
this.setState({
  name: "name"
}, () => {
  console.log(`name is ${this.state.name}`)
})
```

这样才会如你所预料那般的输出.

## setState多次,re-render一次

这个是我始料未及的了,我一直以为每次setState都会造成一次re-render.其实并不是这样.

```js
componentDidMount(){
  this.setState((prevState, props) : ({count: this.state.count + 1})) // 1
  this.setState((prevState, props) : ({count: this.state.count + 1})) // 2
  this.setState((prevState, props) : ({count: this.state.count + 1})) // 3
  this.setState({name: "xiaohesong"}) // 4
}

render(){
  console.log("render")
  return(<h1>SetState</h1>)
}
```

可以发现,这里只会出现render两次,而不是想象中的4+1(初始化的render).

## 总结.

1. setState操作, 默认情况下是每次调用, 都会re-render一次, 除非你手动shouldComponentUpdate为false.

2. react为了减少rerender的次数, 会进行一个浅合并. 将多次re-render减少到一次re-render.