list = $(".article-content > p," +
".article-content > h2," +
".article-content > h3," +
".article-content > h4," +
".article-content > h5," +
".article-content > h6," +
".article-content > ul," +
".article-content > ol," +
".article-content > blockquote," +
".article-content > dl," +
".article-content > pre")

url = window.location.href
.replace(window.location.hash,'')
.replace(/\/index.html?$/i,'/')

container = $('#inline-comments')

section = 0
index = 0
record = {}
list.each ()->
  element = $ @
  if element.prop("tagName") == "H2"
    ++section
    record = {}
  else
    do ->
      tagName = element.prop("tagName").toLowerCase()
      if record[tagName]?
        index = record[tagName]
      else
        index = record[tagName] = 1
        ++record[tagName]

      identifier = "section-#{section}/#{tagName}-#{index}"
      element.attr "id", identifier

      commentElement = $('<div class="inline-comment"></div>')
      .data "identifier", identifier
      .css(
        top: "#{element.get(0).offsetTop}px"
        height:"#{element.get(0).offsetHeight}px"
      )

      element
      .on "mouseenter", ->
        commentElement.addClass "hover"
        return
      .on "mouseleave", ->
        commentElement.removeClass "hover"
        return

      countElement = $("<a class=\"count\" href=\"#{identifier}#disqus_thread\" data-disqus-identifier=\"#{url}#{identifier}\"></a>")
      .appendTo(commentElement.appendTo(container))

      return

container.on "click", ".count", (e)->
  e.preventDefault()
  el = $ @
  parent = el.closest(".inline-comment")
  unless parent.hasClass("active")
    container.children(".inline-comment.active").removeClass("active")
    parent.addClass("active")
    if parent.children("iframe").length == 0
      identifier = encodeURIComponent("#{url}#{parent.data("identifier")}")
      title = encodeURIComponent(document.title)+parent.data("identifier")
      iframe = $("<iframe allowtransparency=\"true\" scrolling=\"no\"></iframe>")
      iframe.attr "src", "/assets/themes/pure/iframe/iframe.html?title=#{title}&identifier=#{identifier}&url=#{identifier}"
      iframe.appendTo(parent)
      iframe.iFrameResize
        log: false
        autoResize: true
        contentWindowBodyMargin:0
        doHeight:true
        doWidth:false
        enablePublicMethods:false
        interval:100
        scrolling:false
  else
    parent.removeClass("active")

do ->
  s = document.createElement('script')
  s.async = true
  s.type = 'text/javascript'
  s.src = 'http://' + disqus_shortname + '.disqus.com/count.js'
  (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s)