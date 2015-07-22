jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

$(document).ready ->
  $('#addNewTag').click ->
    $('#skillSet').append $('#new_country_fields.html').html()
    return
  return