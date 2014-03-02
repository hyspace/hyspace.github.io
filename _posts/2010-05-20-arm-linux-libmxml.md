---
layout: post
title: libmxml (Mini-XML) arm-linux 移植笔记
tags:
- arm-linux
- Develop
- libmxml
published: true
---
##libmxml (mini-xml)
一个轻量级的xml库，可完成读写。适合系统资源受限的嵌入式设备。

###项目主页
[minixml](http://www.minixml.org/)

###移植过程：
首先准备好交叉编译环境。我使用的是eabi生成的arm-linux-gcc 4.3.2,位于`/usr/local/arm/4.3.2/`；环境变量已经设置`/usr/local/arm/4.3.2/bin`。

主机环境

* linux-mint 8 i386
* arm-linux-gcc 4.3.2 (eabi)
* gcc 4.4

目标机环境

* 友善之臂mini2440开发板
* linux 2.6.31

下载源码，得到`mxml-2.6.tar.gz`

解压，进入`mxmx-2.6`

```shell
./configure --enable-shared --host=arm-linux

make
```

接着make报错:

```shell
Testing library...

./testmxml test.xml > temp1.xml 2 > temp1s.xml

make: *** [testmxml] 错误   2
```

这是测试编译出的可执行文件是否可以正常运行时失败的结果。废话，arm-linux-gcc编译出的东西在主机上显然不能运行。

但是在 Testing library 之前，编译已经全部结束。我们可以直接拿走要用的文件。

有用的文件一共5个：

* `mxml.h` 头文件
* `libmxml.a` 静态链接库文件
* `libmxml.so` 动态链接库的链接文件，链接到`libmxml.so.1.4`
* `libmxml.so.1` 动态链接库的链接文件，链接到`libmxml.so.1.4`
* `libmxml.so.1.4` 动态链接库本体

把库文件复制到交叉编译链所在位置：

我之所以没有在configure的时候直接设定prefix，是因为  eabi生成的编译链的文件结构有点诡异，头的存放目录和库文件存放目录不在一个父目录下。

    mxml.h         → /usr/local/arm/4.3.2/arm-none-linux-gnueabi/libc/usr/include
    libmxml.a      → /usr/local/arm/4.3.2/arm-none-linux-gnueabi/libc/armv4t/lib
    libmxml.so     → /usr/local/arm/4.3.2/arm-none-linux-gnueabi/libc/armv4t/lib
    libmxml.so.1   → /usr/local/arm/4.3.2/arm-none-linux-gnueabi/libc/armv4t/lib
    libmxml.so.1.4 → /usr/local/arm/4.3.2/arm-none-linux-gnueabi/libc/armv4t/lib

对于其他版本的  gcc，路径很可能不一样。在这里我们应该灵活处理。

在交叉编译链所在目录中：

* 搜索头文件最多的目录，用来存放头文件。这个目录下一般有很多子文件夹。如果不行，就在每个有头文件存放的位置都放一个`mxml.h`，以保证编译器能找到该文件
* 搜多存有`.so`文件的目录（一般有多个），每个都把动态链接库和静态链接库的所有文件放进去。以保证编译器能找到。
* 相同的文件存放在多个目录，一定保证这些文件完全一致。即同一次编译的产物。

在库文件和头文件就位后，我们就可以在项目中使用 libmxml 了。

使用方法：

1、添加

```c
#include <mxml.h>
```

2、增加编译参数

例如

```shell
arm-linux-gcc -o test test.c -lmxml -lpthread
```

其中-lpthread是必选参数，因为libmxml库用到了pthread库

在编译时，编译器会优先选择动态链接库编译，这样编译出的文件会小很多。但是同时也需要目标板上有动态链接库支持。如果想静态编译，在编译参数中加上`-static`

为目标机添加动态链接库

将

* libmxml.so
* libmxml.so.1
* libmxml.so.1.4

复制到目标板的库目录，一般为`/lib`或`/usr/lib`

这样，动态编译的文件就能在目标板上运行了。
