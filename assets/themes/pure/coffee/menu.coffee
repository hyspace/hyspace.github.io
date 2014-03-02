$('[data-toggle-menu]')
.on 'click', ->
  $(document.body).toggleClass 'menu-open'