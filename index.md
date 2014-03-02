---
layout: page
title: hyspace.io
tagline: Blog of Shawn Zhou
---
{% include JB/setup %}


<ul class="article-list">
  {% for post in site.posts limit:10%}
  <li class="article-header">
    <a href="{{ BASE_PATH }}{{post.url}}"><h3>{{ post.title }}{% if post.tagline %}<br><small>{{post.tagline}}</small>{% endif %}</h3></a>
    <time pubdate>{{ post.date | date_to_long_string }}</time>
    {% unless post.tags == empty %}
    <ul role="contentinfo" class="article-tags">
      {% assign tags_list = post.tags %}
      {% include JB/tags_list %}
    </ul>
    {% endunless %}
  </li>
  {% endfor %}
</ul>