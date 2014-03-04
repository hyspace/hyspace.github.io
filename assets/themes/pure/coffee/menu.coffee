$('#menu-sidebar').show()

$("<div id=\"mask\" data-toggle-menu></div>").appendTo($("#main"))

$('[data-toggle-menu]')
.on 'click', ->
  $(document.body).toggleClass 'menu-open'
  return

$(document.body)
.on "click", "a", (e)->
  el = $(e.target).closest('a')
  target = el.attr "target"
  dest = el.attr "href"
  if (!target or target.toLowerCase() != "_blank") and dest?
    e.preventDefault()
    $(document.body).removeClass()
    window.location.href = dest
  return
