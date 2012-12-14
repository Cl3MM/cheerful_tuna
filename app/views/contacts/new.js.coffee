$('#contact_modal .modal-body').html('<%=j render template: "contacts/ajax_form", formats: [:html] %>')
$('form#new_contact').attr "data-remote", "true"
$('form#new_contact .form-actions').empty()
$('form#new_contact .form-actions').hide()
$('form#new_contact .span4.offset1').removeClass "offset1"
$('#contact_modal').modal 'show'
$('#contact_modal .btn.btn-primary').show()
