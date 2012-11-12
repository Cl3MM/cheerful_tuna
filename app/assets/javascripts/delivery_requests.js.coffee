#jQuery ->
  #Mercury.on 'ready', (event) ->
    #link = $('#mercury_iframe').contents().find('#edit_link')
    #Mercury.saveURL = link.data('save-url')
    #link.hide()

  #Mercury.on'saved', (event) ->
    #window.location = window.location.href.replace(/\/editor\//i, '/')
