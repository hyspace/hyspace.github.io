---
layout: post
title: "Multiple Disqus threads on one page"
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

##Existing solutions

[Mystrdat's article][1] gives 2 possible ways to





[1]: http://mystrd.at/articles/multiple-disqus-threads-on-one-page/