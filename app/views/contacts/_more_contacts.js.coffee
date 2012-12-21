$('#more_contacts_table').append('<%=j render partial: "more_contacts", formats: [:html] %>')
<% unless @contacts.nil? %>
$('#more_contacts').attr("href", '<%=j more_contacts_path(@contacts.last.previous ) %>')
<% end %>
$('html, body').animate({scrollTop: $(document).height()}, 1500)
