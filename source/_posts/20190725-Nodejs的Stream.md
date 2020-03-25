---
title: Nodejs的Stream
layout: post
tags: 
  - node
  - javascript
categories: node
description: 
cover: /assets/images/bg/14.jpeg
top_img: 
---

## 流

- 流是一组有序的，有起点和终点的字节数据传输手段。
- 它不关心文件的整体内容，只关注是否从文件中读到了数据，以及读到数据之后的处理。
- 流是一个抽象接口，被 Node 中的很多对象所实现。比如HTTP 服务器request和response对象都是流。
- 流被分为 Readable(可读流)、 Writable(可写流)、 Duplex(双工流)、 Transform(转换流)

## 流中的是什么

- *二进制模式*：每个分块都是buffer、string对象。
- *对象模式*：流内部处理的是一系列普通对象。

## 可读流

> 可读流分为flowing和paused两种模式

### 参数

- path：读取的文件的路径
- option：
  - highWaterMark：水位线，一次可读的字节，一般默认是64k
  - flags：标识，打开文件要做的操作，默认是r
  - encoding：编码，默认为buffer
  - start：开始读取的索引位置
  - end：结束读取的索引位置(包括结束位置)
  - autoClose：读取完毕是否关闭，默认为true

```js
let ReadStream = require('./ReadStream')
//读取的时候默认读64k 
let rs = new ReadStream('./a.txt',{
  highWaterMark: 2,//一次读的字节 默认64k
  flags: 'r',      //标示 r为读 w为写
  autoClose: true, //默认读取完毕后自动关闭
  start: 0,
  end: 5,          //流是闭合区间包start，也包end 默认是读完
  encoding: 'utf8' //默认编码是buffer
})
```

### 方法

data：切换到流动模式，可以流出数据

```js
rs.on('data', function (data) {
    console.log(data);
});
```

open：流打开文件的时候会触发此监听

```js
rs.on('open', function () {
    console.log('文件被打开');
});
```

error：流出错的时候，监听错误信息

```js
rs.on('error', function (err) {
    console.log(err);
});
```

end：流读取完成，触发end

```js
rs.on('end', function (err) {
    console.log('读取完成');
});
```

close：关闭流，触发

```js
rs.on('close', function (err) {
    console.log('关闭');
});
```

pause：暂停流(改变流的flowing，不读取数据了)；resume:恢复流(改变流的flowing,继续读取数据)

```js
//流通过一次后，停止流动，过了2s后再动
rs.on('data', function (data) {
    rs.pause();
    console.log(data);
});
setTimeout(function () {
    rs.resume();
},2000);
```

fs.read()：可读流底层调用的就是这个方法，最原生的读方法

```js
//fd文件描述符，一般通过fs.open中获取
//buffer是读取后的数据放入的缓存目标
//0，从buffer的0位置开始放入
//BUFFER_SIZE，每次放BUFFER_SIZE这么长的长度
//index，每次从文件的index的位置开始读
//bytesRead，真实读到的个数
fs.read(fd,buffer,0,BUFFER_SIZE,index,function(err,bytesRead){

})
```