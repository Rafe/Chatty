class User
  constructor: (@id,@name)->
    @icon = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/174061_1464651440_5371467_q.jpg"

class Message
  constructor: (@user_id,@user_name,@text) ->
    #@time = new Date().getTime()
    @time = new Date().toString()

@Chatty =
  bind : (inputbox, chatbox, messagebox, usersbox) ->
    @socket = io.connect "http://localhost:3000/"
    $form = $(inputbox)
    $chatbox = $(chatbox)
    $message = $(messagebox)
    $users = $(usersbox)

    @socket.on "message",(message)->
      #console.log(message)
      set_message message

    @socket.on "user:join",(user)->
      set_user user

    @socket.on "user:left",(user)->
      set "#{user.name} leaving"

    @socket.on "message:history",(data)->
      data.messages.forEach (message)->
        set_message message

      for id in data.users
        set_user data.users[id]

    $form.submit (event)=>
      event.preventDefault()
      message = new Message(@user.id,@user.name,$message.val())
      $message.val("")
      set_message message
      send message
      false

    set = (text)->
      $chatbox.append text

    set_message = (message) ->
      set "<p><strong>#{message.user_name}:</strong> #{message.text} at #{message.time}</p>"


    set_user = (user) ->
      set "#{user.name} Joined the room"
      $users.append "<li id='user-#{user}'><img src='#{user.icon}' width='40' height='40'>#{user.name}</li>"

    send = (message)->
      @socket.emit "message", message

  join : (name,room)->
    @user = new User(Math.floor(Math.random()*100000000 ), name)
    @socket.emit "user:join", @user
