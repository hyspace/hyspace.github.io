newElement = (tagName="div", className, innderHTML) ->
  el = document.createElement(tagName);
  el.innderHTML = innderHTML if innderHTML?
  el.className = className if className?
  el

list = $("""
.article-content > p,
.article-content > h1,
.article-content > h2,
.article-content > h3,
.article-content > h4,
.article-content > h5,
.article-content > h6,
.article-content > ul,
.article-content > ol,
.article-content > blockquote,
.article-content > dl
""").slice()

container = $('#inline-comments')

for element, index in list
  el = newElement('a', 'comments-count', index)
  el.style.top = "#{element.offsetTop}px"
  container.appendChild(el)
