ready = ->

  ###
  #for adding countries traveled to already
  ###
  $(document).ready ->
    max_fields = 10 #maximum input boxes allowed
    wrapper = $('.traveled_to_wrap') #Fields wrapper
    add_button = $('.add_visited_button') #Add button ID
    x = $(wrapper).find('select').size()
    $(add_button).click (e) ->
      e.preventDefault()
      if x < max_fields
        x++
        $(wrapper).children().last().append '<div class="country_select">'+$('.country_select').last().html()+'</div>'
        $(".country_select").last().find('option').removeAttr("selected")
      return
    $(wrapper).on 'click', '.remove_field', (e) ->
      e.preventDefault()
      if x > 1
        $(this).parent('div').remove()
        x--
      return
    return

  ###
  #for adding countries to visit
  ###
  $(document).ready ->
    max_fields = 10 #maximum input boxes allowed
    wrapper = $('.to_visit_wrap') #Fields wrapper
    add_button = $('.add_to_visit_button') #Add button ID
    x = $(wrapper).find('select').size()
    $(add_button).click (e) ->
      e.preventDefault()
      if x < max_fields
        x++
        $(wrapper).children().last().append '<div class="country_select">'+$('.country_select').last().html()+'</div>'
        $(".country_select").last().find('option').removeAttr("selected")
      return
    $(wrapper).on 'click', '.remove_field', (e) ->
      e.preventDefault()
      if x > 1
        $(this).parent('div').remove()
        x--
      return
    return

  ###*
  # When the send message link on our home page is clicked
  # send an ajax request to our rails app with the sender_id and
  # recipient_id
  ###

  $('.start-conversation').click (e) ->
    e.preventDefault()
    sender_id = $(this).data('sid')
    recipient_id = $(this).data('rip')
    $.post '/conversations', {
      sender_id: sender_id
      recipient_id: recipient_id
    }, (data) ->
      chatBox.chatWith data.conversation_id
      return
    return


  ###*
  # Used to minimize the chatbox
  ###

  $(document).on 'click', '.toggleChatBox', (e) ->
    e.preventDefault()
    id = $(this).data('cid')
    chatBox.toggleChatBoxGrowth id
    return

  ###*
  # Used to close the chatbox
  ###

  $(document).on 'click', '.closeChat', (e) ->
    e.preventDefault()
    id = $(this).data('cid')
    chatBox.close id
    return

  ###*
  # Listen on keypress' in our chat textarea and call the
  # chatInputKey in chat.js for inspection
  ###

  $(document).on 'keydown', '.chatboxtextarea', (event) ->
    id = $(this).data('cid')
    chatBox.checkInputKey event, $(this), id
    return

  ###*
  # When the add favorite button is clicked
  # follows create
  ###
  $(document).on 'click', '.add-favorite', (e) ->
    follower = $('.add-favorite').attr('follower-id')
    following = $('.add-favorite').attr('following-id')
    $.post '/../follow', {
      sid: follower
      rid: following
    }, (data) ->
      return
    $('.add-favorite').text 'Remove from Favorites'
    $('.add-favorite').addClass 'remove-favorite'
    $('.add-favorite').removeClass 'add-favorite'
    return

  ###*
  # When the remove favorite button is clicked
  # follows destroy
  ###
  $(document).on 'click', '.remove-favorite', (e) ->
    e.preventDefault()
    follower = $('.remove-favorite').attr('follower-id')
    following = $('.remove-favorite').attr('following-id')
    $.post '/../unfollow', {
      sid: follower
      rid: following
    }, (data) ->
      return
    $('.remove-favorite').text 'Add To Favorites'
    $('.remove-favorite').addClass 'add-favorite'
    $('.remove-favorite').removeClass 'remove-favorite'
    return

  ###*
  # When a sumit on the edit page occurs
  ###
  $(document).on 'click', '.profile-update', (e) ->
    e.preventDefault()
    password_field = $('#user_password').val()
    password_confirm = $('#user_password_confirmation ').val()
    if password_field == password_confirm
      $.ajax
        url: $(this).parent().attr('action')
        type: $(this).parent().attr('method')
        data: $(this).parent().serialize()
        success: (data) ->
          alert 'Profile Edited Successfully'
          return
        error: (xhr, err) ->
          alert 'Profile Edit Unsuccessfully'
          false
    else
      alert 'Password and Password Confirmation Mismatch'
    return

  ###
  # 
  ###
  $(document).on 'click', '.save-traveled-to', (e) ->
    e.preventDefault()
    id = $('meta[name=\'user-id\']').attr('content')
    list = []
    all_select = $('.traveled_to_wrap').find('select')
    $.each all_select, (index) ->
      list.push $(this).val()
      return
    str = ''
    str = list.join(',')
    $.post('/traveled',
      country_visited: str
      id: id).done (data) ->
      alert 'Data saved'
      return
    return

  ###
  # 
  ###
  $(document).on 'click', '.save-to-visit', (e) ->
    e.preventDefault()
    id = $("meta[name='user-id']").attr("content");
    list = []
    all_select = $('.to_visit_wrap').find('select')
    $.each all_select, (index) ->
      list.push $(this).val()
      return
    str = ''
    str = list.join(',')
    $.post('/want', 
      country_to_visit: str
      id: id).done (data) ->
      alert 'Data Saved.'
      return
    return
  ###*
  # When a conversation link is clicked show up the respective
  # conversation chatbox
  ###

  $('a.conversation').click (e) ->
    e.preventDefault()
    conversation_id = $(this).data('cid')
    chatBox.chatWith conversation_id
    return
  return

$(document).ready ready
$(document).on 'page:load', ready
