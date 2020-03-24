---
title: Gulp的Stream
layout: post
tags: 
  - gulp
categories: gulp
description: 
cover: /assets/images/bg/2.jpg
top_img: 
---


## Stream

你可能也在最初开始使用Gulp的时候就听说过：Gulp是一个有关 *Stream*（数据流）的构建系统。这句话的意思是:

*Gulp本身使用了Node的Stream*。

Stream如其名字所示的“流”那样，就像是工厂的流水线。你要加工一个产品，不用全部在一个位置完成，而是可以拆分成多道工序。产品从第一道工序开始，第一道工序完成后，输出然后流入第二道工序，然后再第三道工序...一方面，大批量的产品需求也不用等到全部完工（这通常很久），而是可以完工一个就拿到一个。另一方面，复杂的加工过程被分割成一系列独立的工序，这些工序可以反复使用，还可以在需要的时候进行替换和重组。这就是Stream的理念。

Stream在Node中的应用十分广泛，几乎所有Node程序都在某种程度上用到了Stream。

## pipe

Stream有一个很基本的操作叫做管道（pipe）。Stream是水流，而管道可以从一个流的输出口，接到另一个流的输入口，从而控制流向。如果用前面的流水线工序来说的话，就是连接工序的传输带了。

Node的Stream有一个方法pipe()，也就是管道操作对应的方法。它一般这样用：

```shell
src.pipe(dest)
```

其中 src 和 dest 都是stream，分别代表源和目标。也就是说，流 src 的输出，将作为输入转到流 dest。此外，这个方法返回目标流（比如这里 .pipe(dest) 返回dest），因此可以链式调用：

```shell
a.pipe(b).pipe(c).pipe(d)
```

## 内存操作

Stream 的整个操作过程，都在内存中进行。因此，相比 Grunt，使用 Stream 的 Gulp 进行多步操作并不需要创建中间文件，可以省去额外的 src 和 dest。

## 事件

Node 的 Stream 都是 Node 事件对象 *EventEmitte* 的实例，它们可以通过 *.on()* 添加事件侦听。

## 类型

在现在的Node里，Stream被分为4类，分别是Readable（只读）、Writable（只写）、Duplex（双向）、 Transform（转换）。其中Duplex就是指可读可写，而Transform也是Duplex，只不过输出是由输入计算得到的，因此算作Duplex的特例。

Readable Stream和Writable Stream分别有不同的API及事件（例如 readable.read() 和 writable.write() ），Duplex Stream和Transform Stream因为是可读可写，因此拥有前两者的全部特性。

## 例子

虽然Node中可以通过 require("stream") 引用 Stream，但比较少会需要这样直接使用。大部分情况下，我们用的是 Stream Consumers，也就是具有 Stream 特性的各种子类。

Node中许多核心包都用到了Stream，它们也是Stream Consumers。以下是一个使用Stream完成文件复制的例子：

```js
var fs = require("fs");
var r = fs.createReadStream("nyanpass.txt");
var w = fs.createWriteStream("nyanpass.copy.txt");
r.pipe(w).on("finish", function(){
  console.log("Write complete.");
});
```

其中，fs.createReadStream()创建了Readable Stream的r，fs.createWriteStream()创建了Writable Stream的w，然后r.pipe(w)这个管道方法就可以完成数据从r到w的流动。

如前文所说，Stream是EventEmitter的实例，因此这里的on()方法为w添加了事件侦听，事件finish是Writable Stream的一个事件，触发于写入操作完成。

<hr />

## Vinyl文件系统
虽然Gulp使用的是Stream，但却不是普通的Node Stream，实际上，Gulp（以及Gulp插件）用的应该叫做Vinyl File Object Stream。

这里的Vinyl，是一种虚拟文件格式。Vinyl主要用两个属性来描述文件，它们分别是路径（path）及内容（contents）。具体来说，Vinyl并不神秘，它仍然是JavaScript Object。Vinyl官方给了这样的示例：

```js
var File = require('vinyl');

var coffeeFile = new File({
  cwd: "/",
  base: "/test/",
  path: "/test/file.coffee",
  contents: new Buffer("test = 123")
});
```

从这段代码可以看出，Vinyl是Object，path和contents也正是这个Object的属性。

### Vinyl的意义

Gulp为什么不使用普通的Node Stream呢？请看这段代码

```js
gulp.task("css", function(){
  gulp.src("./stylesheets/src/**/*.css")
    .pipe(gulp.dest("./stylesheets/dest"));
});
```

虽然这段代码没有用到任何Gulp插件，但包含了我们最为熟悉的gulp.src()和gulp.dest()。这段代码是有效果的，就是将一个目录下的全部.css文件，都复制到了另一个目录。这其中还有一个很重要的特性，那就是所有原目录下的文件树，包含子目录、文件名等，都原封不动地保留了下来。

普通的Node Stream只传输String或Buffer类型，也就是只关注“内容”。但Gulp不只用到了文件的内容，而且还用到了这个文件的相关信息（比如路径）。因此，Gulp的Stream是Object风格的，也就是Vinyl File Object了。到这里，你也知道了为什么有contents、path这样的多个属性了。

