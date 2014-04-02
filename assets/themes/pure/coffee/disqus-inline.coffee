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
          <div id="disqus_thread">
            <style type="text/css">
            .disqus-loader, .disqus-loader-wrap{background-image: url(data:image/png;base64,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);}
            .disqus-loader{width: 29px; height: 29px; margin: 11px 14px;  background-position: -54px 0px; background-repeat: no-repeat; animation:disqus-embed-spinner .7s infinite linear;-webkit-animation:disqus-embed-spinner .7s infinite linear}@keyframes disqus-embed-spinner{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}@-webkit-keyframes disqus-embed-spinner{0%{-webkit-transform:rotate(0deg)}100%{-webkit-transform:rotate(360deg)}}
            .disqus-loader-wrap{width: 54px; height: 54px; margin: 0px auto; overflow: hidden; background-repeat: no-repeat;}
            </style>
            <div class="disqus-loader-wrap">
              <div class="disqus-loader">
              </div>
            </div>
          </div>
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
        .fadeIn()
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
        parent.children("iframe").fadeIn()
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