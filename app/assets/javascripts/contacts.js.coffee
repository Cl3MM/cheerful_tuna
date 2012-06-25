# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('.control-group').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).parent().parent().before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('input#sort_user_contact').on 'click', (event) ->
    id = $(this).val()
    $('tr#contact_table').each ->
      if $(this).attr("value") == id
        $(this).fadeToggle(800)