### vinyl-fs

Gulp并没有直接使用vinyl，而是用了一个叫做vinyl-fs的模块（和vinyl一样，都是npm）。vinyl-fs相当于vinyl的文件系统适配器，它提供三个方法：.src()、.dest()和.watch()，其中.src()将生成Vinyl File Object，而.dest()将使用Vinyl File Object，进行写入操作。

在Gulp源码index.js中，可以看到这样的对应关系：

```js
var vfs = require('vinyl-fs');
// ...
Gulp.prototype.src = vfs.src;
Gulp.prototype.dest = vfs.dest;
// ...
```

也就是说，gulp.src()和gulp.dest()直接来源于vinyl-fs

### 类型

Vinyl File Object的contents可以有三种类型：Stream、Buffer（二进制数据）、Null（就是JavaScript里的null）。需要注意的是，各类Gulp插件虽然操作的都是Vinyl File Object，但可能会要求不同的类型。

在使用Gulp过程中，可能会碰到incompatible streams的问题

这个问题的原因一般都是Stream与Buffer的类型差异。Stream如前文介绍，特性是可以把数据分成小块，一段一段地传输，而Buffer则是整个文件作为一个整体传输。可以想到，不同的Gulp插件做的事情不同，因此可能不支持某一种类型。例如，gulp-uglify这种需要对JavaScript代码做语法分析的，就必须保证代码的完整性，因此，gulp-uglify只支持Buffer类型的Vinyl File Object。

gulp.src()方法默认会返回Buffer类型，如果想要Stream类型，可以这样指明:

```js
gulp.src("*.js", {buffer: false})
```

<hr />

## Stream转换

为了让Gulp可以更多地利用当前Node生态体系的Stream，出现了许多Stream转换模块。下面介绍一些比较常用的。

### vinyl-source-stream

[vinyl-source-stream](https://www.npmjs.com/package/vinyl-source-stream) 可以把普通的Node Stream转换为Vinyl File Object Stream。这样，相当于就可以把普通Node Stream连接到Gulp体系内。具体用法是

```js
var fs = require("fs");
var source = require('vinyl-source-stream');
var gulp = require('gulp');

var nodeStream = fs.createReadStream("komari.txt");
nodeStream
  .pipe(source("hotaru.txt"))
  .pipe(gulp.dest("./"));
```

这段代码中的Stream管道，作为起始的并不是gulp.src()，而是普通的Node Stream。但经过vinyl-source-stream的转换后，就可以用gulp.dest()进行输出。其中source([filename])就是调用转换，我们知道Vinyl至少要有contents和path，而这里的原Node Stream只提供了contents，因此还要指定一个filename作为path。

vinyl-source-stream中的stream，指的是生成的Vinyl File Object，其contents类型是Stream。类似的，还有vinyl-source-buffer，它的作用相同，只是生成的contents类型是Buffer。

### vinyl-buffer

[vinyl-buffer](https://www.npmjs.com/package/vinyl-buffer) 接收Vinyl File Object作为输入，然后判断其contents类型，如果是Stream就转换为Buffer。

很多常用的Gulp插件如gulp-sourcemaps、gulp-uglify，都只支持Buffer类型，因此vinyl-buffer可以在需要的时候派上用场。

### Gulp错误处理

Gulp有一个比较令人头疼的问题是，如果管道中有任意一个插件运行失败，整个Gulp进程就会挂掉。尤其在使用gulp.watch()做即时更新的时候，仅仅是临时更改了代码产生了语法错误，就可能使得watch挂掉，又需要到控制台里开启一遍。

对错误进行处理就可以改善这个问题。前面提到过，Stream可以通过.on()添加事件侦听。对应的，在可能产生错误的插件的位置后面，加入on("error")，就可以做错误处理：

```js
gulp.task("css", function() {
  return gulp.src(["./stylesheets/src/**/*.scss"])
    .pipe(sass())
    .on("error", function(error) {
      console.log(error.toString());
      this.emit("end");
    })
    .pipe(gulp.dest("./stylesheets/dest"));
});
```

如果你不想这样自己定义错误处理函数，可以考虑gulp-util的.log()方法。

另外，这种方法可能会需要在多个位置加入on("error")，此时推荐gulp-plumber，这个插件可以很方便地处理整个管道内的错误。

据说Gulp下一版本，Gulp 4，将大幅改进Gulp的错误处理功能，敬请期待

## 解答
现在，来回答本文开头的问题吧。

b.bundle()生成了什么，为什么也可以.pipe()？b.bundle()生成了Node Stream中的Readable Stream，而Readable Stream有管道方法pipe()。

为什么不是从gulp.src()开始？Browserify来自Node体系而不是Gulp体系，要结合Gulp和Browserify，适当的做法是先从Browserify生成的普通Node Stream开始，然后再转换为VInyl File Object Stream连接到Gulp体系中。

为什么还要vinyl-source-stream和vinyl-buffer？它们是什么？因为Gulp插件的输入必须是Buffer或Stream类型的Vinyl File Object。它们分别是具有不同功能的Stream转换模块。

添加在中间的.on('error', gutil.log)有什么作用？错误处理，以便调试问题。