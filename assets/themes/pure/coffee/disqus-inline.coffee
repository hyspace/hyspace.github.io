do ->
  return unless window.disqus_shortname?

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
  ".article-content > pre," +
  ".article-content > div"
  )

  url = window.location.href
  .replace(window.location.hash,'')
  .replace(/\/index.html?$/i,'/')

  container = $("<aside id=\"inline-comments\"></aside>").appendTo($("#main"))

  section = 0
  index = 0
  record = {}
  list.each ()->
    element = @
    $element = $ element
    if $element.prop("tagName") == "H2"
      ++section
      record = {}
    else
      do ->
        tagName = $element.prop("tagName").toLowerCase()
        if record[tagName]?
          index = record[tagName]
        else
          index = record[tagName] = 1
          ++record[tagName]

        identifier = "section-#{section}/#{tagName}-#{index}"
        $element.attr "id", identifier

        $commentElement = $('<div class="inline-comment"></div>')
        commentElement = $commentElement.get(0)
        $commentElement
        .data "identifier", identifier
        .css(
          top: "#{element.offsetTop}px"
          height:"#{element.offsetHeight}px"
        )
        .on "mouseenter", ->
          if Math.abs(element.offsetTop - commentElement.offsetTop) > 1
            $commentElement.css top: "#{element.offsetTop}px"
          if Math.abs(element.offsetHeight - commentElement.offsetHeight) > 1
            $commentElement.css height:"#{element.offsetHeight}px"
          return

        $element
        .on "mouseenter", ->
          $commentElement.addClass "hover"
          if Math.abs(element.offsetTop - commentElement.offsetTop) > 1
            $commentElement.css top: "#{element.offsetTop}px"
          if Math.abs(element.offsetHeight - commentElement.offsetHeight) > 1
            $commentElement.css height:"#{element.offsetHeight}px"
          return
        .on "mouseleave", ->
          $commentElement.removeClass "hover"
          return

        countElement = $("<a rel=\"nofollow\" class=\"count\" href=\"#{identifier}#disqus_thread\" data-disqus-identifier=\"#{url}#{identifier}\"></a>")
        .appendTo($commentElement.appendTo(container))

        return

  container.on "click", ".count", (e)->
    e.preventDefault()
    e.stopPropagation()
    el = $ @
    parent = el.closest(".inline-comment")
    unless parent.hasClass("active")
      $(document.body).addClass("comment-open")
      container.children(".inline-comment.active")
      .removeClass("active")
      .children("iframe").fadeOut()

      parent.addClass("active")
      if parent.children("iframe").length == 0
        identifier = "#{url}#{parent.data("identifier")}"
        title = document.title + " - inline [#{parent.data("identifier")}]"

        iframe = document.createElement 'iframe'
        iframe.allowtransparency = true
        iframe.src = "about:blank"
        parent.get(0).appendChild(iframe)
        iframe.contentWindow.document.open('text/html', 'replace')
        iframe.contentWindow.document.write """<!DOCTYPE html>
        <html>
        <head>
          <link href="//#{window.location.host}/assets/themes/pure/iframe/iframe.css" rel="stylesheet" media="screen">
        </head>
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
          <script src="//#{window.location.host}/assets/themes/pure/iframe/iframeResizer.contentWindow.js"></script>
        </body>
        </html>
        """
        iframe.contentWindow.document.close()

        $(iframe)
        .show()
        .iFrameResize
          log: false
          autoResize: true
          contentWindowBodyMargin:0
          doHeight:true
          doWidth:false
          enablePublicMethods:false
          interval:100
          scrolling:false
      else
        parent.children("iframe").show()
    else
      $(document.body).removeClass("comment-open")
      parent.removeClass("active")
      parent.children("iframe").fadeOut()

  do ->
    s = document.createElement('script')
    s.async = true
    s.type = 'text/javascript'
    s.src = 'http://' + disqus_shortname + '.disqus.com/count.js'
    (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s)