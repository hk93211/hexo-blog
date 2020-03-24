---
title: Commit message 和 Change log 编写指南
layout: post
tags: 
  - git
  - 代码规范
categories: git
description: 
cover: /assets/images/bg/6.jpg
top_img: 
---


Git 每次提交代码，都要写 Commit message（提交说明），否则就不允许提交。


```shell
git commit -m "hello world"
```

如果不写 -m 及后面的信息, 命令行会进入 vim 模式, 让你输入详细的 commit 信息

![commit](../../assets/images/commit-vim.jpg)

一般来说, commit 信息应该清晰明了, 

按照 Angular 开发团队的代码提交规范

- [feat]: A new feature
- [fix]: A bug fix
- [docs]: Documentation only changes
- [style]: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- [refactor]: A code change that neither fixes a bug nor adds a feature
- [perf]: A code change that improves performance
- [test]: Adding missing or correcting existing tests
- [chore]: Changes to the build process or auxiliary tools and libraries such as documentation generation

详情可 [参考此处](https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.greljkmo14y0)



## Commit message 的作用

格式化的Commit message，有几个好处。

（1）提供更多的历史信息，方便快速浏览。

可以用以下命令来 快速的查看 commit message 的相关信息

```shell
git log --pretty=format:"%C(auto)%h %ad | %C(auto)%s%d  %Cblue(%an)" --date=short
```

（2）可以过滤某些commit（比如文档改动），便于快速查找信息。

（3）可以直接从commit生成Change log。

## Commit message 的格式

每次提交，Commit message 都包括三个部分：Header，Body 和 Footer。

```
<type>(<scope>): <subject>
// 空一行
<body>
// 空一行
<footer>
```

其中，Header 是必需的，Body 和 Footer 可以省略。

不管是哪一个部分，任何一行都不得超过72个字符（或100个字符）。这是为了避免自动换行影响美观。


## 生成 Change log

[conventional-changelog](https://github.com/ajoslin/conventional-changelog) 就是生成 Change log 的工具，运行下面的命令即可。

```shell
npm install -g conventional-changelog
cd my-project
conventional-changelog -p angular -i CHANGELOG.md -w
```

如果你想生成所有发布的 Change log，要改为运行下面的命令。

```shell
conventional-changelog -p angular -i CHANGELOG.md -w -r 0
```


## reference

https://github.com/angular/angular/commits/master

http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html

https://www.npmjs.com/package/conventional-changelog-cli

https://github.com/ajoslin/conventional-changelog