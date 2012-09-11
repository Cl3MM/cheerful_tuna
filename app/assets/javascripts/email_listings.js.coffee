# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  $('email_btn').live 'click', (event) ->
    alert "Ouai gros !"
    #event.preventDefault()
    #company = $(this).val()
    #if company == ""
      #$(this).focus()
    #else
      #company = company.replace(/\./g, " ")
      ##console.log(company)
      #url = '/members/create_user_name/' + company
      #$.post url, (data) ->
        ##console.log(data)
        #$('#member_user_name').val data
      #, "json"
    false
