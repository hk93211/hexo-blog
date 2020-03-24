---
title: Express结合webpack实现HMR
layout: post
tags: 
  - webpack
  - 前端工程化
categories: webpack
description: 
cover: /assets/images/bg/4.jpg
top_img: 
---

## webpack dev server

Webpack dev server 是一个轻量的node.js express服务器，实现了 webpack 编译代码实时输出更新。在前后端分离的前端项目开发中经常用到。

## webpack-dev-middleware

Webpack dev middleware 是 WebPack 的一个中间件。它用于在 Express 中分发需要通过 WebPack 编译的文件。单独使用它就可以完成代码的热重载（hot reloading）功能。

特性：

- 不会在硬盘中写入文件，完全基于内存实现。
- 如果使用 watch 模式监听代码修改，Webpack 会自动编译，如果在 Webpack 编译过程中请求文件，Webpack dev middleware 会延迟请求，直到编译完成之后再开始发送编译完成的文件。

## webpack-hot-middleware

Webpack hot middleware 是 WebPack 的一个中间件, 它通过订阅 Webpack 的编译更新，之后通过执行 webpack 的 HMR api 将这些代码模块的更新推送给浏览器端。

## HMR

HMR 即 Hot Module Replacement 是 Webpack 一个重要的功能。它可以使我们不用通过手动地刷新浏览器页面实现将我们的更新代码实时应用到当前页面中。 HMR 的实现原理是在我们的开发中的应用代码中加入了 HMR Runtime，它是 HMR 的客户端（浏览器端 client）用于和开发服务器通信，接收更新的模块。服务端工作就是前面提到的 Webpack hot middleware 的，它会在代码更新编译完成之后通过以 json 格式输出给HMR Runtime 就会更具 json 中描述来动态更新相应的代码。

## webpack 配置
先在webpack配置文件中引入

```js
var webpack = require('webpack');
var HotMiddleWareConfig = 'webpack-hot-middleware/client?path=/__webpack_hmr&timeout=20000'

module.exports = {
  context: __dirname,
  entry: [
     // 添加一个和HotMiddleWare通信的客户端
    HotMiddleWareConfig,
    // 添加web应用入口文件
    './client.js'
  ],
  output: {
    path: __dirname,
    publicPath: '/',
    filename: 'bundle.js'
  },
  devtool: '#source-map',
  plugins: [
    new webpack.optimize.OccurenceOrderPlugin(),
    // 在 webpack 插件中引入 webpack.HotModuleReplacementPlugin
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
};
```
在我们的开发环境中是这样配置的。getEntries 是自动根据我们规则获取到入口文件并加上 webpack hot middle 配置。

```js
var webpack = require('webpack');
var path = require('path')
var merge = require('webpack-merge')
var baseConfig = require('./webpack.base')
var getEntries = require('./getEntries')

var publicPath = 'http://0.0.0.0:7799/dist/';
var hotMiddlewareScript = 'webpack-hot-middleware/client?reload=true';

var assetsInsert = require('./assetsInsert')

module.exports = merge(baseConfig, {
  entry: getEntries(hotMiddlewareScript),
  devtool: '#eval-source-map',
  output: {
    filename: './[name].[hash].js',
    path: path.resolve('./public/dist'),
    publicPath: publicPath
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"development"'
      }
    }),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new assetsInsert()
  ]
})
```

## Express 中的配置

在 Express 的配置主要就4个步骤：

- 引入 webpack 的配置文件和 生成 webpack 的编译器
- 将编译器连接至 webpack dev middleware
- 将编译器连接至 webpack hot middleware
- 定义 express 配置

```js
var http = require('http');

var express = require('express');

var app = express();

app.use(require('morgan')('short'));

// ************************************
// This is the real meat of the example
// ************************************
(function() {
  // Step 1: 引入 webpack 的配置文件和 生成 webpack 的编译器
  var webpack = require('webpack');
  var webpackConfig = require(process.env.WEBPACK_CONFIG ? process.env.WEBPACK_CONFIG : './webpack.config');
  var compiler = webpack(webpackConfig);
  // Step 2: 将编译器挂载给 webpack dev middleware
  app.use(require("webpack-dev-middleware")(compiler, {
    noInfo: true, publicPath: webpackConfig.output.publicPath
  }));

  // Step 3: 将编译器挂载给 webpack hot middleware
  app.use(require("webpack-hot-middleware")(compiler, {
    log: console.log, path: '/__webpack_hmr', heartbeat: 10 * 1000
  }));
})();

// 定义 express 配置

app.get("/", function(req, res) {
  res.sendFile(__dirname + '/index.html');
});
app.get("/multientry", function(req, res) {
  res.sendFile(__dirname + '/index-multientry.html');
});

if (require.main === module) {
  var server = http.createServer(app);
  server.listen(process.env.PORT || 1616, function() {
    console.log("Listening on %j", server.address());
  });
}
```

要注意的是一定要在定义 express router 前定义 webpack 相关的中间件。还有一点是这里server.js 只是开发环境中使用，在生产环境中我们就不需要再用到它们了。 所以在我们实际的使用中需要通过定义环境变量来区分开发和生产环境

```js
var NODE_ENV = process.env.NODE_ENV || 'production';
var isDev = NODE_ENV === 'development';

if (isDev) {
    var webpack = require('webpack'),
        webpackDevMiddleware = require('webpack-dev-middleware'),
        webpackHotMiddleware = require('webpack-hot-middleware'),
        webpackDevConfig = require('./build/webpack.config.js');

    var compiler = webpack(webpackDevConfig);

    app.use(webpackDevMiddleware(compiler, {
        publicPath: webpackDevConfig.output.publicPath,
        noInfo: true,
        stats: {
            colors: true
        }
    }));
    
    app.use(webpackHotMiddleware(compiler));
    
    routerConfig(app, {
        dirPath: __dirname + '/server/routes/',
        map: {
            'index': '/',
            'api': '/api/*',
            'proxy': '/proxy/*'
        }
    });

    var reload = require('reload');
    var http = require('http');

    var server = http.createServer(app);
    reload(server, app);

    app.use(express.static(path.join(__dirname, 'public')));

    server.listen(port, function(){
        console.log('App (dev) is now running on port ' + port + '!');
    });
} else {
    routerConfig(app, {
        dirPath: __dirname + '/server/routes/',
        map: {
            'index': '/',
            'api': '/api/*',
            'proxy': '/proxy/*'
        }
    });
    app.use(express.static(path.join(__dirname, 'public')));
    
    app.listen(port, function () {
        console.log('App (dev) is now running on port ' + port + '!');
    });
}
```