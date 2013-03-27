# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('table#invoice > tbody:last').append($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  display_total_price = (e) ->
    $('.input-mini.uprice').each ->
      uprice = $(this).val()
      amount = $(this).parent().next().children().val()
      $(this).parent().next().next().html(amount * uprice)

  display_total_price() if $('.input-mini.uprice').length > 0 

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev().val(true)
    $(this).closest('tr').hide()
    event.preventDefault()

  $('#invoice tbody').on 'blur', 'tr .input-mini.amount', (e) ->
    if $(this).parent().prev().children().val() > 0
      uprice = $(this).val()
      amount = $(this).parent().prev().children().val()
      $(this).parent().next().html(amount * uprice)

  $('#invoice tbody').on 'blur', 'tr .input-mini.uprice', (e) ->
    if $(this).parent().next().children().val() > 0
      uprice = $(this).val()
      amount = $(this).parent().next().children().val()
      $(this).parent().next().next().html(amount * uprice)

