---
title: webpack的plugin
layout: post
tags: 
  - webpack
  - 前端工程化
categories: webpack
description: 
cover: /assets/images/bg/6.jpg
top_img: 
---

## generate-json-webpack-plugin

最近在接触一个新的vue项目的时候, 发现项目初始化的时候回去请求一个json配置文件,但是我在开发本地目录找不到对应的 json 配置, 只有几个内容相似的 js 文件, 遂想是否是 webpack 将 js 文件转换成了 json 文件了, 就去看 webpack 配置文件, 发现一个叫 generate-json-webpack-plugin 的插件:

```js
// webpack.config.js
const GenerateJsonPlugin = require('generate-json-webpack-plugin');
 
module.exports = {
  // ...
  plugins: [
    // ...
    new GenerateJsonPlugin('my-file.json', {
      foo: 'bar'
    })
  ]
  // ...
};
```

这将会在 webpack 输出目录创建一个名为: my-file.json 的文件, 内容为:

```js
{"foo": "bar"}
```

generate-json-webpack-plugin 插件还能接收第3和第4个参数, 分别为"*要替换的内容*" 和 "*空格个数*" 功能:

```js
new GenerateJsonPlugin(
  'my-file.json',
  { foo: 'bar', one: 'two' },
  (key, value) => {
    if (value === 'bar') {
      return 'baz'; 
    }
    return value;
  },
  2
)
```

此时 my-file.json 文件的内容为:

```js
{
  "foo": "baz",
  "one": "two"
}
```

## webpack-dev-middleware

Webpack dev middleware 是 WebPack 的一个中间件。它用于在 Express 中分发需要通过 WebPack 编译的文件。单独使用它就可以完成代码的热重载（hot reloading）功能。

### 特性：

- 不会在硬盘中写入文件，完全基于内存实现。
- 如果使用 watch 模式监听代码修改，Webpack 会自动编译，如果在 Webpack 编译过程中请求文件，Webpack dev middleware 会延迟请求，直到编译完成之后再开始发送编译完成的文件。

## webpack-hot-middleware

Webpack hot middleware 它通过订阅 Webpack 的编译更新，之后通过执行 webpack 的 HMR api 将这些代码模块的更新推送给浏览器端。