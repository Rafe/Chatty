module.exports.start = (app)->

  io = require('socket.io').listen app

  io.sockets.on "connection", (socket) ->
    socket.emit "message", { message:"bar" }

    socket.on "message", (data) ->
      socket.broadcast.emit "message"
      socket.broadcast.json.send data
