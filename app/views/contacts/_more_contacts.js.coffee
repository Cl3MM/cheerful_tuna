$('#more_contacts_table').append('<%=j render partial: "more_contacts", formats: [:html] %>')
<% if @contacts %>
$('#more_contacts').attr("href", '<%=j more_contacts_path(@contacts.last.id - 1 ) %>')
<% end %>
$('html, body').animate({scrollTop: $(document).height()}, 1500)
