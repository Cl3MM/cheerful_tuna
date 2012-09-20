# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).parent().prev().val(true)
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

  $('input#check_all').on 'click', (event) ->
    if $(this).is(':checked')
      state = true
      texti = "uncheck all"
    else
      state = false
      texti = "check all"
    $('span#check_all_span').text(texti)
    $(this).attr('checked', state)
    $('input#sort_user_contact').each ->
      $(this).attr('checked', state)

  $('span#options_filter').hide()

  $('a#show_options_filter').on 'click', (event) ->
    $('span#options_filter').fadeToggle(800)

  $('.btn.disabled').each (index) ->
    $(this).attr "href", "#"

  Morris.Line
   element: "user_monthly_activity"
   data: $("#user_monthly_activity").data('stats')
   xkey: 'day'
   ykeys: $("#user_monthly_activity").data('labels')
   labels: $("#user_monthly_activity").data('labels')

  Morris.Line
   element: "user_weekly_activity"
   data: $("#user_weekly_activity").data('stats')
   xkey: 'day'
   ykeys: $("#user_weekly_activity").data('labels')
   labels: $("#user_weekly_activity").data('labels')

  Morris.Donut
   element: "contacts_breakdown_by_user"
   data: $("#contacts_breakdown_by_user").data('stats')
