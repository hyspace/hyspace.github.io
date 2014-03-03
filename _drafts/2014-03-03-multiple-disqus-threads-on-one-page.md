---
layout: post
title: "Multiple Disqus threads for jekyll based blogs"
tagline: "a better solution using iframe"
tags:
- disqus
- develop
---
{% include JB/setup %}

##Why multiple Disqus threads

When I met [medium](//medium.com) first time, I was shocked that this website looks not only so concise, but also beautiful. No ads, no confusing elements, just the articles. Many detailed design can be found there, including loading progress bar, inline comments, and menubar animation. I didn't know that [medium](//medium.com) was already famous engough, until I found [@fat](https://github.com/fat), one of the founders of [Bootstrap](https://github.com/twbs/bootstrap), is working there. I deside to make my own version of [medium](//medium.com) in my blog. Animations are not difficult for me at all, so I started at the implementation inline comments.

This blog is hosted on [Github pages](http://pages.github.com/), powered by [Jekyll](http://jekyllrb.com/). It's a static site, so no backend supports here. [Disqus](http://disqus.com) provides comments by adding iframes to static pages. So adding multiple Disqus threads can be a solution for inline comments.

Disqus only allow one thread in a page, since it uses unique element `#disqus_thread` as its container, and it used global variables suchas `disqus_identifier`. No official solutions for multiple Disqus threads found, but somebody already noticed that and solved the problem.

##Existing solutions and problems

[Mystrdat's article][1] provides 2 possible ways:

* Using iframes to load Disqus threads
* Using `Disqus.Reset` to switch between threads in one page

wrotes an jQuery library by in the second way. [Demo page] looks good, but it's annoying that main thread disapears when inline thread are opened.

wrotes an article about the first way. Iframe makes it possible to have multiple threads at the same time, so I decided to follow this way.

##first version

There are 3 main work to do:

* Give each passage an unique identifier
* Show / hide comments counts
* Show / hide Disqus threads

###Give each passage an unique identifier

Disqus threads are identified by its disqus_identifier, so each passage should have a unique identifier. We can select all elements that considered as "passages", and simply use automatically increasing number as identifier. This solution works, but when article are modified, for example a new passage are inserted to the head of article, all the following passage's identifier would move, threads will be assigned to wrong passages. There's no simple solution for this, but there is a easy way to lower the possibility that changes make old identifier invalid.

First, devide article into sections. Consider the identifier `section-2-3`, which means "The 3rd passage of section 2", this identifier won't move while section 1, 2 or 4 have any changes. Since `<h1>` is for page header, I can use `<h2>` as divider of sections. We can devide sections to even smaller sections by `<h3>`, and so on.

Second, use different identifier for different elements. The most commonly generated child element is `<p>` in markdown, but `<ol>`, `<ul>` and `<div class="highlight">` are also possible. For example, `section-2-ol-3`, which means "3rd `<ol>` element in section 2. This ensures that when other element changed, `<ol>` elements are not effected.

Please tell me if there are better *simple* ways to deal with this problem.

###Show / hide Disqus threads

From [guide] provided by Disqus, we can get comment counts by loading a script. This script will insert comment count string to certain elements. comment count string can be configure in Disqus admin panel.

Another story is about showing and hiding count. I want see "new comment" button when mouseover corresponding passage element when there are not any comments, and "new comment" button with count number when there are already comments on the passage. It would be better to do this without javascript.

CSS 3 provides `:not` and `:empty` pseudo selector. we can these selector to style the count element. First we set string for zero comment to *empty*. In this way, count element with no

[1]: http://mystrd.at/articles/multiple-disqus-threads-on-one-page/