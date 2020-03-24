---
title: highlightjs在vue中使用的坑
layout: post
tags: 
  - javascript
  - vue
categories: javascript
description: 
cover: /assets/images/bg/12.jpg
top_img: 
---

### highlight.js

之前在弄博客的代码高亮的时候, 使用的是highlight.js这个插件, 当时用的挺好

最近换了一个博客系统, 使用的是 Vue 框架, 但是 highlight.js 这个插件在 Vue 中使用会有一个坑

根据官方文档中说的 在页面引入:

```html
<script src="/path/to/highlight.pack.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
```

这种引入是在首页的加载完成后就初始化 highlight.js.

而我在博客中, 是在文章页面才需要 初始化 highlight.js, 不需要在首页进行初始化(因为首页没有代码块), 所以我使用了 initHighlighting 方法.

然后我就遇到了一个奇怪的问题, 只有在刷新后第一次进入文章页的时候, 代码高亮能正常显示, 第二次, 返回首页后再点击文章进入 页面代码高亮功能就不正常了.

遂去查询解决办法, 花了几个小时, 发现网上说的情况对我来说都不怎么适用, 当时有几篇文章给了我一些思路, 说: vue-router 在路由进行切换的时候 会调用 initHighlighting 方法, 此方法有一段逻辑是判断之前是否被调用过, 如果被调用过, 直接 return, (我判断是因为浏览器的后退事件触发的时候, highlight.js 的实例没有销毁), 所以再次调用的时候, 直接return掉了.

### 解决方法

直接修改 highlight.js 源码的 initHighlighting 方法:

```js
function initHighlighting() {
  if (initHighlighting.called)
    return;
  initHighlighting.called = true;

  var blocks = document.querySelectorAll('pre code');
  ArrayProto.forEach.call(blocks, highlightBlock);
}
```

if (initHighlighting.called) return; 这行注释掉, 直接执行后面的代码即可.