module.exports = (app)->

  io = require('socket.io').listen app

  messages = ["Hello Josh","Hey, What's up?"]
  #message:
  # user_id
  # user_name 
  # text
  # time

  users = []
  # user_id 
  # user_name 
  # img_url

  io.sockets.on "connection", (socket) ->

    socket.on "message", (message) ->
      messages.push(message)
      socket.broadcast.emit "message", socket.user + " say: " + message

    socket.on "user:join", (user) ->
      users.push(user) if user not in users

      socket.emit "message:history",
        "messages": messages
        "users": users

      socket.user = user
      socket.broadcast.emit "user:join", user

    socket.on "user:left", (user) ->
      index = users.indexOf(user)
      users.splice(index,index+1) if index > 0
      socket.broadcast.emit "user:left",
