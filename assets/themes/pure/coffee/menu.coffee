$ ->
  $(document.documentElement)
  .removeClass("nojs")
  .addClass("domready")

$("<div id=\"mask\" data-toggle-menu></div>").appendTo($("#main"))

$('[data-toggle-menu]')
.on 'click', ->
  $(document.body).toggleClass 'menu-open'
  return

$(window).unload ->
  $(document.body).removeClass()