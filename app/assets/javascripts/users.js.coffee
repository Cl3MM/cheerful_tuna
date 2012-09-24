jQuery ->
  monthly_chart = Morris.Line
   element: "user_monthly_activity"
   data: $("#user_monthly_activity").data('stats')
   xkey: 'day'
   ykeys: $("#user_monthly_activity").data('labels')
   labels: $("#user_monthly_activity").data('labels')

  weekly_chart = Morris.Line
   element: "user_weekly_activity"
   data: $("#user_weekly_activity").data('stats')
   xkey: 'day'
   ykeys: $("#user_weekly_activity").data('labels')
   labels: $("#user_weekly_activity").data('labels')

  $('#previous_week').on 'click', (event) ->
    date = $('#previous_week').attr('data-date')
    console.log date
    url = '/users/chart/week/' + date
    console.log(url)
    $.post url, (json) ->
      weekly_chart.setData(json.data)
      $('#previous_week').attr('data-date', json.prev_date)
      $('#next_week').attr('data-date', json.next_date)
      $('#week_title').html json.title
      false
    , "json"
    event.preventDefault()

  $('#next_week').on 'click', (event) ->
    date = $('#next_week').attr('data-date')
    console.log date
    url = '/users/chart/week/' + date
    console.log(url)
    $.post url, (json) ->
      weekly_chart.setData(json.data)
      $('#previous_week').attr('data-date', json.prev_date)
      $('#next_week').attr('data-date', json.next_date)
      $('#week_title').html json.title
      console.log(json)
      false
    , "json"
    event.preventDefault()

  $('#previous_month').on 'click', (event) ->
    date = $('#previous_month').attr('data-date')
    console.log date
    url = '/users/chart/month/' + date
    console.log(url)
    $.post url, (json) ->
      monthly_chart.setData(json.data)
      $('#previous_month').attr('data-date', json.prev_date)
      $('#next_month').attr('data-date', json.next_date)
      $('#month_title').html json.title
      false
    , "json"
    event.preventDefault()

  $('#next_month').on 'click', (event) ->
    date = $('#next_month').attr('data-date')
    console.log date
    url = '/users/chart/month/' + date
    console.log(url)
    $.post url, (json) ->
      monthly_chart.setData(json.data)
      $('#previous_month').attr('data-date', json.prev_date)
      $('#next_month').attr('data-date', json.next_date)
      $('#month_title').html json.title
      console.log(json)
      false
    , "json"
    event.preventDefault()
