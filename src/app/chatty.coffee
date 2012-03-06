messages = []
users = {}

module.exports.events = events = (socket)->

  "message": (message)->
    messages.push(message)
    user = socket.user || {room:""}
    socket.broadcast.to(user.room).emit "message", message

  "user:join":(user,callback)->
    users[user.id] = user

    socket.user = user
    socket.join user.room

    callback
      "messages": messages
      "users": users

    socket.broadcast.to(socket.user.room).emit "user:join", user

module.exports = (io)->
  io.sockets.on "connection", (socket) ->
    for event,handler of events(socket)
      socket.on event, handler
