express = require "express"
configure = require "./configure"

app = express.createServer()

configure app

socketio = require "./socket"
socketio.start(app)

app.get '/', (req,res) ->
  res.render 'index'

app.listen 3000
