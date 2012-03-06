express = require "express"
configure = require "./configure"
chatty = require "./chatty"
app = express.createServer()

configure app

socketio = require "socket.io"
io = socketio.listen app

#RedisStore = socketio.RedisStore
#io.set("store", new RedisStore)

chatty io

app.get '/', (req,res) ->
  res.render 'index'

app.listen 3000
