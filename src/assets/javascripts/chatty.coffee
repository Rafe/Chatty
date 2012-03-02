@Chatty = (inputbox, chatbox, messagebox, usersbox) ->

  socket = io.connect "http://localhost:3000"
  $form = $(inputbox)
  $chatbox = $(chatbox)
  $message = $(messagebox)
  $users = $(usersbox)

  socket.on "message",(message)->
    set message

  socket.on "user:join",(user)->
    set "#{user} Joined the room"
    set_user user

  socket.on "user:left",(user)->
    set "#{user} Left the room"

  socket.on "message:history",(data)->
    data.messages.forEach (message)->
      set message

    data.users.forEach (user) ->
      set "#{user} Joined the room"
      set_user user

  $form.submit ()->
    send $message.val()
    $message.val("")
    false

  set = (message)->
    $chatbox.append "<p>#{message}</p>"

  set_user = (user) ->
    $users.append "<li>#{user}</li>"

  send = (message)->
    set "I say: " + message
    socket.emit "message", message

  join = (user) ->
    @user = user
    socket.emit "user:join", user

  names = ["Jimmy","Alan","Jeremy","Josh","John","James"]
  name = names[Math.floor(Math.random()* 6)]
  join(name)
