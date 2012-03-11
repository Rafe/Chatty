class User
  constructor: (@name,@room)->

class Message
  constructor: (@user_id,@user_name,@text) ->
    @time = new Date().toISOString()

class Chatty

  events:()=>
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

    for event,handler of @events()
      @socket.on event,handler

    @form.submit (event)=>
      event.preventDefault()
      return if @message.val() is ""
      message = new Message(@user.id,@user.name,@message.val())
      @message.val("")
      @set_message message
      @socket.emit "message", message
      false

  message_template : _.template """
    <p><strong><%= user_name%>:</strong> <%= text %> in 
    <abbr class='timeago' title='<%= time %>'/></p>
  """

  user_template: _.template """
    <div id='user-<%=id %>' class='user span1 thumbnail'>
      <img src='http://placehold.it/100x100'/>
      <p><strong><%= name %></strong></p>
    </div>
  """

  set : (text)->
    @chatbox.prepend text

  set_message : (message) ->
    @set @message_template(message)
    $('abbr.timeago').timeago()

  set_user : (user) ->
    @set "<p>#{user.name} Joined the room</p>"
    @users.append @user_template(user)

  join : (name,room)->
    @user = new User(name, room)

    @socket.emit "user:join", @user, (data)=>
      for message in data.messages
        @set_message message

      console.log(data.users)
      for id,user of data.users
        @set_user user

@chatty = new Chatty()
