---
layout: post
title: Multiple Disqus threads for jekyll based blogs
tagline: a better solution using iframe
tags:
  - disqus
  - develop
published: true
---
{% include JB/setup %}

##Why multiple Disqus threads

When I met [medium](//medium.com) first time, I was shocked that this website looks not only so concise, but also beautiful. No ads, no confusing elements, just the articles. Many detailed design can be found there, including loading progress bar, inline comments, and menubar animation. I didn't know that [medium](//medium.com) was already famous engough, until I found [@fat](https://github.com/fat), one of the founders of [Bootstrap](https://github.com/twbs/bootstrap), is working there. I deside to make my own version of [medium](//medium.com) in my blog. Animations are not difficult for me at all, so I started at the implementation inline comments.

This blog is hosted on [Github pages](http://pages.github.com/), powered by [Jekyll](http://jekyllrb.com/). It's a static site, so no backend supports here. [Disqus](http://disqus.com) provides comments by adding iframes to static pages. So adding multiple Disqus threads can be a solution for inline comments.

However, Disqus only allow one thread in a page, since it uses unique element `#disqus_thread` as its container, and it uses global variables such as `disqus_identifier`. No official solutions for multiple Disqus threads found, but somebody already solved this problem.

##Existing solutions and problems

[Mystrdat's article][1] provides 2 possible ways:

* Using iframes to load Disqus threads
* Using `Disqus.Reset` to switch between threads in one page

[Tsachi Shlidor](https://github.com/tsi) wrotes an [jQuery library of inline comments](https://github.com/tsi/inlineDisqussions) in the second way. [Demo page](http://tsi.github.io/inlineDisqussions/) looks good, but it's annoying that main thread disapears when inline thread are opened.

[Claudio](http://www.devinterface.com/blog/author/claudio/) wrotes [an article about the first way](http://www.devinterface.com/blog/2012/01/how-to-insert-more-disqus-box-in-single-page/). Iframe makes it possible to have multiple threads at the same time, so I decided to follow this way.

##Let's start!

There are 3 main work to do:

* Give each passage an unique identifier
* Show / hide comments counts
* Show / hide Disqus threads

###Give each passage an unique identifier

Disqus threads are identified by its disqus_identifier, so each passage should have a unique identifier. We can select all elements that considered as "passages", and simply use automatically increasing numeric index as identifier. This solution works, but when article are modified, for example a new passage are inserted to the head of article, all the following passage's identifier would move, comment threads will be assigned to wrong passages. There's no simple solution for this, but there is a easy way to lower the possibility that changes make old identifier invalid.

First, devide article into sections. Consider the identifier `section-2-3`, which means "The 3rd passage of section 2", its identifier won't move while section 1, 2 or 4 have any changes. Since `<h1>` is for page header, I can use `<h2>` as divider of sections. We can devide sections to even smaller sections by `<h3>`, and so on.

Second, use different identifier for different elements. The most commonly generated element in markdown is `<p>`, but `<ol>`, `<ul>` and `<div class="highlight">` are also possible. For example, identifier `section-2-ol-3` means "3rd `<ol>` element in section 2. This ensures that when other element changes, `<ol>` elements' identifier are not effected.

Please tell me if there are better *simple* ways to deal with this problem.

###Show / hide comments counts

From [guide] provided by Disqus, we can get comment counts by loading a script. This script will insert comment count string to certain elements. String of comment count can be configure in Disqus admin panel.

Another story is about showing and hiding count. I expect to see no button on passages which has no comments, and button with count number on passages which already has comments. When passages which has no comments are mouseovered, "new comment" button should be displayed. Also it would be better to do this without javascript.

CSS 3 provides `:not` and `:empty` pseudo selector. we can these selector to style the count element. First we set string for zero comment to *empty*. In this way, count element with empty content can be selected by `:empty` and then be styled as invisible.

###Show / hide Disqus threads

This is the most difficult part. There are serveral steps to accomplish this.

1. insert an `iframe` and make Disqus to load correct comment thread in an inner iframe.
2. adjust height of `iframe` when inner iframe's size changes
3. hide `iframe` instead of destory it when user close thread, so we only need initialize `iframe` one time.

####Insert iframe

We should use source of `iframes` that under ours control, so it can't be an cross site one. There are 3 choices.

1. An special static HTML file exists in our jekell blog.
2. base64 url
3. `about:blank`

In the first way, we can include scripts in the special HTML file to communicate with the main page. But there are several shortcomings. First, it will cost at least one more http request to load a thread. The inner iframe's loading will be delayed. Second, this will force user to create an special file in thier blog instead of just change a theme.

The second way is better for that we saved a http request and that no special file is required. But IE doesn't support it.

From [MSDN](http://msdn.microsoft.com/en-us/library/cc848897(v=VS.85).aspx) we know:

> Data URIs are supported only for the following elements and/or attributes.
> - object (images only)
> - img
> - input type=image
> - link
> - CSS declarations that accept a URL, such as background, backgroundImage, and so on.

So the second one is out. Let's discuss the third one. For both iframe with src of dataURL or `about:blank`, the browser consider it as document in the same domain with main page. We can directly control its content by `document.write`. See [Eric Anderson's article](http://sparecycles.wordpress.com/2012/03/08/inject-content-into-a-new-iframe/)

What we should do is to create an iframe with its `src` set to `about:blank`, and then write all its content, including info about thread to load:

```html
<body>
  <div id="disqus_thread"></div>
  <script>
  var disqus_developer = #{window.disqus_developer || 0};
  var disqus_shortname = "#{window.disqus_shortname}";
  var disqus_title = "#{title}";
  var disqus_url = "#{identifier}";
  var disqus_identifier = "#{identifier}";
  (function() {
    var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
    dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
  })();
  </script>
</body>

```

In this way, we are able to pass necessary arguments to `iframe`, and make Disques to load correct thread in `iframe`

####Adjust height

I found an small lib for this: [iframe-resizer](https://github.com/davidjbradshaw/iframe-resizer)

We should include the iframe part of the lib into our `iframe`, and include main file into our main page, so that the height of our `iframe` will be auto set to its content.

####Show and hide `iframe`

This is much simpler. just do it with jQuery.


##Demo page and common lib

The first demo of this is my own blog. Try to add some inline comment in this page!

I havn't, but will write an jQuery lib for this. Wait for it or see [code](https://github.com/hyspace/hyspace.github.io/blob/master/assets/themes/pure/coffee/disqus-inline.coffee) here now for help.


[1]: http://mystrd.at/articles/multiple-disqus-threads-on-one-page/