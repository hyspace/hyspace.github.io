---
layout: post
title: "jekyll 404 page on github"
description: ""
tags:
- jekyll
- github
- custom 404 page
---
{% include JB/setup %}

在github pages的说明页中写道：

`Note that Jekyll-generated pages will not work, it must be an html file.`

但事实上，我们还是可以通过jekyll来生成404页的。

首先我们先在根目录创建一个`404.md`文件，布局为page，例如：

    ---
    layout: page
    title: 404
    tagline: Page does't exist
    ---
    {% include JB/setup %}

    * [back to home](/)

jekyll生成的纯静态页面存储在`/_site`目录中，整个网站的最终效果都体现在这个文件夹中的文件中。`404.md`生成的文件在`/_site/404.html`。而github pages的说明页中说，必须在repo的根目录中存放404页才能生效，因此jekyll生成的`404.html`无效。

怎么办呢？

答案就是，把`/_site/404.html`拷贝到根目录`/404.html`就OK了。

以后就是每次Theme中的布局有变化时，记得把根目录的`404.html`更新为`/_site`中的就好了。