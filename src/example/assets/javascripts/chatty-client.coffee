class User
  constructor: (@name,@room)->

class Message
  constructor: (@user_id,@user_name,@text) ->
    @time = new Date().toString()

@Chatty =
  events:
    "message":(message)=>
      @set_message message

    "user:join":(user)=>
      @set_user user

    "user:left":(user)=>
      @set "#{user.name} left the room"
      $("#user-#{user.id}").remove()

    "error":(error)=>
      alert error

  bind : (inputbox, chatbox, messagebox, usersbox) ->
    @socket = io.connect "http://localhost:3000/"
    @form = $(inputbox)
    @chatbox = $(chatbox)
    @message = $(messagebox)
    @users = $(usersbox)

    for event,handler of @events
      @socket.on event,handler

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
    @set "<p>#{user.name} Joined the room</p>"
    @users.append "<li id='user-#{user.id}'>#{user.name}</li>"

  join : (name,room)->
    @user = new User(name, room)

    @socket.emit "user:join", @user, (data)=>
      for message in data.messages
        @set_message message

      console.log(data.users)
      for id,user of data.users
        @set_user user
