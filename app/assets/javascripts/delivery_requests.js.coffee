jQuery ->
  # Per page selector
  $('#per_page').on 'change', (e) ->
    $(this).closest('form').trigger('submit')

  # Select2 for countries
  if $("#delivery_request_country").length > 0
    $("#delivery_request_country").select2(placeholder: "Select a country")

  # Object that display Select2
  s2_enabler =
    address:      false
    city:         false
    postal_code:  false
    country:      false

  # blank return true if the string is empty
  blank = (value) ->
    ret = if $.trim(value).length == 0 then true else false

  # Choose which Select2 element we will be working on
  window.s2_element = if $('#delivery_request_collection_point_id.joomla').length == 0 then $('#delivery_request_collection_point_id.edit') else $('#delivery_request_collection_point_id.joomla')

  formatCollectionPointResults = (data) ->
    if "name" of data
      return '<span style="width: 100%;"><b>' + data.name + '</b> [' + data.zip + ']<span style="float: right;">' + data.distance + '</span></span>'
    else
      return 'No Collection Point selected'

  formatNoMatches = (e) ->
    #console.log "YEAHHHHAHAHAHAHHHH"
    $('#collection_points_nearbys').addClass("alert")
    $('#collection_points_nearbys').show()
    return "Sorry, no Collection Point near your location."

  find_selected_element = (data, e) ->
    if $.type($.parseJSON(e.val())) == "number"
      for object in data
        for key, value of object
          if key == 'id' and value == $.parseJSON(e.val())
            selection = object
    else
      selection = $.parseJSON(e.val())
    selection = if(typeof selection != 'undefined') then selection else $.parseJSON(e.val())

  # Display Ajax result to the Select2 element
  generic_success = (elem, data) ->
    attrs =
      width: "120%",
      placeholder: "Please select a Collection Point"
      data: { results: data },
      formatSelection: formatCollectionPointResults,
      formatNoMatches: formatNoMatches,
      dropdownCssClass: "njdr"

    if data.length == 0
      formatNoMatches(false)
      attrs =
        width: "120%",
        placeholder: "Sorry, there is no Collection Point in your area.",
        formatNoMatches: formatNoMatches,
        data: []

    if elem.hasClass("edit")
      if data.length > 0
        attrs['initSelection']  = (e, callback) ->
          #console.log 'initSelection'
          #console.log data
          selection = find_selected_element data, e
          callback( selection )
    elem.select2('data', []) if data.length == 0
    elem.select2(attrs)
    elem.select2("enable")

  success = (data) ->
    $('#collection_points_nearbys').hide()
    generic_success(window.s2_element, data)

  # AJAX call to get collection point close to address stored in s2_enabler
  collection_points_nearby = ->
    { address, city, postal_code, country } = s2_enabler
    nearbys = $.ajax
      type: "POST",
      url: "/joomla/delivery_request/nearbys",
      data: { a: address, c: city, p: postal_code, co: country },
      success: success

  unless $('#delivery_request_collection_point_id.joomla').length == 0
    window.s2_element.select2({
      width: "120%",
      placeholder: "Please fill in your address in the above fields",
      query: (data) ->
        false
    })
    window.s2_element.select2("disable")

  # Display Select2 only if edit action
  unless $('#delivery_request_collection_point_id.edit').length == 0
    #original = window.s2_element.data('original')
    s2_enabler =
      address:      $('#delivery_request_address').attr     "value"
      city:         $('#delivery_request_city').attr        "value"
      postal_code:  $('#delivery_request_postal_code').attr "value"
      country:      $('#delivery_request_country').attr     "value"
    window.s2_element.select2({
      width: "120%",
      placeholder: "Please fill in your address in the above fields",
      data: { returns: [] }
    })
    collection_points_nearby()

  check_s2_enabler = ->
    if s2_enabler.address and s2_enabler.city and s2_enabler.country and s2_enabler.postal_code
      collection_points_nearby()
    else
      window.s2_element.select2("disable")

  change = (attr, value) ->
    if attr of s2_enabler #s2_enabler.has_key? attr
      s2_enabler[attr] = if not blank(value) then value else false
    check_s2_enabler()

  $('#delivery_request_address').on 'blur', (e) ->
    change 'address', $(this).val()

  $('#delivery_request_city').on 'blur', (e) ->
    change 'city', $(this).val()

  $('#delivery_request_country').on 'change', (e) ->
    change 'country', $(this).val()

  $('#delivery_request_postal_code').on 'blur', (e) ->
    change 'postal_code', $(this).val()

  $('#delivery_request_collection_point.joomla').on 'open', (e) ->
    check_s2_enabler()

#  $('#delivery_request_address').attr     "value", "43 avenue Lanessan"
#  $('#delivery_request_city').attr        "value", "Champagne au mont d'or"
#  $('#delivery_request_postal_code').attr "value", "69410"
