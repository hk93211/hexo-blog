---
title: http和https
layout: post
tags: 
  - http
categories: http
description: 
cover: /assets/images/bg/17.jpeg
top_img: 
---

## 前言

最近, 个人博客想加上小绿锁, 也就是安全连接的标识, 但是自己的http相关知识太匮乏了, 所以想去了解一下 http 的相关知识

所以带着一下几个问题去查资料:

- HTTP是什么
- HTTP通信存在什么问题
- HTTPS如何改进HTTP存在那些问题
- HTTPS工作原理是什么

## HTTP是什么

HTTP协议(HyperText Transfer Protocol，超文本传输协议) 是因特网上应用最为广泛的一种网络传输协议, 所有的WWW文件都必须遵守这个标准.

HTTP是一个基于TCP/IP通信协议来传递数据(HTML 文件, 图片文件, 查询结果等)

## HTTPS是什么

HTTPS是在HTTP上建立SSL加密层，并对传输数据进行加密，是HTTP协议的安全版。现在它被广泛用于万维网上安全敏感的通讯，例如交易支付方面。

HTTPS主要作用是：

（1）对数据进行加密，并建立一个信息安全通道，来保证传输过程中的数据安全;

（2）对网站服务器进行真实身份认证。

我们经常会在Web的登录页面和购物结算界面等使用HTTPS通信。使用HTTPS通信时，不再用 http://，而是改用 https://。另外，当浏览器访问HTTPS通信有效的Web网站时，浏览器的地址栏内会出现一个带锁的标记。对HTTPS的显示方式会因浏览器的不同而有所改变。

## HTTP协议存在的哪些问题

- 使用明文通讯

由于HTTP本身不具备加密的功能，所以也无法做到对通信整体（使用HTTP协议通信的请求和响应的内容）进行加密。即，**HTTP报文使用明文（指未经过加密的报文）方式发送, 内容有可能被窃听**。

HTTP明文协议的缺陷是导致数据泄露、数据篡改、流量劫持、钓鱼攻击等安全问题的重要原因。HTTP协议无法加密数据，所有通信数据都在网络中明文“裸奔”。通过网络的嗅探设备及一些技术手段，就可还原HTTP报文内容。

- 无法证明报文的完整性

所谓完整性是指信息的准确度。若无法证明其完整性，通常也就意味着无法判断信息是否准确。由于HTTP协议无法证明通信的报文完整性，因此，在请求或响应送出之后直到对方接收之前的这段时间内，即使请求或响应的内容遭到篡改，也没有办法获悉。换句话说，**没有任何办法确认，发出的请求/响应和接收到的请求/响应是前后相同的(所以可能遭篡改)**。

- 不验证通信方的身份

**HTTP协议中的请求和响应不会对通信方进行确认(因此可能遭遇伪装)**。在HTTP协议通信时，由于不存在确认通信方的处理步骤，任何人都可以发起请求。另外，服务器只要接收到请求，不管对方是谁都会返回一个响应（但也仅限于发送端的IP地址和端口号没有被Web服务器设定限制访问的前提下）

HTTP协议无法验证通信方身份，任何人都可以伪造虚假服务器欺骗用户，实现“钓鱼欺诈”，用户无法察觉。

反观HTTPS协议，它比HTTP协议相比多了以下优势（下文会详细介绍）:

- 数据隐私性：内容经过对称加密，每个连接生成一个唯一的加密密钥
- 数据完整性：内容传输经过完整性校验
- 身份认证：第三方无法伪造服务端（客户端）身份

## HTTPS如何解决HTTP上述问题

HTTPS并非是应用层的一种新协议。只是HTTP通信接口部分用SSL和TLS协议代替而已。

通常，HTTP直接和TCP通信。当使用SSL时，则演变成先和SSL通信，再由SSL和TCP通信了。简言之，**所谓HTTPS，其实就是身披SSL协议这层外壳的HTTP**。

在采用SSL后，HTTP就拥有了HTTPS的加密、证书和完整性保护这些功能。也就是说**HTTP加上加密处理和认证以及完整性保护后即是HTTPS**。

HTTPS 协议的主要功能基本都依赖于 TLS/SSL 协议，TLS/SSL 的功能实现主要依赖于三类基本算法：散列函数 、对称加密和非对称加密，其**利用非对称加密实现身份认证和密钥协商，对称加密算法采用协商的密钥对数据加密，基于散列函数验证信息的完整性**。

