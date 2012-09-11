# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  $('#email_btn').live 'click', (event) ->
    $(this).parent().next().toggle()
    emails = $(this).parent().next().val()
    console.log emails
    window.prompt "Copy to clipboard: Ctrl+C, Enter", emails
    event.preventDefault()
