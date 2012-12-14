$('#ContactModal').modal 'hide'

###
<% unless @contact %>
alert "Something went wrong, please reload the page!"
<% else %>
  <% unless @remote.nil? %>
$('#contact_ajax_form').html('<%=j render template: "contacts/ajax_form", formats: [:html] %>')
$('form#new_contact').append('<%= hidden_field_tag "remote", "true" %>')
  <% else %>
$('#contact_ajax_form').html('<%=j render template: "contacts/ajax_form", formats: [:html] %>')
$('form#new_contact').append('<%= hidden_field_tag "remote", "true" %>')
  <% end %>
$('form#new_contact').attr "data-remote", "true"
$('form#new_contact .form-actions').hide()
$('#ContactModal').modal 'show'
<% end %>
###