## HTTPS工作流程

1. Client发起一个HTTPS (比如 https://xxx.blog.com/login) 的请求，根据RFC2818的规定，Client知道需要连接Server的443（默认）端口。

2. Server把事先配置好的公钥证书（public key certificate）返回给客户端。

3. Client验证公钥证书：比如是否在有效期内，证书的用途是不是匹配Client请求的站点，是不是在CRL吊销列表里面，它的上一级证书是否有效，这是一个递归的过程，直到验证到根证书（操作系统内置的Root证书或者Client内置的Root证书）。如果验证通过则继续，不通过则显示警告信息。

4. Client使用伪随机数生成器生成加密所使用的对称密钥，然后用证书的公钥加密这个对称密钥，发给Server。

5. Server使用自己的私钥（private key）解密这个消息，得到对称密钥。至此，Client和Server双方都持有了相同的对称密钥。

6. Server使用对称密钥加密“明文内容A”，发送给Client。

7. Client使用对称密钥解密响应的密文，得到“明文内容A”。

8. Client再次发起HTTPS的请求，使用对称密钥加密请求的“明文内容B”，然后Server使用对称密钥解密密文，得到“明文内容B”。

## HTTP 和 HTTPS 的区别

HTTP 是明文传输协议，HTTPS 协议是由 SSL+HTTP 协议构建的可进行加密传输、身份认证的网络协议，比 HTTP 协议安全。

关于安全性，用最简单的比喻形容两者的关系就是卡车运货，HTTP下的运货车是敞篷的，货物都是暴露的。而https则是封闭集装箱车，安全性自然提升不少。

- HTTPS比HTTP更加安全，对搜索引擎更友好，利于SEO,谷歌、百度优先索引HTTPS网页;
- HTTPS需要用到SSL证书，而HTTP不用;
- HTTPS标准端口443，HTTP标准端口80;
- HTTPS基于传输层，HTTP基于应用层;
- HTTPS在浏览器显示绿色安全锁，HTTP没有显示;

## 为何不所有的网站都使用HTTPS

首先，很多人还是会觉得HTTPS实施有门槛，这个门槛在于需要权威CA颁发的SSL证书。从证书的选择、购买到部署，传统的模式下都会比较耗时耗力。

其次，HTTPS普遍认为性能消耗要大于HTTP，因为与纯文本通信相比，加密通信会消耗更多的CPU及内存资源。如果每次通信都加密，会消耗相当多的资源，平摊到一台计算机上时，能够处理的请求数量必定也会随之减少。但事实并非如此，用户可以通过性能优化、把证书部署在SLB或CDN，来解决此问题。举个实际的例子，“双十一”期间，全站HTTPS的淘宝、天猫依然保证了网站和移动端的访问、浏览、交易等操作的顺畅、平滑。通过测试发现，经过优化后的许多页面性能与HTTP持平甚至还有小幅提升，因此HTTPS经过优化之后其实并不慢。

除此之外，想要节约购买证书的开销也是原因之一。要进行HTTPS通信，证书是必不可少的。而使用的证书必须向认证机构（CA）购买。

最后是安全意识。相比国内，国外互联网行业的安全意识和技术应用相对成熟，HTTPS部署趋势是由社会、企业、政府共同去推动的。

## HTTP百科

WWW (World Wide Web): 万维网

HTTP (HyperText Transfer Protocol): 超文本传输协议

HTML (HyperText Markup Language): 超文本标记语言

URL (Uniform Resource Locatior): 统一资源定位符

FTP (File Transfer Protocol): 文件传输协议

DNS (Domain Name System): 域名系统

TCP (Transmission Control Protocol): 传输控制协议

UDP (User Data Protocol): 用户数据协议

IP (Internet Protocol): 网络协议

MAC (Media Access Control Address): 媒体访问控制地址，也称为局域网地址 (LAN Address) ，以太网地址 (Ethernet Address) 或物理地址 (Physical Address)

LAN (Local Area Network): 局域网

three-way handshaking: 三次握手

SYN (Synchronize/Synchronize Sequence Numbers): 同步序列编号 => 三次握手第一, 第二次发送

ACK (Acknowledgement): 应答 => 三次握手第二, 第三次发送