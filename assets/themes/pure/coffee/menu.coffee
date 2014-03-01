$('[data-toggle-menu]')
.on 'click', ->
  document.body.classList.toggle 'menu-open'