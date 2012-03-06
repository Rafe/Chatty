class User
  constructor: (@id,@name,@room)->
    @icon = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/174061_1464651440_5371467_q.jpg"

class Message
  constructor: (@user_id,@user_name,@text) ->
    @time = new Date().toString()

@Chatty =
  bind : (inputbox, chatbox, messagebox, usersbox) ->
    @socket = io.connect "http://localhost:3000/"
    @form = $(inputbox)
    @chatbox = $(chatbox)
    @message = $(messagebox)
    @users = $(usersbox)

    @socket.on "message",(message)=>
      #console.log(message)
      @set_message message

    @socket.on "user:join",(user)=>
      @set_user user

    @form.submit (event)=>
      event.preventDefault()
      message = new Message(@user.id,@user.name,@message.val())
      @message.val("")
      @set_message message
      @socket.emit "message", message
      false

  set : (text)->
    @chatbox.append text

  set_message : (message) ->
    @set "<p><strong>#{message.user_name}:</strong> #{message.text} at #{message.time}</p>"

  set_user : (user) ->
    @set "#{user.name} Joined the room"
    @users.append "<li id='user-#{user}'><img src='#{user.icon}' width='40' height='40'>#{user.name}</li>"

  join : (name,room)->
    @user = new User(Math.floor(Math.random()*100000000 ), name, room)

    @socket.emit "user:join", @user, (data)=>
      console.log(data)
      for message in data.messages
        @set_message message

      for id,user of data.users
        @set_user user
