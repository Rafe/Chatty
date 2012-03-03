module.exports = (app)->

  io = require('socket.io').listen app

  messages = []

  users = {}

  io.sockets.on "connection", (socket) ->

    socket.on "message", (message) ->
      messages.push(message)
      socket.broadcast.emit "message", message

    socket.on "user:join", (user) ->
      users[user.id] = user if user.id not in users

      socket.emit "message:history",
        "messages": messages
        "users": users

      socket.user = user
      socket.broadcast.emit "user:join", user

    socket.on "user:left", (user) ->
      index = users.indexOf(user)
      users.splice(index,index+1) if index > 0
      socket.broadcast.emit "user:left",
